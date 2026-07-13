{{ config(materialized='table') }}

WITH base AS (
    SELECT
        transaction_id,
        sender_account,
        timestamp,
        amount,
        transaction_type,
        merchant_category,
        is_fraud
    FROM {{ ref('stg_transactions_clean') }}
),

ordered AS (
    SELECT
        *,
        LAG(timestamp) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
        ) AS prev_timestamp,

        LAG(amount) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
        ) AS prev_amount
    FROM base
),

recency AS (
    SELECT
        *,
        EXTRACT(EPOCH FROM (timestamp - prev_timestamp)) AS recency_seconds
    FROM ordered
),

frequency AS (
    SELECT
        *,
        COUNT(*) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
        ) AS txn_count_7d,

        COUNT(*) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW
        ) AS txn_count_30d
    FROM recency
),

monetary AS (
    SELECT
        *,
        AVG(amount) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW
        ) AS avg_amount_30d,

        SUM(amount) OVER (
            PARTITION BY sender_account
            ORDER BY timestamp
            RANGE BETWEEN INTERVAL '30 days' PRECEDING AND CURRENT ROW
        ) AS total_amount_30d
    FROM frequency
),

behavioral_change AS (
    SELECT
        *,
        CASE
            WHEN prev_amount IS NULL THEN 0
            WHEN ABS(amount - prev_amount) > (prev_amount * 0.5) THEN 1
            ELSE 0
        END AS sudden_spend_change,

        CASE
            WHEN txn_count_7d >= 10 AND txn_count_30d <= 15 THEN 1
            ELSE 0
        END AS unusual_frequency_pattern
    FROM monetary
)

SELECT *
FROM behavioral_change