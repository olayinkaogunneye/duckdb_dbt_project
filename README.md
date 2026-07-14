# 🏦 Fraud Analytics Warehouse  
### End‑to‑End Fraud Detection, Feature Engineering & Analytics (dbt + DuckDB + Python)

This repository contains a fully engineered **Fraud Analytics Warehouse** designed for real‑time fraud detection, behavioral analytics, machine‑learning feature generation, and analyst‑friendly investigation workflows.

Built using **dbt**, **DuckDB**, **Python**, and **Jupyter Notebooks**, the warehouse transforms raw transactional data into high‑quality engineered features and business‑ready marts.  
It is structured, scalable, explainable, and aligned with modern fintech fraud analytics architecture.

---

# 📚 Table of Contents

- [Overview](#overview)  
- [Business Problem](#business-problem)  
- [Architecture](#architecture)  
- [Data Cleaning & Pre‑Processing](#data-cleaning--pre-processing)  
- [Exploratory Data Analysis (EDA)](#exploratory-data-analysis-eda)  
- [Feature Engineering](#feature-engineering)  
- [Marts Layer](#marts-layer)  
- [Machine Learning Readiness](#machine-learning-readiness)  
- [Dashboards](#dashboards)  
- [Project Structure](#project-structure)  
- [Future Enhancements](#future-enhancements)  
- [Summary](#summary)

---

# 🧭 Overview

Modern fraud requires **behavioral context**, not isolated transaction rules.  
This project builds a complete fraud analytics warehouse that captures:

- customer behavior  
- device behavior  
- geographic movement  
- transaction velocity  
- spending anomalies  
- risk signals  
- explainability  

The warehouse supports:

- fraud analysts  
- data scientists  
- ML engineers  
- BI dashboards  
- monitoring systems  

---

# 🚨 Business Problem

Financial institutions face increasingly complex fraud patterns:

- account takeover  
- bot‑driven bursts  
- synthetic identities  
- mule networks  
- cross‑border fraud  
- device/IP fraud rings  

Traditional rule‑based systems fail because they lack **behavioral intelligence**.

This warehouse solves that gap.

---

# 🏗️ Architecture

The warehouse follows a clean, layered dbt architecture:

fraud_raw → main_staging → main_intermediate → marts


### **Raw Layer (`fraud_raw`)**
- External CSV ingestion  
- Immutable source of truth  

### **Staging Layer (`main_staging`)**
- Data cleaning  
- Standardization  
- Type fixing  
- Timestamp normalization  

### **Intermediate Layer (`main_intermediate`)**
Feature‑engineering core:

- transaction features  
- velocity features  
- geo‑risk features  
- device‑risk features  
- customer behavior  

### **Marts Layer (`marts`)**
Final consumption layer:

- fraud scoring  
- explainability  
- ML feature table  
- analyst views  
- dashboard tables  

---

# ☁️ MotherDuck Integration

The warehouse originally used a local DuckDB file (`warehouse.duckdb`).  
It has now been migrated to **MotherDuck**, enabling cloud‑hosted storage and freeing local disk space.

### **Migration Summary**
1. Retrieve MotherDuck service token  
2. Open local DuckDB file  
3. Authenticate with MotherDuck  
4. Upload local warehouse using:

```sql
CREATE DATABASE md:my_cloud_warehouse FROM current_database();

```
**Updated dbt Profile** 

```yaml
your_project_profile_name:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'md:my_cloud_warehouse'
      token: 'YOUR_TOKEN_HERE'

```
# 🧹 Data Cleaning & Pre‑Processing

All data cleaning and preprocessing is implemented in dbt, not in notebooks.

Cleaning models:

- `stg_transactions_raw`

### Cleaning tasks included:
- fixing timestamps  
- removing negative amounts  
- normalizing merchant categories  
- standardizing device/IP formats  
- handling missing values  
- correcting inconsistent location formats  
- validating schema integrity  
- deduplicating records  

The cleaned dataset is materialized as:
  
- `stg_transactions_clean`

These models form the foundation for feature engineering.

---

# 📊 Exploratory Data Analysis (EDA)

EDA was performed in:

notebooks/02_eda.ipynb


### EDA included:
- distribution analysis (amount, velocity, geo movement)  
- fraud vs non‑fraud comparisons  
- device/IP usage patterns  
- customer behavioral trends  
- correlation heatmaps  
- anomaly detection exploration  
- outlier identification  
- temporal fraud trends  

EDA validated the engineered features and informed the scoring logic.

---

# 🧠 Feature Engineering

The intermediate layer computes rich behavioral and risk‑based features:

### **Transaction Features**
- amount buckets  
- merchant risk  
- transaction type risk  

### **Velocity Features**
- hourly/daily velocity  
- burst detection  
- sudden spikes  

### **Geo‑Risk Features**
- distance between transactions  
- impossible travel  
- high‑risk locations  

### **Device Risk Features**
- shared devices  
- shared IPs  
- device velocity  
- device bursts  

### **Customer Behavior**
- recency  
- frequency  
- monetary patterns  
- spending anomalies  

All features are materialized as tables for ML and analytics.

---

# 🛡️ Marts Layer

The marts layer is the final consumption layer, organized into:

```
marts/
scoring/
ml/
analyst_views/
dashboard/

```


### **Scoring**
- `fraud_scoring`  
- `fraud_score_explainability`  

### **Machine Learning**
- `ml_feature_table`  

### **Analyst Views**
- `customer_risk_profile`  
- `device_risk_profile`  
- `daily_fraud_summary`  

### **Dashboards**
- `fraud_dashboard_transactions`  
- `fraud_dashboard_risk_signals`  
- `fraud_dashboard_trends`  

---

# 🤖 Machine Learning Readiness

The ML feature table provides:

- wide, denormalized features  
- encoded categorical variables  
- numeric behavioral metrics  
- anomaly flags  
- target variable (`is_fraud`)  

It is optimized for:

- supervised ML  
- unsupervised anomaly detection  
- SHAP explainability  
- feature importance analysis  

---

# 📈 Dashboards

Dashboard tables support:

- daily fraud monitoring  
- weekly fraud trends  
- anomaly spikes  
- customer/device risk summaries  
- executive reporting  

Optimized for Power BI, Tableau, and Looker.

---

# 📁 Project Structure

```
├── models/
│   ├── fraud_raw/
│   ├── main_staging/
│   ├── main_intermediate/
│   └── marts/
│       ├── scoring/
│       ├── ml/
│       ├── analyst_views/
│       └── dashboard/
├── notebooks/
│   ├── 01_data_cleaning.ipynb
│   └── 02_eda.ipynb
├── docs/
│   ├── project_overview.md
│   ├── architecture.md
│   ├── marts_layer.md
│   └── data_dictionary.md
└── README.md
```


---

# 🚀 Future Enhancements

- real‑time scoring  
- streaming ingestion  
- graph‑based fraud ring detection  
- device fingerprinting enrichment  
- IP reputation scoring  
- ML prediction marts  
- feature store integration  

---

# 🏁 Summary

This project delivers a complete fraud analytics warehouse that transforms raw transactional data into rich behavioral intelligence and business‑ready marts.

It is:

- modular  
- scalable  
- explainable  
- analyst‑friendly  
- ML‑ready  

Exactly the kind of warehouse used by modern fintechs, banks, and fraud analytics teams.