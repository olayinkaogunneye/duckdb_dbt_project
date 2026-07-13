# Intermediate Layer Documentation

The **Intermediate Layer** is the feature‑engineering core of the Fraud Analytics Warehouse.  
It transforms clean transactional data from the staging layer into rich behavioral, geographic, device‑level, and velocity‑based features that power fraud detection, risk scoring, and machine‑learning models.

This layer is implemented in the schema **`main_intermediate`** and contains multiple modular models, each responsible for a specific fraud‑related domain.

---

## 1. Purpose of the Intermediate Layer

The intermediate layer exists to:

- engineer high‑value fraud features  
- detect anomalies and suspicious patterns  
- enrich transactions with behavioral context  
- prepare data for fraud scoring and ML pipelines  
- separate feature logic from raw cleaning and final consumption  

It is the most analytically intensive layer of the warehouse.

---

## 2. Input Dependency

All intermediate models depend on:

- `ref('stg_transactions_clean')`

This ensures:

- clean, standardized inputs  
- consistent data types  
- reliable timestamps  
- normalized categories  
- reproducible transformations  

---

## 3. Intermediate Models Overview

The intermediate layer consists of five major feature‑engineering models:

1. **Transaction Features**  
2. **Velocity Features**  
3. **Geo‑Risk Features**  
4. **Device Risk Features**  
5. **Customer Behavior Features**

Each model focuses on a specific fraud‑detection domain and produces a table materialized as a **physical table** for performance and stability.

---

## 4. Transaction Features

**Model:** `transaction_features`

This model enriches each transaction with categorical risk signals:

### Key Transformations
- Bucketize transaction amounts (e.g., low, medium, high).  
- Assign risk scores to transaction types.  
- Assign risk scores to merchant categories.  

### Purpose
- Detect high‑risk merchant categories.  
- Identify risky transaction types (e.g., international transfers).  
- Provide categorical features for ML models.

---

## 5. Velocity Features

**Model:** `velocity_features`

This model captures short‑term and long‑term transaction velocity patterns.

### Key Transformations
- Compute corrected time differences between transactions.  
- Count transactions in 1‑hour and 24‑hour windows.  
- Calculate average amount in short windows.  
- Detect burst activity (≥5 transactions in 1 hour).  
- Detect sudden spikes in velocity.  

### Purpose
- Identify bot‑like behavior.  
- Detect mule account bursts.  
- Capture abnormal transaction frequency.  
- Provide temporal features for fraud scoring.

---

## 6. Geo‑Risk Features

**Model:** `geo_risk_features`

This model computes geographic movement and location‑based risk.

### Key Transformations
- Map transaction locations to latitude/longitude.  
- Compute distance between consecutive transactions (Haversine).  
- Calculate geographic velocity (km/h).  
- Detect impossible travel (>900 km/h).  
- Flag high‑risk locations.  
- Flag large geographic jumps (>500 km).  

### Purpose
- Detect account takeover across regions.  
- Identify suspicious cross‑border movement.  
- Flag transactions from high‑risk cities.  
- Provide geo‑spatial features for ML models.

---

## 7. Device Risk Features

**Model:** `device_risk_features`

This model analyzes device and IP behavior to detect fraud rings and compromised devices.

### Key Transformations
- Count accounts per device.  
- Count IPs per device.  
- Count devices per IP.  
- Compute device‑level transaction velocity.  
- Detect device bursts (≥10 transactions in 1 hour).  
- Flag shared devices and shared IPs.  
- Flag devices previously involved in fraud.  

### Purpose
- Identify fraud rings using shared devices.  
- Detect compromised devices.  
- Flag VPN hopping and anonymization.  
- Provide device‑level intelligence for fraud scoring.

---

## 8. Customer Behavior Features

**Model:** `customer_behavior`

This model computes behavioral patterns using RFM‑style metrics.

### Key Transformations
- Compute recency (time since last transaction).  
- Count transactions in 7‑day and 30‑day windows.  
- Compute average and total spend over 30 days.  
- Detect sudden changes in spending (>50% deviation).  
- Detect abnormal short‑term vs long‑term frequency.  

### Purpose
- Detect account takeover.  
- Identify sudden behavioral shifts.  
- Capture long‑term vs short‑term patterns.  
- Provide customer‑level features for ML models.

---

## 9. Materialization Strategy

All intermediate models are materialized as **tables** because:

- they are reused across multiple marts  
- they contain computationally heavy logic  
- they improve performance for downstream joins  
- they support ML pipelines efficiently  

This ensures stability and speed in the marts layer.

---

## 10. Data Flow Summary

The intermediate layer follows this flow:

stg_transactions_clean
↓
transaction_features
velocity_features
geo_risk_features
device_risk_features
customer_behavior
↓
marts layer (fraud scoring, ML features, dashboards)


Each model is independent but shares the same clean staging input.

---

## 11. Why the Intermediate Layer Matters

The intermediate layer provides:

- **behavioral intelligence**  
- **risk signals**  
- **anomaly detection**  
- **device/IP insights**  
- **geo‑spatial analysis**  
- **velocity‑based risk**  

These features are essential for:

- fraud scoring  
- machine learning  
- dashboards  
- investigations  
- monitoring systems  

Without this layer, fraud detection would rely only on raw transaction attributes, which is insufficient for modern fraud patterns.

---

## 12. Summary

The intermediate layer transforms clean transactional data into rich, multi‑dimensional fraud features.  
It is:

- modular  
- scalable  
- explainable  
- high‑performance  
- ML‑ready  

This layer is the analytical engine of the Fraud Analytics Warehouse and the foundation of the upcoming **marts layer**.