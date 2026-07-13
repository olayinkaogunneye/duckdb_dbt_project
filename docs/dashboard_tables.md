# Dashboard Tables Documentation

The dashboard tables provide lightweight, aggregated datasets optimized for BI tools such as Power BI.  
They summarize fraud activity, risk signals, and trends in a format suitable for executive dashboards, monitoring systems, and operational reporting.

These tables are materialized in the schema **`marts`**.

---

## 1. Fraud Dashboard – Transactions

**Model:** `fraud_dashboard_transactions`

### Purpose
- Provide daily transaction and fraud metrics.  
- Support high‑level monitoring dashboards.  
- Enable drill‑downs into daily fraud activity.

### Key Metrics
- total_transactions  
- fraud_transactions  
- avg_fraud_score  
- avg_amount  
- max_amount  
- total_amount  
- distinct_customers  

---

## 2. Fraud Dashboard – Risk Signals

**Model:** `fraud_dashboard_risk_signals`

### Purpose
- Summarize daily anomaly counts across velocity, geo, device, and behavior.  
- Provide operational visibility into risk signals.  
- Help analysts identify spikes in suspicious activity.

### Key Metrics
- burst_events  
- sudden_velocity_events  
- impossible_travel_events  
- high_risk_location_events  
- shared_device_events  
- device_burst_events  
- high_risk_device_events  
- sudden_spend_change_events  
- unusual_frequency_events  

---

## 3. Fraud Dashboard – Trends

**Model:** `fraud_dashboard_trends`

### Purpose
- Provide weekly fraud trends.  
- Support executive reporting and long‑term monitoring.  
- Identify patterns in fraud activity over time.

### Key Metrics
- weekly total_transactions  
- weekly fraud_transactions  
- weekly avg_fraud_score  
- weekly_burst_events  
- weekly_impossible_travel_events  
- weekly_shared_device_events  

---

## Summary

Dashboard tables transform engineered features and fraud scoring outputs into fast, aggregated datasets optimized for BI consumption.  
They are:

- lightweight  
- aggregated  
- performant  
- explainable  
- ideal for Power BI dashboards