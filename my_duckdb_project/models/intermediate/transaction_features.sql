-- models/intermediate/transaction_features.sql

{{ config(materialized='table') }}

WITH base AS (
    SELECT
        transaction_id,
        timestamp,
        sender_account,
        receiver_account,
        amount,
        transaction_type,
        merchant_category,
        location,
        device_used,
        is_fraud,
        fraud_type,
        time_since_last_transaction,
        spending_deviation_score,
        velocity_score,
        geo_anomaly_score,
        payment_channel,
        ip_address,
        device_hash
    FROM {{ ref('stg_transactions_clean') }}
),

amount_features AS (
    SELECT
        *,
        CASE
            WHEN amount < 10 THEN 'very_small'
            WHEN amount < 100 THEN 'small'
            WHEN amount < 500 THEN 'medium'
            WHEN amount < 1000 THEN 'large'
            ELSE 'very_large'
        END AS amount_bucket
    FROM base
),

transaction_type_risk AS (
    SELECT
        *,
        CASE
            WHEN transaction_type = 'withdrawal' THEN 'high'
            WHEN transaction_type = 'transfer' THEN 'medium'
            WHEN transaction_type = 'payment' THEN 'medium'
            WHEN transaction_type = 'deposit' THEN 'low'
            ELSE 'unknown'
        END AS transaction_type_risk
    FROM amount_features
),

merchant_risk AS (
    SELECT
        *,
        CASE
            WHEN merchant_category = 'online' THEN 'high'
            WHEN merchant_category = 'travel' THEN 'high'
            WHEN merchant_category = 'entertainment' THEN 'medium'
            WHEN merchant_category = 'retail' THEN 'medium'
            WHEN merchant_category = 'restaurant' THEN 'low'
            WHEN merchant_category = 'grocery' THEN 'low'
            WHEN merchant_category = 'utilities' THEN 'low'
            ELSE 'medium'
        END AS merchant_category_risk
    FROM transaction_type_risk
)

SELECT *
FROM merchant_risk