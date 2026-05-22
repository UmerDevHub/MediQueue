"""
MediQueue — FastAPI dependencies.

Provides reusable dependency functions for route-level injection.
Primary dependency: ``get_current_user`` — extracts and validates
the JWT Bearer token from the Authorization header.
"""

from __future__ import annotations

import logging
from uuid import UUID

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from app.core.security import decode_access_token
from app.db.database import supabase

logger = logging.getLogger("mediqueue.dependencies")

# ---------------------------------------------------------------------------
# OAuth2 scheme — tells FastAPI to expect "Authorization: Bearer <token>"
# ---------------------------------------------------------------------------

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/token")


# ---------------------------------------------------------------------------
# get_current_user dependency
# ---------------------------------------------------------------------------

async def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    """
    Decode the JWT token, fetch the user from Supabase, and return
    the full user row as a dict.

    Raises
    ------
    HTTPException 401
        If the token is missing, expired, malformed, or the user
        no longer exists in the database.
    """
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid or expired authentication token.",
        headers={"WWW-Authenticate": "Bearer"},
    )

    # ---- Decode token ----
    try:
        payload = decode_access_token(token)
        user_id: str | None = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except Exception:
        raise credentials_exception

    # ---- Fetch user from database ----
    try:
        response = (
            supabase
            .table("users")
            .select("id, name, phone, email, role, created_at")
            .eq("id", user_id)
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch user %s from database", user_id)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail="User verification temporarily unavailable.",
        ) from exc

    if not response.data:
        raise credentials_exception

    return response.data[0]
