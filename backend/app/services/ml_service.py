"""
MediQueue — Machine Learning service for wait time prediction.

Uses online incremental learning (SGDRegressor) to predict hospital wait times
based on historical queue load data.
"""

from __future__ import annotations

import logging
from typing import Optional

import numpy as np
from sklearn.linear_model import SGDRegressor

from fastapi import HTTPException, status
from app.db.database import supabase

logger = logging.getLogger("mediqueue.ml_service")


# ---------------------------------------------------------------------------
# Global model instance (persists across requests within same process)
# ---------------------------------------------------------------------------
_model: Optional[SGDRegressor] = None


def _get_or_create_model() -> SGDRegressor:
    """Lazily initialize the global SGDRegressor model."""
    global _model
    if _model is None:
        _model = SGDRegressor(
            loss="squared_error",
            penalty="l2",
            alpha=0.0001,
            random_state=42,
            warm_start=True,
            max_iter=1000,
        )
    return _model


async def predict_wait_time(hospital_id: str) -> float:
    """
    Predict the wait time for a given hospital using online incremental learning.

    Algorithm:
        1. Fetch up to last 100 rows from hospital_load_log for this hospital_id
        2. Extract features (queue_size) and target (avg_service_time from hospitals table)
        3. If >= 5 data points: train SGDRegressor and predict
        4. If < 5 data points: return fallback avg_service_time from hospitals table

    Args:
        hospital_id: UUID of the hospital to predict wait time for.

    Returns:
        Predicted wait time in minutes, rounded to 1 decimal place.

    Raises:
        Exception: If database queries fail.
    """

    # ---- 1. Fetch last 100 load log entries for this hospital ----
    try:
        load_log_response = (
            supabase
            .table("hospital_load_log")
            .select("queue_size, recorded_at")
            .eq("hospital_id", hospital_id)
            .order("recorded_at", desc=True)
            .limit(100)
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch hospital_load_log for hospital_id=%s", hospital_id)
        raise

    load_log_data = load_log_response.data or []

    # ---- 2. Fetch hospital's average service time ----
    try:
        hospital_response = (
            supabase
            .table("hospitals")
            .select("avg_service_time, current_queue_size")
            .eq("id", hospital_id)
            .single()
            .execute()
        )
    except Exception as exc:
        logger.exception("Failed to fetch hospital for hospital_id=%s", hospital_id)
        raise

    hospital_data = hospital_response.data
    if not hospital_data:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Hospital not found for wait time prediction.",
        )
    fallback_avg_service_time = hospital_data.get("avg_service_time", 15) or 15
    current_queue_size = hospital_data.get("current_queue_size", 0) or 0

    # ---- 3. Fallback if insufficient data ----
    if len(load_log_data) < 5:
        logger.info(
            "Insufficient data for hospital_id=%s (%d points). Returning fallback.",
            hospital_id,
            len(load_log_data),
        )
        return round(float(fallback_avg_service_time), 1)

    # ---- 4. Prepare training data: X (queue_size), y (avg_service_time) ----
    X = np.array([[entry["queue_size"]] for entry in load_log_data]).reshape(-1, 1)
    y = np.full(len(load_log_data), fallback_avg_service_time)

    # ---- 5. Train model incrementally (warm_start=True) ----
    model = _get_or_create_model()
    try:
        model.fit(X, y)
    except Exception as exc:
        logger.exception("Failed to fit SGDRegressor for hospital_id=%s", hospital_id)
        raise

    # ---- 6. Predict wait time for current queue size ----
    try:
        predicted_wait = model.predict([[current_queue_size]])[0]
    except Exception as exc:
        logger.exception(
            "Failed to predict wait time for hospital_id=%s, queue_size=%d",
            hospital_id,
            current_queue_size,
        )
        raise

    predicted_wait = max(predicted_wait, 0)
    return round(float(predicted_wait), 1)
