-- models/staging/stg_transactions_clean.sql

{{ config(materialized='table') }}

select
    -- IDs
    transaction_id,

    -- Timestamp (safe cast)
    cast(timestamp as timestamp) as timestamp,

    -- Accounts
    sender_account,
    receiver_account,

    -- Numeric fields
    amount,

    -- Fix negative time_since_last_transaction
    case 
        when time_since_last_transaction < 0 then null
        else time_since_last_transaction
    end as time_since_last_transaction,

    spending_deviation_score,
    velocity_score,
    geo_anomaly_score,

    -- Categorical fields (trim + lowercase)
    lower(trim(transaction_type)) as transaction_type,
    lower(trim(merchant_category)) as merchant_category,
    lower(trim(location)) as location,
    lower(trim(device_used)) as device_used,
    lower(trim(payment_channel)) as payment_channel,

    -- Fraud fields
    is_fraud,
    case 
        when is_fraud = true then fraud_type
        else null
    end as fraud_type,

    -- Network fields (trim only)
    trim(ip_address) as ip_address,
    trim(device_hash) as device_hash

from {{ ref('stg_transactions') }}