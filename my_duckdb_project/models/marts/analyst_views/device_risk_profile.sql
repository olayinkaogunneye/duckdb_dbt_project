{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

WITH base AS (
    SELECT
        fs.device_hash,
        COUNT(*) AS total_transactions,
        SUM(CASE WHEN fs.fraud_flag THEN 1 ELSE 0 END) AS fraud_count,
        AVG(fs.fraud_score) AS avg_fraud_score,

        -- Device signals
        AVG(df.accounts_per_device) AS avg_accounts_per_device,
        AVG(df.ips_per_device) AS avg_ips_per_device,
        AVG(df.devices_per_ip) AS avg_devices_per_ip,
        SUM(CASE WHEN df.shared_device_flag THEN 1 ELSE 0 END) AS shared_device_events,
        SUM(CASE WHEN df.device_burst_flag THEN 1 ELSE 0 END) AS device_burst_events,
        SUM(CASE WHEN df.high_risk_device_flag THEN 1 ELSE 0 END) AS high_risk_device_events,

        -- Geo signals
        SUM(CASE WHEN gf.high_risk_location_flag THEN 1 ELSE 0 END) AS high_risk_location_events

    FROM {{ ref('fraud_scoring') }} fs
    LEFT JOIN {{ ref('device_risk_features') }} df ON fs.transaction_id = df.transaction_id
    LEFT JOIN {{ ref('geo_risk_features') }} gf ON fs.transaction_id = gf.transaction_id
    GROUP BY fs.device_hash
)

SELECT
    *,
    CASE
        WHEN avg_fraud_score >= 0.7 THEN 'high'
        WHEN avg_fraud_score >= 0.4 THEN 'medium'
        ELSE 'low'
    END AS device_risk_tier
FROM base