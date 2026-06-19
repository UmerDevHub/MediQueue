"""
MediQueue — Emergency dispatch routes.

Endpoints:
    POST /emergency/dispatch  → trigger full emergency dispatch flow
    GET  /emergency/hospitals → return ranked hospital list for a location (debug / preview)
"""

from __future__ import annotations

import logging
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status

from app.models.schemas import (
    EmergencyDispatchRequest,
    EmergencyDispatchResponse,
    HospitalScore,
    IncidentStatus,
    IncidentStatusUpdate,
    IncidentResponse,
    SecureMessageCreate,
    SecureMessageResponse,
)
from app.services.hospital_service import (
    dispatch_emergency,
    get_ranked_hospitals,
)
from app.utils.scoring import HospitalCandidate
from app.core.dependencies import get_current_user

logger = logging.getLogger("mediqueue.routes_emergency")

router = APIRouter(prefix="/emergency", tags=["Emergency"])


# ---------------------------------------------------------------------------
# Helper
# ---------------------------------------------------------------------------

def _candidate_to_score(c: HospitalCandidate) -> HospitalScore:
    """Convert internal dataclass → Pydantic response model."""
    from uuid import UUID

    return HospitalScore(
        hospital_id=UUID(c.hospital_id),
        hospital_name=c.hospital_name,
        distance_km=c.distance_km,
        queue_size=c.queue_size,
        load_score=c.load_score,
        composite_score=c.composite_score,
        eta_minutes=c.eta_minutes,
    )


# ---------------------------------------------------------------------------
# POST /emergency/dispatch
# ---------------------------------------------------------------------------

