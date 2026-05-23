"""
MediQueue — Appointment service layer.

Responsibilities:
    1. Doctor discovery — search by specialization, hospital, availability.
    2. Slot retrieval — fetch available (unbooked) slots for a doctor.
    3. Slot booking — with double-booking conflict prevention.
    4. Appointment cancellation — release the slot back to available.
"""

from __future__ import annotations

import logging
from uuid import UUID

from fastapi import HTTPException, status

from app.db.database import supabase
from app.models.schemas import (
    AppointmentCreate,
    AppointmentResponse,
    AppointmentStatus,
    DoctorResponse,
    SlotResponse,
)

logger = logging.getLogger("mediqueue.appointment_service")


# ---------------------------------------------------------------------------
# 1. Doctor discovery
# ---------------------------------------------------------------------------

async def search_doctors(
    specialization: str | None = None,
    hospital_id: UUID | None = None,
    available_only: bool = True,
) -> list[dict]:
    """
    Return doctors matching the given filters.

    Parameters
    ----------
    specialization : str, optional
        Case-insensitive partial match on ``doctors.specialization``.
    hospital_id : UUID, optional
        Exact match on ``doctors.hospital_id``.
    available_only : bool
        If True (default), exclude doctors whose ``availability`` is False.

    Raises HTTPException 503 on database failure.
    """
    try:
        query = supabase.table("doctors").select("*")

        if available_only:
            query = query.eq("availability", True)

        if hospital_id is not None:
            query = query.eq("hospital_id", str(hospital_id))

        if specialization is not None:
            # ilike = case-insensitive LIKE
            query = query.ilike("specialization", f"%{specialization}%")

        response = query.execute()
        return response.data

    except Exception as exc:
        logger.exception("Failed to search doctors")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Doctor data is temporarily unavailable.",
        ) from exc


async def get_doctor_by_id(doctor_id: UUID) -> dict:
    """
    Fetch a single doctor by ID.

    Raises HTTPException 404 if not found.
    """
    try:
        response = (
            supabase
            .table("doctors")
            .select("*")
            .eq("id", str(doctor_id))
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch doctor %s", doctor_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Doctor data is temporarily unavailable.",
        ) from exc

    if not response.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Doctor {doctor_id} not found.",
        )

    return response.data[0]


# ---------------------------------------------------------------------------
# 2. Slot retrieval
# ---------------------------------------------------------------------------

async def get_available_slots(doctor_id: UUID) -> list[dict]:
    """
    Return all unbooked slots for a given doctor, ordered by start_time.

    Raises HTTPException 503 on database failure.
    """
    try:
        response = (
            supabase
            .table("slots")
            .select("*")
            .eq("doctor_id", str(doctor_id))
            .eq("is_booked", False)
            .order("start_time")
            .execute()
        )
        return response.data

    except Exception as exc:
        logger.exception("Failed to fetch slots for doctor %s", doctor_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Slot data is temporarily unavailable.",
        ) from exc


# ---------------------------------------------------------------------------
# 3. Slot booking — with conflict prevention
# ---------------------------------------------------------------------------

