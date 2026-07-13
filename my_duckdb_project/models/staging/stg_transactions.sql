-- models/staging/stg_transactions_raw.sql

{{ config(materialized='table') }}

select *
from {{ source('fraud_raw', 'transactions_5m') }}