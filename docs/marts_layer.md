# 📦 Marts Layer Documentation  
**Fraud Analytics Warehouse — Final Consumption Layer**

The **Marts Layer** is the final consumption layer of the Fraud Analytics Warehouse.  
It transforms engineered features from the intermediate layer into business‑ready datasets for:

- fraud scoring  
- machine learning  
- analyst investigation  
- BI dashboards  

All marts models are materialized in the **`marts`** schema and organized into four logical groups:

```
marts/
scoring/
ml/
analyst_views/
dashboard/

```


This structure keeps the warehouse clean, modular, and easy to navigate.

---

## 1. 🎯 Purpose of the Marts Layer

The marts layer exists to:

- combine engineered features into unified fraud scoring datasets  
- prepare wide, denormalized tables for ML training  
- provide aggregated, interpretable views for fraud analysts  
- deliver lightweight, fast tables for dashboards  
- expose explainability fields for investigation  
- ensure consistent consumption across teams  

It is the **final output layer** of the warehouse.

---

## 2. 🔗 Input Dependencies

All marts models depend on intermediate models:

- `transaction_features`  
- `velocity_features`  
- `geo_risk_features`  
- `device_risk_features`  
- `customer_behavior`  

These provide:

- categorical risk signals  
- velocity‑based risk  
- geo‑risk signals  
- device/IP intelligence  
- behavioral features  

The marts layer **does not engineer new features** — it **consumes** existing ones.

---

## 3. 🧩 Marts Layer Components

### 3.1 🛡️ Fraud Scoring Models  
**Models:**
- `fraud_scoring`  
- `fraud_score_explainability`

**Outputs:**
- component risk scores  
- weighted composite fraud score  
- fraud flag  
- dominant risk driver  
- explainability fields  

**Purpose:**
- rule‑based fraud scoring  
- analyst investigation  
- model debugging  
- comparison with ML predictions  

---

### 3.2 🤖 Machine Learning Feature Tables  
**Model:**
- `ml_feature_table`

**Outputs:**
- numeric features  
- encoded categorical features  
- binary anomaly flags  
- target variable  
- traceability fields  

**Purpose:**
- supervised ML training  
- unsupervised anomaly detection  
- feature importance analysis  
- SHAP explainability (future)  

---

### 3.3 👩🏾‍💼 Analyst‑Friendly Aggregated Views  
**Models:**
- `customer_risk_profile`  
- `device_risk_profile`  
- `daily_fraud_summary`  

**Outputs:**
- customer‑level risk summaries  
- device‑level risk summaries  
- daily fraud counts  
- aggregated anomaly signals  

**Purpose:**
- case investigation  
- fraud operations workflows  
- manual review queues  
- analyst dashboards  

---

### 3.4 📊 Dashboard‑Ready Tables  
**Models:**
- `fraud_dashboard_transactions`  
- `fraud_dashboard_risk_signals`  
- `fraud_dashboard_trends`  

**Outputs:**
- daily/weekly fraud trends  
- aggregated transaction metrics  
- risk signal summaries  
- geo‑risk and velocity trends  

**Purpose:**
- executive dashboards  
- fraud monitoring  
- operational reporting  
- anomaly trend analysis  

---

## 4. 🧱 Materialization Strategy

All marts models are materialized as **tables** because:

- they are frequently queried  
- they serve dashboards and ML pipelines  
- they must be stable and performant  
- they simplify consumption for analysts  

This ensures reliability and speed.

---

## 5. 🔄 Data Flow Summary

```
Intermediate Layer
↓
transaction_features
velocity_features
geo_risk_features
device_risk_features
customer_behavior
↓
Marts Layer (schema: marts)
↓
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

```


---

## 6. ⭐ Why the Marts Layer Matters

The marts layer provides:

- **explainable fraud scoring**  
- **ML‑ready feature tables**  
- **analyst‑friendly summaries**  
- **dashboard‑optimized tables**  
- **consistent outputs across teams**  
- **clean interfaces for downstream systems**  

It is the layer where engineered features become actionable insights.

---

## 7. 🚀 Future Enhancements

- real‑time scoring tables  
- streaming ingestion for fraud detection  
- graph‑based fraud ring detection marts  
- device/IP reputation enrichment  
- ML prediction tables  
- automated feature store integration  

---

## 8. 🏁 Summary

The **Marts Layer** transforms engineered features into business‑ready datasets for fraud detection, machine learning, dashboards, and analyst workflows.  
It is:

- modular  
- scalable  
- explainable  
- consumption‑ready  
- aligned with modern fraud analytics architecture  

This layer completes the Fraud Analytics Warehouse and prepares the foundation for fraud scoring and ML modeling.