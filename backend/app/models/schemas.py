"""
MediQueue — Pydantic schemas for all 8 database tables.

Convention:
  - *Base   → shared field definitions (reusable core fields)
  - *Create → request body for INSERT operations (no id / timestamps)
  - *Response → full row as returned from Supabase (includes id + timestamps)

Extra models:
  - EmergencyDispatchRequest → POST body for /emergency/dispatch
  - HospitalScore            → scored hospital result returned by the ranking algorithm
"""

from __future__ import annotations

from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, Field, EmailStr, ConfigDict


# ---------------------------------------------------------------------------
# Enums
# ---------------------------------------------------------------------------

class UserRole(str, Enum):
    """Allowed values for users.role (Postgres enum user_role)."""
    USER = "user"
    DOCTOR = "doctor"
    HOSPITAL_ADMIN = "hospital_admin"
    SUPER_ADMIN = "super_admin"


class IncidentStatus(str, Enum):
    """Lifecycle states for an emergency incident (Postgres enum incident_status)."""
    ACCEPTED = "accepted"
    EN_ROUTE = "en_route"
    ARRIVED = "arrived"
    COMPLETED = "completed"
    CANCELLED = "cancelled"


class QueueStatus(str, Enum):
    """Status of a queue entry (Postgres enum queue_status)."""
    INCOMING = "incoming"
    DONE = "done"


class AppointmentStatus(str, Enum):
    """Status of a booked appointment (Postgres enum appointment_status)."""
    BOOKED = "booked"
    CANCELLED = "cancelled"
    COMPLETED = "completed"


# ---------------------------------------------------------------------------
# 1. Users
# ---------------------------------------------------------------------------

class UserBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    phone: str = Field(..., min_length=1, max_length=20)
    email: EmailStr
    role: UserRole = UserRole.USER


class UserCreate(UserBase):
    password: str = Field(..., min_length=8, max_length=128)


class UserResponse(UserBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    created_at: datetime


# ---------------------------------------------------------------------------
# 2. Hospitals
# ---------------------------------------------------------------------------

class HospitalBase(BaseModel):
    name: str = Field(..., min_length=1, max_length=255)
    address: str = Field(..., min_length=1)
    lat: float = Field(..., ge=-90.0, le=90.0)
    lng: float = Field(..., ge=-180.0, le=180.0)
    emergency_available: bool = True
    avg_service_time: Optional[float] = Field(
        None,
        ge=0.0,
        description="Average user service time in minutes.",
    )
    current_queue_size: int = Field(default=0, ge=0)


class HospitalCreate(HospitalBase):
    pass


class HospitalResponse(HospitalBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    created_at: datetime


# ---------------------------------------------------------------------------
# 3. Incidents (Emergency)
# ---------------------------------------------------------------------------

class IncidentBase(BaseModel):
    symptoms: str = Field(..., min_length=1)
    severity_score: float = Field(..., ge=0.0, le=10.0)
    lat: float = Field(..., ge=-90.0, le=90.0)
    lng: float = Field(..., ge=-180.0, le=180.0)
    ambulance_required: bool = False


class IncidentCreate(IncidentBase):
    user_id: UUID


class IncidentResponse(IncidentBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    user_id: UUID
    eta: Optional[float] = Field(None, description="Estimated time of arrival in minutes.")
    assigned_hospital_id: Optional[UUID] = None
    status: IncidentStatus = IncidentStatus.ACCEPTED
    created_at: datetime


# ---------------------------------------------------------------------------
# 4. Queue
# ---------------------------------------------------------------------------

class QueueBase(BaseModel):
    incident_id: UUID
    hospital_id: UUID
    priority_score: float = Field(..., ge=0.0)


class QueueCreate(QueueBase):
    status: QueueStatus = QueueStatus.INCOMING


class QueueResponse(QueueBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    status: QueueStatus
    created_at: datetime


# ---------------------------------------------------------------------------
# 5. Hospital Load Log (read-only — populated by Postgres trigger)
# ---------------------------------------------------------------------------

class HospitalLoadLogResponse(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    hospital_id: UUID
    queue_size: int
    recorded_at: datetime


# ---------------------------------------------------------------------------
# 6. Doctors
# ---------------------------------------------------------------------------

class DoctorBase(BaseModel):
    hospital_id: UUID
    name: str = Field(..., min_length=1, max_length=255)
    specialization: str = Field(..., min_length=1, max_length=255)
    license_number: str = Field(..., min_length=1, max_length=100)
    availability: bool = True


class DoctorCreate(DoctorBase):
    pass


class DoctorResponse(DoctorBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    created_at: datetime


# ---------------------------------------------------------------------------
# 7. Slots
# ---------------------------------------------------------------------------

class SlotBase(BaseModel):
    doctor_id: UUID
    start_time: datetime
    end_time: datetime
    is_booked: bool = False


class SlotCreate(SlotBase):
    pass


class SlotResponse(SlotBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID


# ---------------------------------------------------------------------------
# 8. Appointments
# ---------------------------------------------------------------------------

class AppointmentBase(BaseModel):
    user_id: UUID
    doctor_id: UUID
    slot_id: UUID


class AppointmentCreate(AppointmentBase):
    status: AppointmentStatus = AppointmentStatus.BOOKED


class AppointmentResponse(AppointmentBase):
    model_config = ConfigDict(from_attributes=True)

    id: UUID
    status: AppointmentStatus
    created_at: datetime


# ---------------------------------------------------------------------------
# Emergency Dispatch — request / response helpers
# ---------------------------------------------------------------------------

class EmergencyDispatchRequest(BaseModel):
    """POST body sent by the mobile app to trigger emergency dispatch."""
    user_id: UUID
    symptoms: str = Field(..., min_length=1)
    severity_score: float = Field(..., ge=0.0, le=10.0)
    lat: float = Field(..., ge=-90.0, le=90.0)
    lng: float = Field(..., ge=-180.0, le=180.0)
    ambulance_required: bool = False


class HospitalScore(BaseModel):
    """A single hospital with its computed ranking score (lower is better)."""
    hospital_id: UUID
    hospital_name: str
    distance_km: float = Field(..., ge=0.0)
    queue_size: int = Field(..., ge=0)
    load_score: float
    composite_score: float
    eta_minutes: Optional[float] = None


class EmergencyDispatchResponse(BaseModel):
    """Response returned after a successful emergency dispatch."""
    incident_id: UUID
    assigned_hospital: HospitalScore
    fallback_hospitals: list[HospitalScore] = Field(
        default_factory=list,
        description="Ranked alternatives if the primary hospital becomes unavailable.",
    )
    queue_entry_id: UUID
    status: IncidentStatus
