{{ config(
    schema = 'marts',
    materialized = 'table'
) }}

SELECT
    transaction_id,
    timestamp,
    sender_account,
    receiver_account,
    amount,
    location,
    device_hash,
    ip_address,

    -- Component scores
    velocity_risk_score,
    geo_risk_score,
    device_risk_score,
    behavior_risk_score,
    transaction_risk_score,

    -- Final score and flag
    fraud_score,
    fraud_flag,

    -- Simple dominant driver label
    CASE
        WHEN velocity_risk_score = GREATEST(
            velocity_risk_score,
            geo_risk_score,
            device_risk_score,
            behavior_risk_score,
            transaction_risk_score
        ) THEN 'velocity'
        WHEN geo_risk_score = GREATEST(
            velocity_risk_score,
            geo_risk_score,
            device_risk_score,
            behavior_risk_score,
            transaction_risk_score
        ) THEN 'geo'
        WHEN device_risk_score = GREATEST(
            velocity_risk_score,
            geo_risk_score,
            device_risk_score,
            behavior_risk_score,
            transaction_risk_score
        ) THEN 'device'
        WHEN behavior_risk_score = GREATEST(
            velocity_risk_score,
            geo_risk_score,
            device_risk_score,
            behavior_risk_score,
            transaction_risk_score
        ) THEN 'behavior'
        ELSE 'transaction'
    END AS dominant_risk_driver

FROM {{ ref('fraud_scoring') }}