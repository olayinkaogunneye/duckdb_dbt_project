# Data Dictionary

This document provides a complete data dictionary for the Fraud Analytics Warehouse.  
It describes every column across the staging and intermediate layers, including:

- transactional attributes  
- engineered features  
- behavioral metrics  
- device intelligence  
- geo‑risk signals  
- velocity‑based risk  
- fraud indicators  

Each field includes a clear business definition and its analytical purpose.

---

## 1. Transaction Fields

| Field | Description |
|-------|-------------|
| **transaction_id** | Unique identifier for each transaction. |
| **timestamp** | Date and time when the transaction occurred. |
| **sender_account** | Customer account initiating the transaction. |
| **receiver_account** | Destination account receiving the funds. |
| **amount** | Monetary value of the transaction. |
| **transaction_type** | Category of transaction (e.g., transfer, payment, withdrawal). |
| **merchant_category** | Type of merchant involved (e.g., retail, travel, food). |
| **location** | City or region where the transaction occurred. |
| **device_used** | Device type used (e.g., mobile, web, POS). |
| **payment_channel** | Channel used (e.g., online, in‑store, mobile app). |
| **ip_address** | IP address associated with the transaction. |
| **device_hash** | Hashed device fingerprint used for device‑level tracking. |
| **is_fraud** | Boolean flag indicating whether the transaction is fraudulent. |
| **fraud_type** | Category of fraud (e.g., account takeover, synthetic identity). |

---

## 2. Staging‑Level Derived Fields

| Field | Description |
|-------|-------------|
| **time_since_last_transaction** | Time difference (seconds) between consecutive transactions for the same customer. |
| **spending_deviation_score** | Difference between current amount and typical spending pattern. |
| **velocity_score** | Short‑term transaction velocity indicator. |
| **geo_anomaly_score** | Score indicating geographic irregularities. |

---

## 3. Transaction Feature Fields

| Field | Description |
|-------|-------------|
| **amount_bucket** | Categorized transaction amount (e.g., low, medium, high). |
| **transaction_type_risk** | Risk score associated with the transaction type. |
| **merchant_category_risk** | Risk score associated with the merchant category. |

---

## 4. Velocity Feature Fields

| Field | Description |
|-------|-------------|
| **true_time_since_last_txn** | Corrected time difference between consecutive transactions. |
| **txn_count_1h** | Number of transactions in the past 1 hour for the same customer. |
| **txn_count_24h** | Number of transactions in the past 24 hours for the same customer. |
| **avg_amount_1h** | Average transaction amount in the past 1 hour. |
| **burst_flag** | Indicates whether the customer performed ≥5 transactions in 1 hour. |
| **prev_txn_count_1h** | Previous hour’s transaction count. |
| **sudden_velocity_change** | Flags sudden spikes in transaction velocity. |

---

## 5. Geo‑Risk Feature Fields

| Field | Description |
|-------|-------------|
| **curr_lat** | Latitude of the current transaction location. |
| **curr_lon** | Longitude of the current transaction location. |
| **prev_lat** | Latitude of the previous transaction location. |
| **prev_lon** | Longitude of the previous transaction location. |
| **distance_km** | Distance (km) between consecutive transaction locations. |
| **time_diff_seconds** | Time difference between consecutive transactions. |
| **geo_velocity_kmh** | Geographic speed (km/h) between transactions. |
| **location_change_flag** | Flags large geographic jumps (>500 km). |
| **impossible_travel_flag** | Flags geographic movement faster than 900 km/h. |
| **high_risk_location_flag** | Flags transactions occurring in known high‑risk regions. |

---

## 6. Device Risk Feature Fields

| Field | Description |
|-------|-------------|
| **accounts_per_device** | Number of distinct accounts using the same device. |
| **ips_per_device** | Number of distinct IP addresses used by the same device. |
| **devices_per_ip** | Number of distinct devices sharing the same IP. |
| **device_txn_count_1h** | Number of transactions performed by the device in the past hour. |
| **shared_device_flag** | Flags devices used by multiple accounts (>3). |
| **device_ip_risk_flag** | Flags devices using many IPs (>5). |
| **shared_ip_flag** | Flags IPs shared by many devices (>5). |
| **device_burst_flag** | Flags devices performing ≥10 transactions in 1 hour. |
| **high_risk_device_flag** | Flags devices previously involved in fraud. |

---

## 7. Customer Behavior Feature Fields

| Field | Description |
|-------|-------------|
| **recency_seconds** | Time since the customer’s previous transaction. |
| **txn_count_7d** | Number of transactions in the past 7 days. |
| **txn_count_30d** | Number of transactions in the past 30 days. |
| **avg_amount_30d** | Average transaction amount over the past 30 days. |
| **total_amount_30d** | Total transaction amount over the past 30 days. |
| **prev_amount** | Previous transaction amount. |
| **sudden_spend_change** | Flags large changes in spending (>50% deviation). |
| **unusual_frequency_pattern** | Flags abnormal short‑term vs long‑term activity. |

---

## 8. Fraud Indicator Fields

