"""
MediQueue — Appointment lane routes.

Endpoints:
    GET   /appointments/doctors              → search / list doctors
    GET   /appointments/doctors/{id}         → single doctor detail
    GET   /appointments/doctors/{id}/slots   → available slots for a doctor
    POST  /appointments/book                 → book an appointment (conflict-safe)
    PATCH /appointments/{id}/cancel          → cancel an appointment & release slot
"""

from __future__ import annotations

import logging
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query, status
from pydantic import BaseModel, Field

from app.models.schemas import (
    AppointmentResponse,
    AppointmentStatus,
    DoctorResponse,
    SlotResponse,
)
from app.services.appointment_service import (
    book_appointment,
    cancel_appointment,
    get_available_slots,
    get_doctor_by_id,
    search_doctors,
)
from app.core.dependencies import get_current_user

logger = logging.getLogger("mediqueue.routes_appointments")

router = APIRouter(prefix="/appointments", tags=["Appointments"])


# ---------------------------------------------------------------------------
# Request bodies
# ---------------------------------------------------------------------------

class BookAppointmentRequest(BaseModel):
    """POST body for booking an appointment."""
    user_id: UUID
    doctor_id: UUID
    slot_id: UUID


class BookAppointmentResponse(BaseModel):
    """Response after a successful booking."""
    appointment_id: UUID
    user_id: UUID
    doctor_id: UUID
    slot_id: UUID
    status: AppointmentStatus
    message: str = "Appointment booked successfully."


class CancelAppointmentResponse(BaseModel):
    """Response after a successful cancellation."""
    appointment_id: UUID
    status: AppointmentStatus
    message: str = "Appointment cancelled successfully."


# ---------------------------------------------------------------------------
# GET /appointments/doctors — search / list doctors
# ---------------------------------------------------------------------------

@router.get(
    "/doctors",
    response_model=list[DoctorResponse],
    summary="Search doctors",
    description=(
        "Search and filter doctors by specialization, hospital, and availability. "
        "All filters are optional — calling with no params returns all available doctors."
    ),
)
async def list_doctors(
    specialization: str | None = Query(
        None, description="Partial, case-insensitive match on specialization"
    ),
    hospital_id: UUID | None = Query(None, description="Filter by hospital"),
    available_only: bool = Query(True, description="Only return available doctors"),
    current_user: dict = Depends(get_current_user),
):
    doctors = await search_doctors(
        specialization=specialization,
        hospital_id=hospital_id,
        available_only=available_only,
    )
    return doctors


# ---------------------------------------------------------------------------
# GET /appointments/doctors/{doctor_id} — single doctor detail
# ---------------------------------------------------------------------------

@router.get(
    "/doctors/{doctor_id}",
    response_model=DoctorResponse,
    summary="Get doctor details",
    description="Retrieve full details for a single doctor by ID.",
)
async def doctor_detail(doctor_id: UUID, current_user: dict = Depends(get_current_user)):
    return await get_doctor_by_id(doctor_id)


# ---------------------------------------------------------------------------
# GET /appointments/doctors/{doctor_id}/slots — available slots
# ---------------------------------------------------------------------------

@router.get(
    "/doctors/{doctor_id}/slots",
    response_model=list[SlotResponse],
    summary="Available slots for a doctor",
    description="Returns all unbooked time slots for the specified doctor, ordered by start time.",
)
async def available_slots(doctor_id: UUID, current_user: dict = Depends(get_current_user)):
    # Verify doctor exists first
    await get_doctor_by_id(doctor_id)
    slots = await get_available_slots(doctor_id)
    return slots


# ---------------------------------------------------------------------------
# POST /appointments/book — book a slot (conflict-safe)
# ---------------------------------------------------------------------------

@router.post(
    "/book",
    response_model=BookAppointmentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Book an appointment",
    description=(
        "Books an appointment by claiming an available slot. "
        "Returns 409 Conflict if the slot is already taken. "
        "The slot is atomically locked before the appointment is created."
    ),
)
async def book(payload: BookAppointmentRequest, current_user: dict = Depends(get_current_user)):
    if str(payload.user_id) != str(current_user["id"]):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Unauthorized action",
        )
    try:
        appointment = await book_appointment(
            user_id=UUID(str(current_user["id"])),
            doctor_id=payload.doctor_id,
            slot_id=payload.slot_id,
        )
        return BookAppointmentResponse(
            appointment_id=UUID(appointment["id"]),
            user_id=UUID(appointment["user_id"]),
            doctor_id=UUID(appointment["doctor_id"]),
            slot_id=UUID(appointment["slot_id"]),
            status=appointment["status"],
        )
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error booking appointment")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while booking the appointment.",
        ) from exc


# ---------------------------------------------------------------------------
# PATCH /appointments/{appointment_id}/cancel
# ---------------------------------------------------------------------------

@router.patch(
    "/{appointment_id}/cancel",
    response_model=CancelAppointmentResponse,
    summary="Cancel an appointment",
    description=(
        "Cancels an active appointment and releases the slot back to available. "
        "Returns 400 if the appointment is already cancelled or completed."
    ),
)
async def cancel(appointment_id: UUID, current_user: dict = Depends(get_current_user)):
    try:
        updated = await cancel_appointment(appointment_id)
        return CancelAppointmentResponse(
            appointment_id=UUID(updated["id"]),
            status=updated["status"],
        )
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error cancelling appointment %s", appointment_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred while cancelling the appointment.",
        ) from exc
