"""
MediQueue — Hospital scoring and ranked selection.

Algorithm overview
------------------
Each candidate hospital receives a **composite score** (lower is better):

    composite = (W_dist × normalised_distance) + (W_load × load_score)

Where:
    • normalised_distance = distance_km / MAX_REASONABLE_DISTANCE_KM
    • load_score          = current_queue_size / QUEUE_CAPACITY

Tuning knobs (module-level constants):
    W_DISTANCE       – weight given to proximity          (default 0.4)
    W_LOAD           – weight given to queue congestion    (default 0.6)
    QUEUE_CAPACITY   – queue size treated as "full"        (default 20)
    OVERLOAD_THRESHOLD – load_score above which a hospital is deprioritised
    MAX_REASONABLE_DISTANCE_KM – normalisation ceiling     (default 50 km)
    AVG_AMBULANCE_SPEED_KMH    – used for ETA estimation   (default 60 km/h)

Smart fallback
--------------
Hospitals whose load_score exceeds OVERLOAD_THRESHOLD are pushed to the
bottom of the ranking regardless of distance.  The caller always receives a
fully ranked list so it can cascade to the next-best hospital if the primary
assignment later becomes unavailable.
"""

from __future__ import annotations

import math
from dataclasses import dataclass
from typing import Sequence

# ---------------------------------------------------------------------------
# Tuning constants
# ---------------------------------------------------------------------------

W_DISTANCE: float = 0.4
"""Weight given to geographic distance in the composite score."""

W_LOAD: float = 0.35
"""Weight given to queue load in the composite score (35%)."""

W_WAIT: float = 0.25
"""Weight given to wait time in the composite score (25%)."""

MAX_REASONABLE_WAIT_MINUTES: float = 60.0
"""Wait time normalisation ceiling in minutes."""

QUEUE_CAPACITY: int = 20
"""Queue size at which a hospital is considered fully loaded (load_score = 1.0)."""

OVERLOAD_THRESHOLD: float = 0.85
"""load_score above this value triggers the smart fallback penalty."""

OVERLOAD_PENALTY: float = 100.0
"""Additive penalty applied to overloaded hospitals to push them down the ranking."""

MAX_REASONABLE_DISTANCE_KM: float = 50.0
"""Distances are normalised against this ceiling (caps the distance component at 1.0)."""

AVG_AMBULANCE_SPEED_KMH: float = 60.0
"""Assumed average ambulance speed for ETA calculation."""

EARTH_RADIUS_KM: float = 6_371.0
"""Mean Earth radius used in the Haversine formula."""


# ---------------------------------------------------------------------------
# Haversine distance
# ---------------------------------------------------------------------------

def haversine_km(lat1: float, lng1: float, lat2: float, lng2: float) -> float:
    """
    Return the great-circle distance in **kilometres** between two
    (latitude, longitude) points using the Haversine formula.
    """
    lat1_r, lat2_r = math.radians(lat1), math.radians(lat2)
    dlat = math.radians(lat2 - lat1)
    dlng = math.radians(lng2 - lng1)

    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(lat1_r) * math.cos(lat2_r) * math.sin(dlng / 2) ** 2
    )
    return 2 * EARTH_RADIUS_KM * math.atan2(math.sqrt(a), math.sqrt(1 - a))


# ---------------------------------------------------------------------------
# Load score
# ---------------------------------------------------------------------------

def compute_load_score(current_queue_size: int, capacity: int = QUEUE_CAPACITY) -> float:
    """
    Return a 0.0 – 1.0+ load score.

    Values > 1.0 are possible when the queue exceeds nominal capacity,
    signalling severe congestion.
    """
    if capacity <= 0:
        return 1.0  # treat misconfigured capacity as fully loaded
    return current_queue_size / capacity


# ---------------------------------------------------------------------------
# ETA estimation
# ---------------------------------------------------------------------------

def estimate_eta_minutes(
    distance_km: float,
    speed_kmh: float = AVG_AMBULANCE_SPEED_KMH,
) -> float:
    """Estimate travel time in minutes given straight-line distance."""
    if speed_kmh <= 0:
        return 0.0
    # Apply a 1.3× road-factor to account for non-straight routes
    return (distance_km * 1.3 / speed_kmh) * 60


# ---------------------------------------------------------------------------
# Per-hospital score dataclass
# ---------------------------------------------------------------------------

@dataclass(slots=True)
class HospitalCandidate:
    """Intermediate scoring record for one hospital."""
    hospital_id: str
    hospital_name: str
    distance_km: float
    queue_size: int
    load_score: float
    composite_score: float
    eta_minutes: float
    is_overloaded: bool


# ---------------------------------------------------------------------------
# Core ranking function
# ---------------------------------------------------------------------------

def rank_hospitals(
    user_lat: float,
    user_lng: float,
    hospitals: Sequence[dict],
    *,
    w_distance: float = W_DISTANCE,
    w_load: float = W_LOAD,
    w_wait: float = W_WAIT,
    capacity: int = QUEUE_CAPACITY,
    overload_threshold: float = OVERLOAD_THRESHOLD,
) -> list[HospitalCandidate]:
    """
    Score and rank a list of hospitals for a user at (user_lat, user_lng).

    Parameters
    ----------
    user_lat, user_lng : float
        User's GPS coordinates.
    hospitals : Sequence[dict]
        Rows from the ``hospitals`` table. Each dict must contain at least:
        ``id``, ``name``, ``lat``, ``lng``, ``current_queue_size``,
        ``emergency_available``, ``avg_service_time``.
    w_distance : float
        Weight for normalised distance component (40%).
    w_load : float
        Weight for load component (35%).
    w_wait : float
        Weight for wait time component (25%).
    capacity : int
        Queue size that represents 100 % load.
    overload_threshold : float
        load_score at or above which the hospital is penalised.

    Returns
    -------
    list[HospitalCandidate]
        Hospitals sorted by composite_score ascending (best first).
        Overloaded hospitals are pushed to the tail via an additive penalty.
    """
    candidates: list[HospitalCandidate] = []

    for h in hospitals:
        # --- Skip hospitals that have emergency intake disabled ---
        if not h.get("emergency_available", False):
            continue

        distance = haversine_km(
            user_lat, user_lng,
            float(h["lat"]), float(h["lng"]),
        )

        queue_size = int(h.get("current_queue_size", 0))
        load = compute_load_score(queue_size, capacity)

        # --- Normalised distance (capped at 1.0) ---
        norm_dist = min(distance / MAX_REASONABLE_DISTANCE_KM, 1.0)

        # --- Normalised wait time (capped at 1.0) ---
        avg_service = float(h.get("avg_service_time") or 15.0)
        norm_wait = min(avg_service / MAX_REASONABLE_WAIT_MINUTES, 1.0)

        # --- Composite score ---
        score = (w_distance * norm_dist) + (w_load * load) + (w_wait * norm_wait)

        # --- Smart fallback: penalise overloaded hospitals ---
        is_overloaded = load >= overload_threshold
        if is_overloaded:
            score += OVERLOAD_PENALTY

        eta = estimate_eta_minutes(distance)

        candidates.append(
            HospitalCandidate(
                hospital_id=str(h["id"]),
                hospital_name=h["name"],
                distance_km=round(distance, 2),
                queue_size=queue_size,
                load_score=round(load, 4),
                composite_score=round(score, 4),
                eta_minutes=round(eta, 1),
                is_overloaded=is_overloaded,
            )
        )

    # --- Sort: lowest composite score first (best hospital) ---
    candidates.sort(key=lambda c: c.composite_score)
    return candidates
