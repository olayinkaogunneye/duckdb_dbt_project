{{ config(materialized='table') }}

WITH base AS (
    SELECT
        transaction_id,
        sender_account,
        timestamp,
        device_hash,
        ip_address,
        amount,
        is_fraud
    FROM {{ ref('stg_transactions_clean') }}
),

-- 1. How many accounts share the same device?
device_account_count AS (
    SELECT
        device_hash,
        COUNT(DISTINCT sender_account) AS accounts_per_device
    FROM base
    GROUP BY device_hash
),

-- 2. How many IPs does each device use?
device_ip_count AS (
    SELECT
        device_hash,
        COUNT(DISTINCT ip_address) AS ips_per_device
    FROM base
    GROUP BY device_hash
),

-- 3. How many devices share the same IP?
ip_device_count AS (
    SELECT
        ip_address,
        COUNT(DISTINCT device_hash) AS devices_per_ip
    FROM base
    GROUP BY ip_address
),

-- 4. Device-level velocity (transactions per hour)
device_velocity AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY device_hash
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '1 hour' PRECEDING AND CURRENT ROW
        ) AS device_txn_count_1h
    FROM base
),

-- 5. Join all device-level metrics
joined AS (
    SELECT
        dv.*,
        dac.accounts_per_device,
        dic.ips_per_device,
        idc.devices_per_ip
    FROM device_velocity dv
    LEFT JOIN device_account_count dac USING (device_hash)
    LEFT JOIN device_ip_count dic USING (device_hash)
    LEFT JOIN ip_device_count idc USING (ip_address)
),

-- 6. Risk flags
risk_flags AS (
    SELECT
        *,
        CASE WHEN accounts_per_device > 3 THEN 1 ELSE 0 END AS shared_device_flag,
        CASE WHEN ips_per_device > 5 THEN 1 ELSE 0 END AS device_ip_risk_flag,
        CASE WHEN devices_per_ip > 5 THEN 1 ELSE 0 END AS shared_ip_flag,
        CASE WHEN device_txn_count_1h >= 10 THEN 1 ELSE 0 END AS device_burst_flag,
        CASE WHEN device_hash IN (
            SELECT device_hash FROM base WHERE is_fraud = TRUE
        ) THEN 1 ELSE 0 END AS high_risk_device_flag
    FROM joined
)

SELECT *
FROM risk_flags