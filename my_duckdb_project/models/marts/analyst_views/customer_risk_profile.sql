{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

WITH base AS (
    SELECT
        fs.sender_account,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN fs.fraud_flag THEN 1 ELSE 0 END) AS fraud_count,
        AVG(fs.fraud_score) AS avg_fraud_score,

        -- Behavioral signals
        AVG(cb.recency_seconds) AS avg_recency_seconds,
        AVG(cb.txn_count_7d) AS avg_txn_count_7d,
        AVG(cb.txn_count_30d) AS avg_txn_count_30d,
        AVG(cb.avg_amount_30d) AS avg_amount_30d,
        AVG(cb.total_amount_30d) AS total_amount_30d,

        -- Velocity signals
        AVG(vf.txn_count_1h) AS avg_txn_count_1h,
        AVG(vf.txn_count_24h) AS avg_txn_count_24h,
        SUM(CASE WHEN vf.burst_flag THEN 1 ELSE 0 END) AS burst_events,

        -- Geo signals
        SUM(CASE WHEN gf.impossible_travel_flag THEN 1 ELSE 0 END) AS impossible_travel_events,
        SUM(CASE WHEN gf.high_risk_location_flag THEN 1 ELSE 0 END) AS high_risk_location_events,

        -- Device signals
        COUNT(DISTINCT fs.device_hash) AS distinct_devices,
        SUM(CASE WHEN df.shared_device_flag THEN 1 ELSE 0 END) AS shared_device_events

    FROM {{ ref('fraud_scoring') }} fs
    LEFT JOIN {{ ref('customer_behavior') }} cb ON fs.transaction_id = cb.transaction_id
    LEFT JOIN {{ ref('velocity_features') }} vf ON fs.transaction_id = vf.transaction_id
    LEFT JOIN {{ ref('geo_risk_features') }} gf ON fs.transaction_id = gf.transaction_id
    LEFT JOIN {{ ref('device_risk_features') }} df ON fs.transaction_id = df.transaction_id
    GROUP BY fs.sender_account
)

SELECT
    *,
    CASE
        WHEN avg_fraud_score >= 0.7 THEN 'high'
        WHEN avg_fraud_score >= 0.4 THEN 'medium'
        ELSE 'low'
    END AS customer_risk_tier
FROM base