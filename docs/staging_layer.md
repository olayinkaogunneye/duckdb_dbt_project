# Staging Layer Documentation

The **Staging Layer** is the foundation of the Fraud Analytics Warehouse.  
Its purpose is to transform raw transactional data into a clean, standardized, and analysis‑ready dataset.  
This layer ensures data quality, consistency, and correctness before any feature engineering occurs.

The staging layer is implemented in the schema **`main_staging`** and contains two primary models:

- `stg_transactions_raw`
- `stg_transactions_clean`

These models serve as the trusted inputs for all intermediate feature‑engineering models.

---

## 1. Purpose of the Staging Layer

The staging layer exists to:

- clean raw data  
- standardize column names  
- enforce correct data types  
- fix inconsistent or missing values  
- normalize categories  
- prepare data for downstream transformations  
- ensure reproducibility and transparency  

It acts as the **single source of truth** for all engineered features.

---

## 2. Source Definition

Raw data is ingested from an external CSV file registered through dbt:

- Source name: **`fraud_raw`**
- Table: **`transactions_5m`**
- Storage: external CSV via `external_location`
- Schema: **`fraud_raw`**

This raw dataset contains 5 million synthetic fraud‑related transactions.

---

## 3. Staging Models

### 3.1 `stg_transactions_raw`

This model performs **minimal transformations** on the raw dataset.  
Its purpose is to:

- rename columns  
- enforce correct data types  
- preserve raw values  
- provide a clean baseline for further processing  

It ensures that downstream models do not rely directly on raw CSV data.

---

### 3.2 `stg_transactions_clean`

This model applies **full cleaning and standardization**, including:

#### Data Type Corrections
- Convert timestamps to proper datetime format  
- Cast numeric fields (amount, scores) to numeric types  
- Normalize boolean fields (`is_fraud`)  

#### Category Standardization
- Normalize merchant categories  
- Standardize transaction types  
- Clean location names  
- Normalize device types and payment channels  

#### Value Corrections
- Fix negative timestamps  
- Correct negative or invalid time differences  
- Handle missing or null fields  
- Remove or correct inconsistent values  

#### Derived Fields
The model also computes several foundational fields used in feature engineering:

- `time_since_last_transaction`  
- `spending_deviation_score`  
- `velocity_score`  
- `geo_anomaly_score`  

These fields provide the first layer of behavioral intelligence.

---

## 4. Cleaning Logic Summary

The following transformations are applied:

### Timestamp Cleaning
- Convert raw timestamp strings to proper datetime objects  
- Remove invalid or malformed timestamps  
- Ensure chronological ordering per customer  

### Amount Cleaning
- Cast to numeric  
- Remove negative values  
- Standardize currency format (if applicable)  

### Category Normalization
- Lowercase and trim category names  
- Map inconsistent merchant categories to standard labels  
- Normalize transaction types (e.g., “Transfer”, “transfer”, “TRANSFER”)  

### Location Standardization
- Lowercase and trim location names  
- Map known city aliases to canonical names  

### Device & IP Cleaning
- Normalize device types  
- Standardize IP address formatting  
- Remove invalid device hashes  

---

## 5. Output Schema

The staging layer produces two clean tables:

### `main_staging.stg_transactions_raw`
- minimally cleaned  
- standardized column names  
- correct data types  

### `main_staging.stg_transactions_clean`
- fully cleaned  
- standardized categories  
- corrected timestamps  
- derived behavioral fields  
- ready for feature engineering  

These tables serve as the **input** for all intermediate models.

---

## 6. Why the Staging Layer Matters

The staging layer ensures:

- **Data Quality**  
  Downstream models rely on clean, consistent inputs.

- **Reproducibility**  
  All cleaning logic is expressed in SQL and version‑controlled.

- **Transparency**  
  Analysts can trace every transformation back to the raw source.

- **Performance**  
  Materializing staging tables improves downstream query speed.

- **Modularity**  
  Cleaning logic is separated from feature engineering.

---

## 7. Dependencies

The staging layer depends on:

- `source('fraud_raw', 'transactions_5m')`

Intermediate models depend on:

- `ref('stg_transactions_clean')`

This creates a clear, traceable lineage through dbt.

---

## 8. Summary

The staging layer transforms raw transactional data into a clean, standardized dataset ready for feature engineering.  
It ensures:

- correctness  
- consistency  
- transparency  
- reliability  

This layer is the backbone of the Fraud Analytics Warehouse and enables all downstream velocity, geo‑risk, device‑risk, and behavioral models.