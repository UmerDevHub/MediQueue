"""
MediQueue — FastAPI application entry point.

Registers all routers and configures application-level settings.
"""

from __future__ import annotations

import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes_auth import router as auth_router
from app.api.routes_emergency import router as emergency_router
from app.api.routes_appointments import router as appointments_router
from app.api.routes_hospitals import router as hospitals_router

# ---------------------------------------------------------------------------
# Logging
# ---------------------------------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-8s | %(name)s | %(message)s",
)

# ---------------------------------------------------------------------------
# Application
# ---------------------------------------------------------------------------

app = FastAPI(
    title="MediQueue API",
    description=(
        "Hybrid healthcare backend — Emergency dispatch with smart hospital "
        "selection and appointment booking with conflict prevention."
    ),
    version="0.1.0",
)

# ---------------------------------------------------------------------------
# CORS — allow the Next.js dashboard and Flutter app in development
# ---------------------------------------------------------------------------

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # tighten in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ---------------------------------------------------------------------------
# Routers
# ---------------------------------------------------------------------------

app.include_router(auth_router, prefix="/api/v1")
app.include_router(emergency_router, prefix="/api/v1")
app.include_router(appointments_router, prefix="/api/v1")
app.include_router(hospitals_router, prefix="/api/v1")

# ---------------------------------------------------------------------------
# Health check
# ---------------------------------------------------------------------------


@app.get("/", tags=["Health"])
def root():
    return {"status": "ok", "service": "MediQueue API", "version": "0.1.0"}