| Field | Description |
|-------|-------------|
| **risk_signals** | Combined risk indicators from velocity, geo, device, and behavior features. |
| **anomaly_flags** | Flags representing unusual or suspicious patterns. |
| **fraud_score** (future) | Composite fraud score for each transaction. |

---

## 9. Summary

This data dictionary provides a complete reference for all fields used across the Fraud Analytics Warehouse.  
It supports:

- fraud investigation  
- feature engineering  
- machine learning  
- dashboarding  
- documentation  
- lineage tracking  

As the warehouse evolves, new fields will be added to this dictionary to maintain clarity and transparency.







# 📘 Marts Layer — Data Dictionary  
**Fraud Analytics Warehouse (Schema: `marts`)**

This document provides a complete data dictionary for all models in the **Marts Layer**.  
It covers:

- Fraud Scoring  
- Fraud Score Explainability  
- Machine Learning Feature Tables  
- Analyst Views  
- Dashboard Tables  

The marts layer is the final consumption layer of the warehouse and contains business‑ready datasets for analysts, ML pipelines, dashboards, and monitoring systems.

---

# 1. 🛡️ Fraud Scoring Models  
## 1.1 `fraud_scoring`

| Field | Description |
|-------|-------------|
| **transaction_id** | Unique identifier for the transaction. |
| **timestamp** | Timestamp of the transaction. |
| **sender_account** | Account initiating the transaction. |
| **receiver_account** | Account receiving the transaction. |
| **amount** | Transaction amount. |
| **location** | Location of the transaction. |
| **device_hash** | Hashed device fingerprint. |
| **ip_address** | IP address used. |
| **velocity_risk_score** | Risk score derived from velocity features. |
| **geo_risk_score** | Risk score derived from geo‑risk features. |
| **device_risk_score** | Risk score derived from device features. |
| **behavior_risk_score** | Risk score derived from customer behavior. |
| **transaction_risk_score** | Risk score derived from transaction attributes. |
| **fraud_score** | Composite fraud score (rule‑based). |
| **fraud_flag** | Boolean fraud indicator. |

---

## 1.2 `fraud_score_explainability`  
Provides a transparent breakdown of the fraud score.

| Field | Description |
|-------|-------------|
| **transaction_id** | Unique transaction identifier. |
| **timestamp** | Transaction timestamp. |
| **sender_account** | Customer initiating the transaction. |
| **receiver_account** | Customer receiving funds. |
| **amount** | Transaction amount. |
| **location** | Transaction location. |
| **device_hash** | Device fingerprint. |
| **ip_address** | IP address used. |
| **velocity_risk_score** | Velocity‑based risk contribution. |
| **geo_risk_score** | Geo‑risk contribution. |
| **device_risk_score** | Device‑risk contribution. |
| **behavior_risk_score** | Behavioral risk contribution. |
| **transaction_risk_score** | Transaction‑type risk contribution. |
| **fraud_score** | Final composite score. |
| **fraud_flag** | Fraud indicator. |
| **dominant_risk_driver** | Highest contributing risk domain. |

---

# 2. 🤖 Machine Learning Feature Table  
## 2.1 `ml_feature_table`

This is a wide, denormalized ML‑ready dataset.

### Target Variable
| Field | Description |
|-------|-------------|
| **is_fraud** | Binary target variable for ML training. |

### Numeric Features
| Field | Description |
|-------|-------------|
| **amount** | Raw transaction amount. |
| **true_time_since_last_txn** | Time since previous transaction. |
| **txn_count_1h** | Transactions in past hour. |
| **txn_count_24h** | Transactions in past 24 hours. |
| **avg_amount_1h** | Average amount in past hour. |
| **distance_km** | Distance between consecutive transactions. |
| **geo_velocity_kmh** | Geographic movement speed. |
| **accounts_per_device** | Number of accounts using the device. |
| **ips_per_device** | Number of IPs used by the device. |
| **devices_per_ip** | Number of devices sharing the IP. |
| **device_txn_count_1h** | Device transactions in past hour. |
| **recency_seconds** | Time since last customer transaction. |
| **txn_count_7d** | Transactions in past 7 days. |
| **txn_count_30d** | Transactions in past 30 days. |
| **avg_amount_30d** | Average amount over 30 days. |
| **total_amount_30d** | Total amount over 30 days. |

### Encoded Categorical Features
| Field | Description |
|-------|-------------|
| **amount_bucket_encoded** | Numeric encoding of amount bucket. |
| **transaction_type_risk_encoded** | Numeric encoding of transaction type risk. |
| **merchant_category_risk_encoded** | Numeric encoding of merchant category risk. |

### Binary Flags
| Field | Description |
|-------|-------------|
| **burst_flag** | Velocity burst indicator. |
| **sudden_velocity_change** | Sudden velocity spike. |
| **location_change_flag** | Large geographic jump. |
| **impossible_travel_flag** | Impossible travel speed. |
| **high_risk_location_flag** | High‑risk region indicator. |
| **shared_device_flag** | Device shared by multiple accounts. |
| **device_ip_risk_flag** | Device using many IPs. |
| **shared_ip_flag** | IP shared by many devices. |
| **device_burst_flag** | Device burst activity. |
| **high_risk_device_flag** | Device previously involved in fraud. |
| **sudden_spend_change** | Spending anomaly. |
| **unusual_frequency_pattern** | Frequency anomaly. |

