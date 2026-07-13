{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

SELECT
    DATE(timestamp) AS txn_date,
    COUNT(*) AS total_transactions,
    SUM(CASE WHEN fraud_flag THEN 1 ELSE 0 END) AS fraud_transactions,
    AVG(fraud_score) AS avg_fraud_score,

    -- Amount metrics
    AVG(amount) AS avg_amount,
    MAX(amount) AS max_amount,
    SUM(amount) AS total_amount,

    -- Customer metrics
    COUNT(DISTINCT sender_account) AS distinct_customers

FROM {{ ref('fraud_scoring') }}
GROUP BY DATE(timestamp)
ORDER BY txn_date