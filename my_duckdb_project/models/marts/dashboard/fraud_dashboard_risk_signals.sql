{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

SELECT
    DATE(timestamp) AS txn_date,

    -- Velocity anomalies
    SUM(CASE WHEN burst_flag THEN 1 ELSE 0 END) AS burst_events,
    SUM(CASE WHEN sudden_velocity_change THEN 1 ELSE 0 END) AS sudden_velocity_events,

    -- Geo anomalies
    SUM(CASE WHEN impossible_travel_flag THEN 1 ELSE 0 END) AS impossible_travel_events,
    SUM(CASE WHEN high_risk_location_flag THEN 1 ELSE 0 END) AS high_risk_location_events,

    -- Device anomalies
    SUM(CASE WHEN shared_device_flag THEN 1 ELSE 0 END) AS shared_device_events,
    SUM(CASE WHEN device_burst_flag THEN 1 ELSE 0 END) AS device_burst_events,
    SUM(CASE WHEN high_risk_device_flag THEN 1 ELSE 0 END) AS high_risk_device_events,

    -- Behavior anomalies
    SUM(CASE WHEN sudden_spend_change THEN 1 ELSE 0 END) AS sudden_spend_change_events,
    SUM(CASE WHEN unusual_frequency_pattern THEN 1 ELSE 0 END) AS unusual_frequency_events

FROM {{ ref('fraud_scoring') }}
GROUP BY DATE(timestamp)
ORDER BY txn_date