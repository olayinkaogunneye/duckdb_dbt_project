{{ config(materialized='table') }}

WITH base AS (
    SELECT
        transaction_id,
        sender_account,
        timestamp,
        location,
        amount,
        is_fraud
    FROM {{ ref('stg_transactions_clean') }}
),

-- 1. City → Coordinates lookup (synthetic dataset)
city_coords AS (
    SELECT * FROM (
        VALUES
            ('prague', 50.0755, 14.4378),
            ('lagos', 6.5244, 3.3792),
            ('london', 51.5074, -0.1278),
            ('new_york', 40.7128, -74.0060),
            ('berlin', 52.5200, 13.4050),
            ('paris', 48.8566, 2.3522),
            ('tokyo', 35.6762, 139.6503),
            ('dubai', 25.2048, 55.2708)
    ) AS t(city, lat, lon)
),

joined AS (
    SELECT
        b.*,
        LOWER(b.location) AS location_lower,
        c.lat AS curr_lat,
        c.lon AS curr_lon
    FROM base b
    LEFT JOIN city_coords c
        ON LOWER(b.location) = c.city
),

ordered AS (
    SELECT
        *,
        LAG(curr_lat) OVER (PARTITION BY sender_account ORDER BY timestamp) AS prev_lat,
        LAG(curr_lon) OVER (PARTITION BY sender_account ORDER BY timestamp) AS prev_lon,
        LAG(timestamp) OVER (PARTITION BY sender_account ORDER BY timestamp) AS prev_timestamp
    FROM joined
),

-- 2. Haversine distance formula
distance_calc AS (
    SELECT
        *,
        CASE
            WHEN prev_lat IS NULL OR prev_lon IS NULL THEN NULL
            ELSE (
                6371 * ACOS(
                    COS(RADIANS(prev_lat)) * COS(RADIANS(curr_lat)) *
                    COS(RADIANS(curr_lon) - RADIANS(prev_lon)) +
                    SIN(RADIANS(prev_lat)) * SIN(RADIANS(curr_lat))
                )
            )
        END AS distance_km
    FROM ordered
),

geo_velocity AS (
    SELECT
        *,
        EXTRACT(EPOCH FROM (timestamp - prev_timestamp)) AS time_diff_seconds,
        CASE
            WHEN time_diff_seconds IS NULL OR time_diff_seconds = 0 THEN NULL
            ELSE distance_km / (time_diff_seconds / 3600)
        END AS geo_velocity_kmh
    FROM distance_calc
),

risk_flags AS (
    SELECT
        *,
        CASE
            WHEN distance_km > 500 THEN 1 ELSE 0 END AS location_change_flag,
        CASE
            WHEN geo_velocity_kmh > 900 THEN 1 ELSE 0 END AS impossible_travel_flag,
        CASE
            WHEN LOWER(location) IN ('dubai', 'lagos') THEN 1 ELSE 0 END AS high_risk_location_flag
    FROM geo_velocity
)

SELECT *
FROM risk_flags