async def book_appointment(
    user_id: UUID,
    doctor_id: UUID,
    slot_id: UUID,
) -> dict:
    """
    Book an appointment by claiming a slot.

    Conflict prevention strategy:
        1. Read the slot row and verify ``is_booked`` is False.
        2. Immediately set ``is_booked = True`` (optimistic lock).
        3. Create the appointment row.
        4. If the appointment INSERT fails, roll back the slot to unbooked.

    Raises
    ------
    HTTPException 404
        Slot does not exist.
    HTTPException 409
        Slot is already booked (double-booking attempt).
    HTTPException 500
        Unexpected write failure.
    """

    # ---- 1. Fetch slot & verify availability ----
    try:
        slot_resp = (
            supabase
            .table("slots")
            .select("*")
            .eq("id", str(slot_id))
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch slot %s", slot_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Slot data is temporarily unavailable.",
        ) from exc

    if not slot_resp.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Slot {slot_id} does not exist.",
        )

    slot = slot_resp.data[0]

    # ---- Validate slot belongs to the requested doctor ----
    if slot["doctor_id"] != str(doctor_id):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Slot {slot_id} does not belong to doctor {doctor_id}.",
        )

    # ---- 2. Conflict check ----
    if slot["is_booked"]:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This slot is already booked. Please choose another.",
        )

    # ---- 3. Lock the slot (set is_booked = True) ----
    try:
        lock_resp = (
            supabase
            .table("slots")
            .update({"is_booked": True})
            .eq("id", str(slot_id))
            .eq("is_booked", False)  # conditional update — prevents race condition
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to lock slot %s", slot_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to reserve the slot.",
        ) from exc

    # If no rows were updated, another request beat us to it
    if not lock_resp.data:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="This slot was just booked by another user. Please choose another.",
        )

    # ---- 4. Create the appointment record ----
    appointment_payload = {
        "user_id": str(user_id),
        "doctor_id": str(doctor_id),
        "slot_id": str(slot_id),
        "status": AppointmentStatus.BOOKED.value,
    }

    try:
        appt_resp = (
            supabase
            .table("appointments")
            .insert(appointment_payload)
            .execute()
        )
    except Exception as exc:
        # ---- Rollback: unlock the slot ----
        logger.exception("Failed to create appointment — rolling back slot lock")
        _rollback_slot(slot_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to create appointment record.",
        ) from exc

    if not appt_resp.data:
        _rollback_slot(slot_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Appointment creation returned no data.",
        )

    return appt_resp.data[0]


# ---------------------------------------------------------------------------
# 4. Appointment cancellation
# ---------------------------------------------------------------------------

async def cancel_appointment(appointment_id: UUID) -> dict:
    """
    Cancel an appointment and release the slot back to available.

    Raises
    ------
    HTTPException 404
        Appointment does not exist.
    HTTPException 400
        Appointment is already cancelled or completed.
    """

    # ---- Fetch the appointment ----
    try:
        appt_resp = (
            supabase
            .table("appointments")
            .select("*")
            .eq("id", str(appointment_id))
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch appointment %s", appointment_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="Appointment data is temporarily unavailable.",
        ) from exc

    if not appt_resp.data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Appointment {appointment_id} not found.",
        )

    appointment = appt_resp.data[0]

    # ---- Guard: can only cancel active appointments ----
    non_cancellable = {
        AppointmentStatus.CANCELLED.value,
        AppointmentStatus.COMPLETED.value,
    }
    if appointment["status"] in non_cancellable:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Appointment is already {appointment['status']}.",
        )

    # ---- Update appointment status ----
    try:
        update_resp = (
            supabase
            .table("appointments")
            .update({"status": AppointmentStatus.CANCELLED.value})
            .eq("id", str(appointment_id))
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to cancel appointment %s", appointment_id)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Failed to cancel appointment.",
        ) from exc

    # ---- Release the slot ----
    try:
        supabase.table("slots").update(
            {"is_booked": False}
        ).eq("id", appointment["slot_id"]).execute()
    except Exception:
        # Non-fatal — log and continue. Slot can be manually freed.
        logger.warning(
            "Failed to release slot %s after cancelling appointment %s",
            appointment["slot_id"],
            appointment_id,
        )

    return update_resp.data[0] if update_resp.data else appointment


# ---------------------------------------------------------------------------
# Internal helpers
# ---------------------------------------------------------------------------

def _rollback_slot(slot_id: UUID) -> None:
    """Best-effort rollback: set slot back to unbooked."""
    try:
        supabase.table("slots").update(
            {"is_booked": False}
        ).eq("id", str(slot_id)).execute()
        logger.info("Rolled back slot %s to unbooked", slot_id)
    except Exception:
        logger.exception("CRITICAL: Failed to rollback slot %s — manual fix needed", slot_id)
