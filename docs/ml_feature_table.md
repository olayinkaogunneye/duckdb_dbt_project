# ML Feature Table Documentation

The `ml_feature_table` is the primary dataset used for training machine‑learning fraud models.  
It is a **wide, denormalized, numeric‑heavy table** containing all engineered features from the intermediate layer, encoded and ready for ML pipelines.

This table is materialized in the schema **`marts`**.

---

## 1. Purpose

- Provide a single, unified feature table for ML training.  
- Convert categorical features into numeric encodings.  
- Convert boolean flags into binary indicators.  
- Ensure no joins are required during model training or inference.  
- Maintain full traceability via transaction‑level identifiers.

---

## 2. Inputs

The table consumes:

- `transaction_features`  
- `velocity_features`  
- `geo_risk_features`  
- `device_risk_features`  
- `customer_behavior`

All joined on `transaction_id`.

---

## 3. Outputs

The ML feature table contains:

### Target Variable
- `is_fraud`

### Numeric Features
- amount  
- true_time_since_last_txn  
- txn_count_1h  
- txn_count_24h  
- avg_amount_1h  
- distance_km  
- geo_velocity_kmh  
- accounts_per_device  
- ips_per_device  
- devices_per_ip  
- device_txn_count_1h  
- recency_seconds  
- txn_count_7d  
- txn_count_30d  
- avg_amount_30d  
- total_amount_30d  

### Encoded Categorical Features
- amount_bucket_encoded  
- transaction_type_risk_encoded  
- merchant_category_risk_encoded  

### Binary Flags
- burst_flag  
- sudden_velocity_change  
- location_change_flag  
- impossible_travel_flag  
- high_risk_location_flag  
- shared_device_flag  
- device_ip_risk_flag  
- shared_ip_flag  
- device_burst_flag  
- high_risk_device_flag  
- sudden_spend_change  
- unusual_frequency_pattern  

### Traceability Fields
- transaction_id  
- sender_account  
- receiver_account  
- timestamp  
- device_hash  
- ip_address  
- transaction_type  
- merchant_category  
- location  

---

## 4. Why This Table Works for ML

- **Wide format** → ideal for tree‑based models (XGBoost, LightGBM, CatBoost).  
- **Numeric‑heavy** → avoids preprocessing overhead.  
- **Binary flags** → easy for models to interpret.  
- **Encoded categories** → avoids one‑hot explosion.  
- **No joins** → fast inference in production.  
- **Traceability** → analysts can investigate predictions.

---

## 5. Use Cases

- supervised fraud detection  
- anomaly detection  
- model explainability (SHAP values)  
- feature importance analysis  
- retraining pipelines  
- batch or real‑time scoring  

---

## 6. Future Enhancements

- add model predictions (`fraud_probability`)  
- add SHAP values for explainability  
- integrate external threat intelligence (IP reputation)  
- add graph‑based features (device‑account networks)  
- add embeddings for merchant categories  

---

## 7. Summary

The `ml_feature_table` is the core dataset powering machine‑learning fraud detection.  
It is:

- wide  
- numeric  
- encoded  
- traceable  
- production‑ready  

This table is the bridge between your engineered features and your ML models.