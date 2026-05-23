"""
MediQueue — Hospital service layer.

Responsibilities:
    1. Fetch emergency-enabled hospitals from Supabase.
    2. Run the scoring / ranking algorithm.
    3. Persist the incident, assign the best hospital, and enqueue.
    4. Return the dispatch result to the caller (route handler).
"""

from __future__ import annotations

import logging
from uuid import UUID

from fastapi import HTTPException, status

from app.db.database import supabase
from app.models.schemas import (
    EmergencyDispatchRequest,
    EmergencyDispatchResponse,
    HospitalScore,
    IncidentStatus,
    QueueStatus,
)
from app.utils.scoring import HospitalCandidate, rank_hospitals

logger = logging.getLogger("mediqueue.hospital_service")


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _candidate_to_schema(c: HospitalCandidate) -> HospitalScore:
    """Convert the internal dataclass to the Pydantic response model."""
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
# Public API
# ---------------------------------------------------------------------------

async def fetch_emergency_hospitals() -> list[dict]:
    """
    Return all hospitals that have emergency intake enabled.

    Raises HTTPException 503 if the database call fails.
    """
    try:
        response = (
            supabase
            .table("hospitals")
            .select("*")
            .eq("emergency_available", True)
            .execute()
        )
        return response.data
    except Exception as exc:
        logger.exception("Failed to fetch hospitals from Supabase")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Hospital data is temporarily unavailable.",
        ) from exc


async def get_ranked_hospitals(
    user_lat: float,
    user_lng: float,
) -> list[HospitalCandidate]:
    """
    Fetch emergency hospitals and return them ranked by composite score.

    Raises HTTPException 404 if no eligible hospital is found.
    """
    hospitals = await fetch_emergency_hospitals()

    if not hospitals:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No emergency-enabled hospitals found in the system.",
        )

    ranked = rank_hospitals(user_lat, user_lng, hospitals)

    if not ranked:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="No hospitals available for emergency dispatch after filtering.",
        )

    return ranked


async def dispatch_emergency(
    request: EmergencyDispatchRequest,
) -> EmergencyDispatchResponse:
    """
    End-to-end emergency dispatch flow:

    1. Rank hospitals by distance + load (with smart fallback).
    2. INSERT a new incident row (status = accepted).
    3. INSERT a queue entry at the best hospital.
    4. UPDATE the hospital's current_queue_size (+1).
    5. Return the dispatch response with the assigned hospital and fallbacks.

    All database writes target Supabase via the REST client.
    """
    # ---- 1. Rank hospitals ----
    ranked = await get_ranked_hospitals(request.lat, request.lng)
    best = ranked[0]

    # ---- 2. Create incident ----
    incident_payload = {
        "user_id": str(request.user_id),
        "symptoms": request.symptoms,
        "severity_score": request.severity_score,
        "lat": request.lat,
        "lng": request.lng,
        "ambulance_required": request.ambulance_required,
        "assigned_hospital_id": best.hospital_id,
        "eta": int(round(best.eta_minutes)),
        "status": IncidentStatus.ACCEPTED.value,
    }

    try:
        incident_resp = (
            supabase
            .table("incidents")
            .insert(incident_payload)
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to create incident")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create incident record.",
        ) from exc

    if not incident_resp.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Incident creation returned no data.",
        )

    incident_row = incident_resp.data[0]
    incident_id = incident_row["id"]

    # ---- 3. Enqueue at the assigned hospital ----
    # Priority score: higher severity → higher priority (inverted for queue ordering)
    priority_score = request.severity_score * 10  # scale 0-100

    queue_payload = {
        "incident_id": incident_id,
        "hospital_id": best.hospital_id,
        "priority_score": priority_score,
        "status": QueueStatus.INCOMING.value,
    }

    try:
        queue_resp = (
            supabase
            .table("queue")
            .insert(queue_payload)
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to create queue entry")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to enqueue user at hospital.",
        ) from exc

    if not queue_resp.data:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Queue entry creation returned no data.",
        )

    queue_entry_id = queue_resp.data[0]["id"]

    # ---- 4. Update hospital queue size (no increment_queue_size RPC in DB) ----
    try:
        supabase.table("hospitals").update(
            {"current_queue_size": best.queue_size + 1},
        ).eq("id", best.hospital_id).execute()
    except Exception:
        logger.warning(
            "Failed to update queue size for hospital %s.",
            best.hospital_id,
        )

    # ---- 5. Build response ----
    assigned = _candidate_to_schema(best)
    fallbacks = [_candidate_to_schema(c) for c in ranked[1:]]

    return EmergencyDispatchResponse(
        incident_id=UUID(incident_id),
        assigned_hospital=assigned,
        fallback_hospitals=fallbacks,
        queue_entry_id=UUID(queue_entry_id),
        status=IncidentStatus.ACCEPTED,
    )
