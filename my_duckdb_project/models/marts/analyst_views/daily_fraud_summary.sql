{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

SELECT
    DATE(timestamp) AS txn_date,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag THEN 1 ELSE 0 END) AS fraud_transactions,
    AVG(fraud_score) AS avg_fraud_score,

    -- Velocity signals
    SUM(CASE WHEN burst_flag THEN 1 ELSE 0 END) AS burst_events,

    -- Geo signals
    SUM(CASE WHEN impossible_travel_flag THEN 1 ELSE 0 END) AS impossible_travel_events,

    -- Device signals
    SUM(CASE WHEN shared_device_flag THEN 1 ELSE 0 END) AS shared_device_events

FROM {{ ref('fraud_scoring') }}
GROUP BY DATE(timestamp)
ORDER BY txn_date