{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

SELECT
    DATE_TRUNC('week', timestamp) AS week_start,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag THEN 1 ELSE 0 END) AS fraud_transactions,
    AVG(fraud_score) AS avg_fraud_score,

    -- Trend metrics
    SUM(CASE WHEN burst_flag THEN 1 ELSE 0 END) AS weekly_burst_events,
    SUM(CASE WHEN impossible_travel_flag THEN 1 ELSE 0 END) AS weekly_impossible_travel_events,
    SUM(CASE WHEN shared_device_flag THEN 1 ELSE 0 END) AS weekly_shared_device_events

FROM {{ ref('fraud_scoring') }}
GROUP BY DATE_TRUNC('week', timestamp)
ORDER BY week_start