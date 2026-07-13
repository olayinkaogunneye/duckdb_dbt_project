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

        -- Customer behavior features
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

encoded AS (
    SELECT
        *,
        -- Encode categorical fields for ML
        CASE amount_bucket
            WHEN 'low' THEN 0
            WHEN 'medium' THEN 1
            WHEN 'high' THEN 2
            WHEN 'very_high' THEN 3
            ELSE 0
        END AS amount_bucket_encoded,

        CASE transaction_type_risk
            WHEN 'low' THEN 0
            WHEN 'medium' THEN 1
            WHEN 'high' THEN 2
            ELSE 0
        END AS transaction_type_risk_encoded,

        CASE merchant_category_risk
            WHEN 'low' THEN 0
            WHEN 'medium' THEN 1
            WHEN 'high' THEN 2
            ELSE 0
        END AS merchant_category_risk_encoded
    FROM base
)

SELECT
    -- Target variable
    is_fraud,

    -- Numeric features (preferred by ML)
    amount,
    true_time_since_last_txn,
    txn_count_1h,
    txn_count_24h,
    avg_amount_1h,
    distance_km,
    geo_velocity_kmh,
    accounts_per_device,
    ips_per_device,
    devices_per_ip,
    device_txn_count_1h,
    recency_seconds,
    txn_count_7d,
    txn_count_30d,
    avg_amount_30d,
    total_amount_30d,

    -- Encoded categorical features
    amount_bucket_encoded,
    transaction_type_risk_encoded,
    merchant_category_risk_encoded,

    -- Boolean flags (converted to numeric)
    CASE WHEN burst_flag THEN 1 ELSE 0 END AS burst_flag,
    CASE WHEN sudden_velocity_change THEN 1 ELSE 0 END AS sudden_velocity_change,
    CASE WHEN location_change_flag THEN 1 ELSE 0 END AS location_change_flag,
    CASE WHEN impossible_travel_flag THEN 1 ELSE 0 END AS impossible_travel_flag,
    CASE WHEN high_risk_location_flag THEN 1 ELSE 0 END AS high_risk_location_flag,
    CASE WHEN shared_device_flag THEN 1 ELSE 0 END AS shared_device_flag,
    CASE WHEN device_ip_risk_flag THEN 1 ELSE 0 END AS device_ip_risk_flag,
    CASE WHEN shared_ip_flag THEN 1 ELSE 0 END AS shared_ip_flag,
    CASE WHEN device_burst_flag THEN 1 ELSE 0 END AS device_burst_flag,
    CASE WHEN high_risk_device_flag THEN 1 ELSE 0 END AS high_risk_device_flag,
    CASE WHEN sudden_spend_change THEN 1 ELSE 0 END AS sudden_spend_change,
    CASE WHEN unusual_frequency_pattern THEN 1 ELSE 0 END AS unusual_frequency_pattern,

    -- IDs for traceability (not used by ML)
    transaction_id,
    sender_account,
    receiver_account,
    timestamp,
    device_hash,
    ip_address,
    transaction_type,
    merchant_category,
    location

FROM encoded