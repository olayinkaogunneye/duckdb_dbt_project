{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

WITH base AS (
    SELECT
        tf.transaction_id,
        tf.timestamp,
        tf.sender_account,
        tf.receiver_account,
        tf.amount,
        tf.transaction_type,
        tf.merchant_category,
        tf.location,
        tf.device_hash,
        tf.ip_address,
        tf.is_fraud,

        -- Transaction features
        tf.amount_bucket,
        tf.transaction_type_risk,
        tf.merchant_category_risk,

        -- Velocity features
        vf.true_time_since_last_txn,
        vf.txn_count_1h,
        vf.txn_count_24h,
        vf.avg_amount_1h,
        vf.burst_flag,
        vf.sudden_velocity_change,

        -- Geo‑risk features
        gf.distance_km,
        gf.geo_velocity_kmh,
        gf.location_change_flag,
        gf.impossible_travel_flag,
        gf.high_risk_location_flag,

        -- Device risk features
        df.accounts_per_device,
        df.ips_per_device,
        df.devices_per_ip,
        df.device_txn_count_1h,
        df.shared_device_flag,
        df.device_ip_risk_flag,
        df.shared_ip_flag,
        df.device_burst_flag,
        df.high_risk_device_flag,

        -- Customer behavior
        cb.recency_seconds,
        cb.txn_count_7d,
        cb.txn_count_30d,
        cb.avg_amount_30d,
        cb.total_amount_30d,
        cb.sudden_spend_change,
        cb.unusual_frequency_pattern

    FROM {{ ref('transaction_features') }} tf
    LEFT JOIN {{ ref('velocity_features') }} vf
        ON tf.transaction_id = vf.transaction_id
    LEFT JOIN {{ ref('geo_risk_features') }} gf
        ON tf.transaction_id = gf.transaction_id
    LEFT JOIN {{ ref('device_risk_features') }} df
        ON tf.transaction_id = df.transaction_id
    LEFT JOIN {{ ref('customer_behavior') }} cb
        ON tf.transaction_id = cb.transaction_id
),

risk_signals AS (
    SELECT
        *,
        -- Simple rule‑based component scores (0–1 scale)

        CASE
            WHEN burst_flag = TRUE THEN 0.9
            WHEN txn_count_1h >= 5 THEN 0.7
            WHEN sudden_velocity_change = TRUE THEN 0.6
            ELSE 0.2
        END AS velocity_risk_score,

        CASE
            WHEN impossible_travel_flag = TRUE THEN 0.95
            WHEN location_change_flag = TRUE THEN 0.7
            WHEN high_risk_location_flag = TRUE THEN 0.8
            ELSE 0.2
        END AS geo_risk_score,

        CASE
            WHEN shared_device_flag = TRUE THEN 0.9
            WHEN shared_ip_flag = TRUE THEN 0.8
            WHEN device_burst_flag = TRUE THEN 0.85
            WHEN high_risk_device_flag = TRUE THEN 0.95
            ELSE 0.3
        END AS device_risk_score,

        CASE
            WHEN sudden_spend_change = TRUE THEN 0.8
            WHEN unusual_frequency_pattern = TRUE THEN 0.75
            WHEN recency_seconds > 7 * 24 * 3600
                 AND txn_count_7d > 0 THEN 0.7
            ELSE 0.3
        END AS behavior_risk_score,

        CASE
            WHEN amount_bucket = 'very_high' THEN 0.8
            WHEN transaction_type_risk = 'high' THEN 0.75
            WHEN merchant_category_risk = 'high' THEN 0.7
            ELSE 0.3
        END AS transaction_risk_score
    FROM base
),

final AS (
    SELECT
        *,
        -- Weighted composite fraud score (0–1)
        (
              0.25 * velocity_risk_score
            + 0.20 * geo_risk_score
            + 0.25 * device_risk_score
            + 0.20 * behavior_risk_score
            + 0.10 * transaction_risk_score
        ) AS fraud_score,

        CASE
            WHEN (
                  0.25 * velocity_risk_score
                + 0.20 * geo_risk_score
                + 0.25 * device_risk_score
                + 0.20 * behavior_risk_score
                + 0.10 * transaction_risk_score
            ) >= 0.7 THEN TRUE
            ELSE FALSE
        END AS fraud_flag
    FROM risk_signals
)

SELECT * FROM final