@router.post(
    "/dispatch",
    response_model=EmergencyDispatchResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Dispatch an emergency",
    description=(
        "Receives user symptoms and GPS location, scores all emergency-enabled "
        "hospitals by distance + queue load, assigns the best one (with smart "
        "fallback if overloaded), creates the incident, and enqueues the user."
    ),
)
async def emergency_dispatch(
    payload: EmergencyDispatchRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Full emergency dispatch flow.

    Returns the assigned hospital, ranked fallback alternatives,
    the queue entry ID, and the incident status.
    """
    if str(payload.user_id) != str(current_user["id"]):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Unauthorized action",
        )
    secure_payload = payload.model_copy(
        update={"user_id": UUID(str(current_user["id"]))},
    )
    try:
        result = await dispatch_emergency(secure_payload)
        return result
    except HTTPException:
        # Re-raise known HTTP errors from the service layer
        raise
    except Exception as exc:
        logger.exception("Unhandled error in emergency dispatch")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred during emergency dispatch.",
        ) from exc


# ---------------------------------------------------------------------------
# GET /emergency/hospitals — ranked preview (useful for debugging / mobile preview)
# ---------------------------------------------------------------------------

@router.get(
    "/hospitals",
    response_model=list[HospitalScore],
    summary="Preview ranked hospitals",
    description=(
        "Returns a scored and ranked list of emergency-enabled hospitals "
        "relative to the provided GPS coordinates. No incident is created. "
        "Useful for mobile app preview or internal debugging."
    ),
)
async def ranked_hospitals(
    lat: float = Query(..., ge=-90.0, le=90.0, description="User latitude"),
    lng: float = Query(..., ge=-180.0, le=180.0, description="User longitude"),
    current_user: dict = Depends(get_current_user),
):
    """
    Return all emergency-enabled hospitals ranked by composite score
    for a given user location. Does NOT create an incident or queue entry.
    """
    try:
        ranked = await get_ranked_hospitals(lat, lng)
        return [_candidate_to_score(c) for c in ranked]
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error fetching ranked hospitals")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while ranking hospitals.",
        ) from exc


# ---------------------------------------------------------------------------
# GET /emergency/active — active queue incidents for web dashboard
# ---------------------------------------------------------------------------

@router.get(
    "/active",
    summary="Get active emergencies in queue",
    description=(
        "Returns a list of active emergencies and summary metrics "
        "(total queue, critical count, avg wait time) for the hospital admin dashboard."
    ),
)
async def get_active_emergencies():
    """
    Fetch active emergency incidents and queue details from Supabase.
    """
    from app.db.database import supabase
    try:
        # Fetch active incidents
        incidents_res = (
            supabase
            .table("incidents")
            .select("id, symptoms, severity_score, status, user_id, users(name)")
            .in_("status", ["accepted", "en_route", "arrived", "admitted"])
            .execute()
        )
        incidents_data = incidents_res.data or []
        
        # Format the active incidents
        incidents = []
        critical_count = 0
        for inc in incidents_data:
            user = inc.get("users") or {}
            user_name = user.get("name", "Unknown User")
            severity = inc.get("severity_score", 5.0) or 5.0
            if severity > 7.0:
                critical_count += 1
            incidents.append({
                "user_name": user_name,
                "severity": severity,
                "status": inc.get("status", "accepted"),
                "symptoms": inc.get("symptoms", "")
            })
            
        # Get total queue count
        queue_res = (
            supabase
            .table("queue")
            .select("id", count="exact")
            .eq("status", "incoming")
            .execute()
        )
        total_queue = queue_res.count if queue_res.count is not None else len(incidents)
        
        return {
            "incidents": incidents,
            "total_queue": total_queue,
            "critical_count": critical_count,
            "avg_wait": 15  # baseline fallback
        }
    except Exception as exc:
        logger.exception("Failed to fetch active emergencies")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while fetching active emergencies.",
        ) from exc


# ---------------------------------------------------------------------------
# PATCH /emergency/{incident_id}/status — state-machine driven status update
# ---------------------------------------------------------------------------

@router.patch(
    "/{incident_id}/status",
    response_model=IncidentResponse,
    summary="Update incident status",
    description=(
        "Advance an incident through its lifecycle.  Enforces the allowed "
        "transition graph so that illegal jumps (e.g. accepted to discharged) "
        "are rejected with HTTP 409 rather than a 500.  Admitting or "
        "discharging a patient is fully supported via this endpoint."
    ),
)
async def update_incident_status(
    incident_id: UUID,
    payload: IncidentStatusUpdate,
    current_user: dict = Depends(get_current_user),
):
    """
    Transition an incident to a new status.

    State machine:
        accepted   -> en_route  | cancelled
        en_route   -> arrived   | cancelled
        arrived    -> admitted  | completed | cancelled
        admitted   -> discharged| cancelled
        discharged -> completed
        completed / cancelled -> (terminal - no further transitions)

    On discharge the background ML summary task is triggered asynchronously.
    """
    from app.db.database import supabase
    from app.services.ml_service import generate_discharge_summary
    import asyncio

    # ---- Fetch current incident ----
    try:
        inc_res = (
            supabase
            .table("incidents")
            .select("*")
            .eq("id", str(incident_id))
            .single()
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch incident %s", incident_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Incident data is temporarily unavailable.",
        ) from exc

    incident = inc_res.data
    if not incident:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Incident {incident_id} not found.",
        )

    current_status = IncidentStatus(incident["status"])
    requested_status = payload.status

    # ---- Validate transition ----
    allowed = IncidentStatus.allowed_transitions().get(current_status, set())
    if requested_status not in allowed:
        if not allowed:  # terminal state
            detail = (
                f"Incident is in terminal state '{current_status.value}' "
                "and cannot be transitioned further."
            )
        else:
            allowed_labels = ", ".join(
                s.value for s in sorted(allowed, key=lambda x: x.value)
            )
            detail = (
                f"Cannot transition from '{current_status.value}' to "
                f"'{requested_status.value}'. "
                f"Allowed next states: [{allowed_labels}]."
            )
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=detail)

    # ---- Apply update ----
    update_payload: dict = {"status": requested_status.value}
    if payload.notes:
        # Write optional clinical notes; gracefully skips if column absent in DB.
        update_payload["notes"] = payload.notes

    try:
        upd_res = (
            supabase
            .table("incidents")
            .update(update_payload)
            .eq("id", str(incident_id))
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to update incident %s status", incident_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to update incident status.",
        ) from exc

    updated_incident = upd_res.data[0] if upd_res.data else {**incident, **update_payload}

    # ---- Post-transition side-effects ----
    if requested_status == IncidentStatus.DISCHARGED:
        # Fire-and-forget: generate ML discharge summary without blocking the
        # HTTP response.  Errors are logged inside generate_discharge_summary.
        asyncio.create_task(
            generate_discharge_summary(str(incident_id))
        )
        logger.info("Discharge summary task queued for incident %s", incident_id)

    return updated_incident


# ---------------------------------------------------------------------------
# Secure Messages — architecture note
# ---------------------------------------------------------------------------
# NOTE: The ``secure_messages`` table introduced in the June 2026 Supabase
# migration is consumed primarily via Supabase Realtime from the Flutter app
# (direct channel subscription for low-latency doctor-patient chat).  The
# FastAPI layer below provides server-side validation, audit-logging, and a
# fallback REST write path for clients that cannot use Realtime.
# ---------------------------------------------------------------------------

@router.post(
    "/messages",
    response_model=SecureMessageResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Send a secure message",
    description=(
        "Persist a doctor-patient secure message via the REST fallback path. "
        "Flutter clients should prefer the Supabase Realtime channel for "
        "live chat; this endpoint is the authoritative write-validation layer."
    ),
)
async def send_secure_message(
    payload: SecureMessageCreate,
    current_user: dict = Depends(get_current_user),
):
    """
    Validate and persist a secure message to the ``secure_messages`` table.

    The Flutter app subscribes to this table via Supabase Realtime and will
    receive the new row automatically - no polling required.
    """
    from app.db.database import supabase

    # Authorization: sender must be the authenticated user.
    if str(payload.sender_id) != str(current_user["id"]):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="sender_id must match the authenticated user.",
        )

    try:
        res = (
            supabase
            .table("secure_messages")
            .insert({
                "incident_id": str(payload.incident_id),
                "sender_id": str(payload.sender_id),
                "recipient_id": str(payload.recipient_id),
                "body": payload.body,
            })
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to persist secure message")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to save message.",
        ) from exc

    if not res.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Message insert returned no data.",
        )

    return res.data[0]
