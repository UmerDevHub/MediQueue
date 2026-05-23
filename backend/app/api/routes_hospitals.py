"""
MediQueue — Hospital discovery and analytics routes.

Endpoints:
    GET /api/v1/hospitals/nearby           → ranked list of nearby hospitals
    GET /api/v1/hospitals/{hospital_id}/wait-time  → ML-predicted wait time
"""

from __future__ import annotations

import logging

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field
from uuid import UUID

from app.core.dependencies import get_current_user
from app.services.hospital_service import get_ranked_hospitals
from app.services.ml_service import predict_wait_time

logger = logging.getLogger("mediqueue.routes_hospitals")

router = APIRouter(prefix="/hospitals", tags=["Hospitals"])


# ---------------------------------------------------------------------------
# Response schemas
# ---------------------------------------------------------------------------

class HospitalRankingItem(BaseModel):
    """A ranked hospital with score details."""
    hospital_id: UUID
    hospital_name: str
    distance_km: float
    queue_size: int
    load_score: float
    composite_score: float
    eta_minutes: float


class NearbyHospitalsResponse(BaseModel):
    """List of nearby hospitals ranked by composite score."""
    hospitals: list[HospitalRankingItem]
    count: int


class WaitTimeResponse(BaseModel):
    """ML-predicted wait time for a hospital."""
    hospital_id: str
    predicted_wait_minutes: float


# ---------------------------------------------------------------------------
# GET /api/v1/hospitals/nearby
# ---------------------------------------------------------------------------

@router.get(
    "/nearby",
    response_model=NearbyHospitalsResponse,
    status_code=status.HTTP_200_OK,
    summary="Get nearby ranked hospitals",
    description=(
        "Fetches emergency-enabled hospitals ranked by proximity, queue load, "
        "and service time. Returns composite scores for each hospital. "
        "Requires JWT authentication."
    ),
)
async def get_nearby_hospitals(
    lat: float = Query(..., description="User latitude"),
    lng: float = Query(..., description="User longitude"),
    current_user: dict = Depends(get_current_user),
):
    """Get ranked list of hospitals near user location."""
    try:
        ranked_candidates = await get_ranked_hospitals(lat, lng)

        hospitals = [
            HospitalRankingItem(
                hospital_id=UUID(c.hospital_id),
                hospital_name=c.hospital_name,
                distance_km=c.distance_km,
                queue_size=c.queue_size,
                load_score=c.load_score,
                composite_score=c.composite_score,
                eta_minutes=c.eta_minutes,
            )
            for c in ranked_candidates
        ]

        return NearbyHospitalsResponse(hospitals=hospitals, count=len(hospitals))

    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Error fetching nearby hospitals")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to fetch hospitals: {exc}",
        ) from exc


# ---------------------------------------------------------------------------
# GET /api/v1/hospitals/{hospital_id}/wait-time
# ---------------------------------------------------------------------------

@router.get(
    "/{hospital_id}/wait-time",
    response_model=WaitTimeResponse,
    status_code=status.HTTP_200_OK,
    summary="Get ML-predicted wait time",
    description=(
        "Returns the ML-predicted wait time in minutes for a specific hospital "
        "based on historical queue load patterns. Uses online incremental learning. "
        "Requires JWT authentication."
    ),
)
async def get_hospital_wait_time(
    hospital_id: str,
    current_user: dict = Depends(get_current_user),
):
    """Get predicted wait time for a hospital using ML model."""
    try:
        # Swagger users sometimes paste quoted UUIDs; normalize to raw UUID string.
        normalized_id = hospital_id.strip().strip('"').strip("'")
        predicted_minutes = await predict_wait_time(normalized_id)

        return WaitTimeResponse(
            hospital_id=normalized_id,
            predicted_wait_minutes=predicted_minutes,
        )

    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Error predicting wait time for hospital_id=%s", hospital_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Failed to predict wait time: {exc}",
        ) from exc
