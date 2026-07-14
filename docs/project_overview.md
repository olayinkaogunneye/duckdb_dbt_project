# 🏦 Fraud Analytics Warehouse — Project Overview

This project implements a fully engineered **Fraud Analytics Warehouse** designed to support real‑time fraud detection, behavioral analysis, machine‑learning feature generation, and analyst‑friendly investigation workflows.

Built using **dbt**, **DuckDB**, **MotherDuck** and a structured multi‑layer architecture, the warehouse transforms raw transactional data into high‑quality analytical features and business‑ready marts. It provides a clean, reliable, and extensible foundation for fraud analysts, data scientists, and risk engineers.

---

## 1. 🎯 Business Problem

Modern financial fraud is increasingly complex, involving:

- account takeover  
- bot‑driven transaction bursts  
- synthetic identities  
- mule networks  
- cross‑border fraud  
- device‑sharing fraud rings  

Traditional rule‑based systems struggle because they rely on isolated transaction attributes rather than **behavioral context**.

This warehouse solves that gap by engineering features that capture:

- customer behavior  
- device behavior  
- geographic movement  
- transaction velocity  
- merchant risk  
- spending anomalies  

These features form the backbone of modern fraud detection systems.

---

## 2. 🏗️ Architectural Overview

The warehouse follows a **layered dbt architecture**, ensuring clarity, modularity, and maintainability.

fraud_raw → main_staging → main_intermediate → marts


### Raw Layer (`fraud_raw`)
- External CSV ingestion  
- Immutable source of truth  
- No transformations  

### Staging Layer (`main_staging`)
- Cleans and standardizes raw data  
- Fixes timestamps, categories, and data types  
- Produces `stg_transactions_raw` and `stg_transactions_clean`  

### Intermediate Layer (`main_intermediate`)
Feature‑engineering core containing:

- **[transaction_features](ca://s?q=Write_transaction_features_documentation)**  
- **[velocity_features](ca://s?q=Write_velocity_features_documentation)**  
- **[geo_risk_features](ca://s?q=Write_geo_risk_features_documentation)**  
- **[device_risk_features](ca://s?q=Write_device_risk_features_documentation)**  
- **[customer_behavior](ca://s?q=Write_customer_behavior_documentation)**  

These models compute behavioral intelligence, anomaly signals, and risk indicators.

### Marts Layer (`marts`)
The final consumption layer, now fully implemented:

- **Fraud Scoring**  
  - `fraud_scoring`  
  - `fraud_score_explainability`  

- **Machine Learning Features**  
  - `ml_feature_table`  

- **Analyst Views**  
  - `customer_risk_profile`  
  - `device_risk_profile`  
  - `daily_fraud_summary`  

- **Dashboards**  
  - `fraud_dashboard_transactions`  
  - `fraud_dashboard_risk_signals`  
  - `fraud_dashboard_trends`  

This layer is optimized for analysts, ML pipelines, and BI dashboards.

---

## 3. 🔍 Key Capabilities

### Behavioral Fraud Detection
Captures:
- recency  
- frequency  
- monetary patterns  
- sudden behavioral changes  

### Velocity‑Based Risk
Detects:
- burst activity  
- hourly/daily velocity  
- sudden spikes  

### Geo‑Risk Analysis
Includes:
- distance between transactions  
- impossible travel  
- high‑risk locations  

### Device Intelligence
Tracks:
- shared devices  
- shared IPs  
- device velocity  
- device‑level bursts  

### Fraud Scoring & Explainability
Provides:
- component risk scores  
- weighted composite fraud score  
- dominant risk driver  
- explainability table  

### Machine Learning Readiness
Supports:
- supervised ML  
- anomaly detection  
- SHAP explainability  
- feature importance analysis  

### Analyst & Dashboard Consumption
Delivers:
- customer risk profiles  
- device risk profiles  
- daily fraud summaries  
- executive dashboards  

---

## 4. 🧰 Technology Stack

- **dbt** — transformations, lineage, documentation  
- **DuckDB** — fast analytical engine  
- **Jinja + SQL** — templated transformations  
- **dbt sources + schemas** — structured warehouse layers  

This stack provides:

- reproducibility  
- modularity  
- transparency  
- high performance  
- low cost  

---

## 5. 🎯 Objectives of the Warehouse

- Provide a **clean, reliable foundation** for fraud analytics  
- Enable **real‑time behavioral insights**  
- Support **machine learning feature engineering**  
- Detect **anomalies and suspicious patterns**  
- Build **explainable fraud signals**  
- Deliver **analyst‑friendly marts**  
- Power **BI dashboards and monitoring systems**  

---

## 6. 🚀 What This Project Enables

Fraud teams can:

- score transactions using engineered features  
- build ML models with rich behavioral context  
- detect fraud rings via device/IP patterns  
- identify impossible travel and geo anomalies  
- monitor customer behavior changes  
- build dashboards for fraud monitoring  
- run investigations with complete lineage and documentation  

---

## 7. 🔮 Future Enhancements

- real‑time scoring tables  
- streaming ingestion  
- graph‑based fraud ring detection  
- device fingerprinting enrichment  
- IP reputation scoring  
- ML prediction tables  
- feature store integration  

---

## 8. 🏁 Summary

This project delivers a complete fraud analytics warehouse that transforms raw transactional data into rich behavioral intelligence and business‑ready marts.

It is:

- modular  
- scalable  
- explainable  
- analyst‑friendly  
- ML‑ready  

This is the type of warehouse used by modern fintechs, banks, and fraud analytics teams.