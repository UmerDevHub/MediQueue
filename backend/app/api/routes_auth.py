"""
MediQueue — Authentication routes.

Endpoints:
    POST /auth/signup  → register a new user account
    POST /auth/login   → authenticate and receive a JWT access token
"""

from __future__ import annotations

import logging

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr, Field
from fastapi.security import OAuth2PasswordRequestForm

from app.services.auth_service import login_user, signup_user
from app.models.schemas import UserRole

logger = logging.getLogger("mediqueue.routes_auth")

router = APIRouter(prefix="/auth", tags=["Authentication"])

# ---------------------------------------------------------------------------
# Request / Response schemas
# ---------------------------------------------------------------------------

class SignupRequest(BaseModel):
    """POST body for user registration."""
    name: str = Field(..., min_length=1, max_length=255)
    phone: str = Field(..., min_length=1, max_length=20)
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128)
    role: UserRole = UserRole.USER


class SignupResponse(BaseModel):
    """Response after successful registration."""
    id: str
    name: str
    email: str
    role: str
    message: str = "Account created successfully."


class LoginRequest(BaseModel):
    """POST body for user login."""
    email: EmailStr
    password: str = Field(..., min_length=1)


class LoginResponse(BaseModel):
    """Response after successful login."""
    access_token: str
    token_type: str = "bearer"
    user: dict


# ---------------------------------------------------------------------------
# POST /auth/signup
# ---------------------------------------------------------------------------

@router.post(
    "/signup",
    response_model=SignupResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Register a new user",
    description=(
        "Creates a new user account. The password is hashed with bcrypt "
        "before storage. Returns 409 if the email is already registered."
    ),
)
async def signup(payload: SignupRequest):
    try:
        user = await signup_user(
            name=payload.name,
            phone=payload.phone,
            email=payload.email,
            password=payload.password,
            role=payload.role,
        )
        return SignupResponse(
            id=user["id"],
            name=user["name"],
            email=user["email"],
            role=user["role"],
        )
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error during signup")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Registration error: {exc}",
        ) from exc


# ---------------------------------------------------------------------------
# POST /auth/login (JSON)
# ---------------------------------------------------------------------------

@router.post(
    "/login",
    response_model=LoginResponse,
    summary="Authenticate and get token",
    description=(
        "Verifies email and password. Returns a JWT access token valid for "
        "24 hours. Use this token in the Authorization header as "
        "'Bearer <token>' for protected endpoints."
    ),
)
async def login(payload: LoginRequest):
    try:
        result = await login_user(
            email=payload.email,
            password=payload.password,
        )
        return LoginResponse(
            access_token=result["access_token"],
            token_type=result["token_type"],
            user=result["user"],
        )
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error during login")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred during authentication.",
        ) from exc


# ---------------------------------------------------------------------------
# POST /auth/token (OAuth2 password flow)
# ---------------------------------------------------------------------------

@router.post(
    "/token",
    response_model=LoginResponse,
    summary="OAuth2 login for Swagger",
    description=(
        "OAuth2 password flow endpoint for Swagger UI. "
        "Use username as email and password as your password."
    ),
)
async def token(form_data: OAuth2PasswordRequestForm = Depends()):
    try:
        result = await login_user(
            email=form_data.username,
            password=form_data.password,
        )
        return LoginResponse(
            access_token=result["access_token"],
            token_type=result["token_type"],
            user=result["user"],
        )
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Unhandled error during OAuth2 login")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="An unexpected error occurred during authentication.",
        ) from exc
