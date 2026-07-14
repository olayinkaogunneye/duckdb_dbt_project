# 🏗️ Fraud Analytics Warehouse — Architecture Documentation

This document provides a complete architectural overview of the **Fraud Analytics Warehouse** now running on **motherduck**.  
The architecture follows a layered dbt pattern that ensures clarity, modularity, reproducibility, and scalability.  
Each layer has a single responsibility and transforms data in a controlled, well‑documented manner.

The warehouse is built using **dbt**, **DuckDB**, and templated **SQL**, with transformations orchestrated through dbt’s dependency graph.  
It supports analytical workflows, machine‑learning pipelines, fraud scoring, explainability, dashboards, and analyst investigation.

---

## 1. 🧭 Architectural Principles

The warehouse is designed around five core principles:

### **Layered Separation of Concerns**
Each layer performs one job: ingestion → cleaning → feature engineering → consumption.

### **Reproducibility**
All transformations are deterministic SQL models with version‑controlled logic.

### **Transparency**
Every model is documented, tested, and visible through dbt lineage.

### **Scalability**
Feature‑engineering models are modular and can be extended without breaking upstream logic.

### **Explainability**
Fraud features have clear business meaning, supporting analysts and ML models.

---

## 2. 🏛️ Layer Overview

The warehouse consists of **four layers**, each implemented as a dbt schema:

fraud_raw → main_staging → main_intermediate → marts


---

## 2.1 📥 Raw Layer (`fraud_raw`)

The raw layer contains external data sources registered through dbt.

**Characteristics:**
- Data ingested directly from CSV files  
- No transformations applied  
- Immutable source of truth  
- Implemented using dbt `external_location`

**Key object:**
- `fraud_raw.transactions_5m` — 5M synthetic fraud‑related transactions

This layer anchors the entire warehouse.

---

## 2.2 🧹 Staging Layer (`main_staging`)

The staging layer cleans and standardizes raw data.

**Responsibilities:**
- Correct data types  
- Standardize categories  
- Clean timestamps  
- Remove inconsistencies  
- Normalize column naming  

**Key models:**
- `stg_transactions_raw`  
- `stg_transactions_clean`

These models provide a reliable foundation for feature engineering.

---

## 2.3 🧠 Intermediate Layer (`main_intermediate`)

The intermediate layer is the **feature‑engineering core** of the warehouse.  
It transforms clean transactional data into rich behavioral and risk‑based features.

**Feature groups:**

### **Transaction Features**
- amount buckets  
- merchant risk  
- transaction type risk  
- → **[transaction_features](ca://s?q=Write_transaction_features_documentation)**

### **Velocity Features**
- hourly/daily velocity  
- burst detection  
- sudden spikes  
- → **[velocity_features](ca://s?q=Write_velocity_features_documentation)**

### **Geo‑Risk Features**
- distance between transactions  
- impossible travel  
- high‑risk locations  
- → **[geo_risk_features](ca://s?q=Write_geo_risk_features_documentation)**

### **Device Risk Features**
- shared devices  
- shared IPs  
- device velocity  
- device‑level bursts  
- → **[device_risk_features](ca://s?q=Write_device_risk_features_documentation)**

### **Customer Behavior Features**
- recency  
- frequency  
- monetary patterns  
- behavioral anomalies  
- → **[customer_behavior](ca://s?q=Write_customer_behavior_documentation)**

All intermediate models are materialized as **tables** to support downstream analytics and ML workloads.

---

## 2.4 📦 Marts Layer (`marts`)

The **Marts Layer** is the final consumption layer.  
It transforms engineered features into business‑ready datasets for fraud scoring, ML, analysts, and dashboards.

Organized into four logical groups:

marts/
scoring/
ml/
analyst_views/
dashboard/


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

This layer is optimized for consumption by analysts, BI tools, and ML pipelines.

---

## 3. 🔄 End‑to‑End Data Flow

```
fraud_raw.transactions_5m
↓
main_staging/
stg_transactions_raw
stg_transactions_clean
↓
main_intermediate/
transaction_features
velocity_features
geo_risk_features
device_risk_features
customer_behavior
↓
marts/
scoring/
fraud_scoring
fraud_score_explainability
ml/
ml_feature_table
analyst_views/
customer_risk_profile
device_risk_profile
daily_fraud_summary
dashboard/
fraud_dashboard_transactions
fraud_dashboard_risk_signals
fraud_dashboard_trends
↓
Consumption Layer
BI dashboards
fraud analysts
ML pipelines
monitoring systems

```


This flow is fully traceable through dbt’s DAG.

---

## 4. 🗂️ Schema Strategy

Each layer is mapped to a dedicated schema:

| Layer | Schema | Purpose |
|-------|--------|---------|
| Raw | `fraud_raw` | Immutable ingestion |
| Staging | `main_staging` | Clean, standardized data |
| Intermediate | `main_intermediate` | Feature engineering |
| Marts | `marts` | Business‑ready consumption |

This structure ensures:

- clear lineage  
- easy debugging  
- logical separation  
- professional warehouse organization  

---

## 5. 🔗 Model Dependencies

dbt manages dependencies using `ref()` and `source()`:

- `source('fraud_raw', 'transactions_5m')` → raw ingestion  
- `ref('stg_transactions_clean')` → staging → intermediate  
- `ref('transaction_features')` → intermediate → marts  

This creates a fully traceable DAG visible in dbt docs.

## 6.☁️ MotherDuck Integration (New)
The warehouse now uses MotherDuck as its storage backend.

## 6.1 Migration Summary
Local DuckDB file (warehouse.duckdb) uploaded to MotherDuck

Authentication via MotherDuck service token

Cloud database created using:

```CREATE DATABASE md:my_cloud_warehouse FROM current_database();
```

## 6.2 Updated dbt Profile

```yaml
your_project_profile_name:
  target: dev
  outputs:
    dev:
      type: duckdb
      path: 'md:my_cloud_warehouse'
      token: 'YOUR_TOKEN_HERE'
```

## 6.3 Benefits

- No local storage required

- Cloud‑hosted DuckDB

- Same SQL syntax

- Same dbt adapter

- Faster development workflow

- Easy portability across machines

---

## 7. ⚙️ Benefits of This Architecture

- **Modular** — each model is independent and reusable  
- **Extensible** — new fraud features can be added easily  
- **Explainable** — transformations have clear business meaning  
- **ML‑ready** — engineered features support supervised/unsupervised models  
- **Analyst‑friendly** — marts provide clean, aggregated views  
- **High‑performance** — DuckDB ensures fast local analytics  
- **Transparent** — dbt lineage shows full end‑to‑end flow  

---

## 8. 🏁 Summary

This architecture transforms raw transactional data into a rich, feature‑engineered fraud analytics warehouse.  
It is:

- layered  
- scalable  
- transparent  
- well‑documented  
- aligned with modern analytics engineering best practices  

The structure supports real‑time fraud detection, advanced machine‑learning workflows, dashboards, and analyst investigation.