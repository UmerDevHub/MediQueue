# MediQueue — Project Handoff

## Project Overview
MediQueue is a hybrid healthcare platform designed to modernize patient flow and emergency responsiveness. The core system handles:
1. **Emergency Dispatch:** Routes patients to the optimal hospital based on proximity and real-time hospital queue load.
2. **Live Queue Management:** Allows hospital administrators to monitor active emergencies, triage incoming patients, and track wait times.
3. **Appointment Booking & Secure Comms:** Enables standard slot-based appointment booking and low-latency doctor-patient secure messaging.

## Architecture & Tech Stack
*   **Backend:** Python 3, FastAPI, Supabase (PostgreSQL + Realtime). Handles core business logic, the state machine for incident transitions, and Background ML tasks.
*   **Web Dashboard:** Next.js, React, Tailwind CSS. Used by hospital administrators to manage queues and view incoming incidents.
*   **Mobile App:** Flutter, Dart. Used by patients to trigger emergency dispatches and book appointments.

## Directory Structure Breakdown
```text
/
├── backend/                  # FastAPI Application
│   ├── app/
│   │   ├── api/              # Routers (Emergency, Auth, Appointments, Hospitals)
│   │   ├── core/             # Configuration and Dependencies
│   │   ├── db/               # Supabase Database client initialization
│   │   ├── models/           # Pydantic schemas, Enums (e.g., IncidentStatus)
│   │   ├── services/         # Business logic (ml_service.py, hospital_service.py)
│   │   └── utils/            # Helper functions (ranking algorithms)
│   └── requirements.txt
├── mobile_app/               # Flutter Patient App (UI wiped for consistency rebuild)
│   ├── lib/                  # Dart code (currently contains a barebones main.dart)
│   └── pubspec.yaml          # Flutter dependencies
└── web_dashboard/            # Next.js Admin Dashboard (UI wiped for consistency rebuild)
    ├── package.json          # Node dependencies
    ├── tailwind.config.js    # Tailwind configuration
    └── src/                  # (To be recreated) New React UI components & pages go here
```

## Current Completion Status
*   **Backend/Database:** ~85% Complete
    *   *Done:* Core Schemas, Emergency Dispatch Logic (ranking & assignment), Status State Machine, Pydantic validations, Appointment Booking & Conflict prevention, ML background task triggers.
    *   *Left:* Production deployment, scaling secure-message webhook fallbacks if needed, refining the ML predictive model.
*   **Web Dashboard:** 0% (Ready for fresh UI build)
    *   *Status:* Previous prototype wiped to establish a clean slate. Ready for the new design system.
*   **Mobile App:** 0% (Ready for fresh UI build)
    *   *Status:* Previous prototype wiped. Barebones `main.dart` is in place.

## Developer Roles
*   **Backend & Architecture:** Handled by the Lead Architect. The FastAPI layer, database schemas, and API contracts are established. Do not modify the backend without consulting the architect.
*   **Frontend (Web & Mobile):** Fully handed over to the Frontend Engineer. You are responsible for rebuilding the Next.js and Flutter user interfaces from scratch using a UI tool (e.g., Stitch) to ensure complete visual consistency across both platforms. Please refer to the API contracts in `backend/app/models/schemas.py` and the endpoints in `backend/app/api/` when integrating your UI.