### Traceability Fields
| Field | Description |
|-------|-------------|
| **transaction_id** | Unique transaction ID. |
| **sender_account** | Customer initiating the transaction. |
| **receiver_account** | Customer receiving funds. |
| **timestamp** | Transaction timestamp. |
| **device_hash** | Device fingerprint. |
| **ip_address** | IP address used. |
| **transaction_type** | Transaction category. |
| **merchant_category** | Merchant category. |
| **location** | Transaction location. |

---

# 3. 👩🏾‍💼 Analyst Views  
## 3.1 `customer_risk_profile`

| Field | Description |
|-------|-------------|
| **sender_account** | Customer account. |
| **total_transactions** | Total transactions performed. |
| **fraud_count** | Number of fraudulent transactions. |
| **avg_fraud_score** | Average fraud score. |
| **avg_recency_seconds** | Average recency. |
| **avg_txn_count_7d** | Avg 7‑day transaction count. |
| **avg_txn_count_30d** | Avg 30‑day transaction count. |
| **avg_amount_30d** | Avg 30‑day amount. |
| **total_amount_30d** | Total 30‑day amount. |
| **avg_txn_count_1h** | Avg hourly velocity. |
| **avg_txn_count_24h** | Avg daily velocity. |
| **burst_events** | Number of burst anomalies. |
| **impossible_travel_events** | Geo‑risk anomalies. |
| **high_risk_location_events** | High‑risk location count. |
| **distinct_devices** | Number of devices used. |
| **shared_device_events** | Shared device anomalies. |
| **customer_risk_tier** | Low / Medium / High risk tier. |

---

## 3.2 `device_risk_profile`

| Field | Description |
|-------|-------------|
| **device_hash** | Device fingerprint. |
| **total_transactions** | Total device transactions. |
| **fraud_count** | Fraudulent transactions. |
| **avg_fraud_score** | Average fraud score. |
| **avg_accounts_per_device** | Avg accounts using device. |
| **avg_ips_per_device** | Avg IPs used by device. |
| **avg_devices_per_ip** | Avg devices sharing IP. |
| **shared_device_events** | Shared device anomalies. |
| **device_burst_events** | Burst activity. |
| **high_risk_device_events** | High‑risk device signals. |
| **high_risk_location_events** | Geo‑risk anomalies. |
| **device_risk_tier** | Low / Medium / High risk tier. |

---

## 3.3 `daily_fraud_summary`

| Field | Description |
|-------|-------------|
| **txn_date** | Date of transactions. |
| **total_transactions** | Total daily transactions. |
| **fraud_transactions** | Fraudulent transactions. |
| **avg_fraud_score** | Average fraud score. |
| **burst_events** | Velocity bursts. |
| **impossible_travel_events** | Geo anomalies. |
| **shared_device_events** | Device anomalies. |

---

# 4. 📊 Dashboard Tables  
## 4.1 `fraud_dashboard_transactions`

| Field | Description |
|-------|-------------|
| **txn_date** | Date. |
| **total_transactions** | Total transactions. |
| **fraud_transactions** | Fraud count. |
| **avg_fraud_score** | Average fraud score. |
| **avg_amount** | Average transaction amount. |
| **max_amount** | Maximum transaction amount. |
| **total_amount** | Total daily amount. |
| **distinct_customers** | Unique customers. |

---

## 4.2 `fraud_dashboard_risk_signals`

| Field | Description |
|-------|-------------|
| **txn_date** | Date. |
| **burst_events** | Velocity bursts. |
| **sudden_velocity_events** | Sudden velocity spikes. |
| **impossible_travel_events** | Impossible travel. |
| **high_risk_location_events** | High‑risk locations. |
| **shared_device_events** | Shared devices. |
| **device_burst_events** | Device bursts. |
| **high_risk_device_events** | High‑risk devices. |
| **sudden_spend_change_events** | Spending anomalies. |
| **unusual_frequency_events** | Frequency anomalies. |

---

## 4.3 `fraud_dashboard_trends`

| Field | Description |
|-------|-------------|
| **week_start** | Start of week. |
| **total_transactions** | Weekly transactions. |
| **fraud_transactions** | Weekly fraud count. |
| **avg_fraud_score** | Weekly average fraud score. |
| **weekly_burst_events** | Weekly velocity bursts. |
| **weekly_impossible_travel_events** | Weekly geo anomalies. |
| **weekly_shared_device_events** | Weekly device anomalies. |

---

# 5. 🏁 Summary

This data dictionary provides a complete reference for all marts‑layer fields across:

- fraud scoring  
- explainability  
- ML feature engineering  
- analyst views  
- dashboards  

It ensures clarity, transparency, and consistency across fraud analytics, ML modeling, and BI reporting.