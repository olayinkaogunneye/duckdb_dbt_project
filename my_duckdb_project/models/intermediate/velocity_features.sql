-- models/intermediate/velocity_features.sql

{{ config(materialized='table') }}

WITH base AS (
    SELECT
        transaction_id,
        sender_account,
        timestamp,
        amount,
        transaction_type,
        merchant_category,
        location,
        device_used,
        payment_channel,
        is_fraud,
        fraud_type
    FROM {{ ref('stg_transactions_clean') }}
),

ordered AS (
    SELECT
        *,
        LAG(timestamp) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
        ) AS prev_timestamp
    FROM base
),

true_time_diff AS (
    SELECT
        *,
        EXTRACT(EPOCH FROM (timestamp - prev_timestamp)) AS true_time_since_last_txn
    FROM ordered
),

velocity_windows AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '1 hour' PRECEDING AND CURRENT ROW
        ) AS txn_count_1h,

        COUNT(*) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '24 hours' PRECEDING AND CURRENT ROW
        ) AS txn_count_24h,

        AVG(amount) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '1 hour' PRECEDING AND CURRENT ROW
        ) AS avg_amount_1h
    FROM true_time_diff
),

burst_detection AS (
    SELECT
        *,
        CASE
            WHEN txn_count_1h >= 5 THEN 1
            ELSE 0
        END AS burst_flag
    FROM velocity_windows
),

velocity_change AS (
    SELECT
        *,
        LAG(txn_count_1h) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
        ) AS prev_txn_count_1h,

        CASE
            WHEN prev_txn_count_1h IS NULL THEN 0
            WHEN txn_count_1h - prev_txn_count_1h >= 3 THEN 1
            ELSE 0
        END AS sudden_velocity_change
    FROM burst_detection
)

SELECT *
FROM velocity_change