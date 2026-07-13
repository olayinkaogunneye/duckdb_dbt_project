# Analyst Views Documentation

The analyst views provide simplified, aggregated, and interpretable datasets for fraud analysts.  
They hide complex feature logic and present clean summaries that support investigation, case management, and operational monitoring.

The views are materialized in the schema **`marts`**.

---

## 1. Customer Risk Profile

**Model:** `customer_risk_profile`

### Purpose
- Summarize customer‑level risk.  
- Provide fraud counts, average fraud scores, and behavioral/velocity/device signals.  
- Assign a risk tier (low, medium, high).

### Key Metrics
- total_transactions  
- fraud_count  
- avg_fraud_score  
- burst_events  
- impossible_travel_events  
- high_risk_location_events  
- distinct_devices  
- shared_device_events  

### Use Cases
- case investigation  
- customer monitoring  
- risk tiering  
- fraud operations dashboards  

---

## 2. Device Risk Profile

**Model:** `device_risk_profile`

### Purpose
- Summarize device‑level risk.  
- Identify shared devices, burst devices, and devices with fraud history.  
- Assign device risk tiers.

### Key Metrics
- avg_accounts_per_device  
- avg_ips_per_device  
- avg_devices_per_ip  
- shared_device_events  
- device_burst_events  
- high_risk_device_events  

### Use Cases
- fraud ring detection  
- compromised device identification  
- device/IP intelligence dashboards  

---

## 3. Daily Fraud Summary

**Model:** `daily_fraud_summary`

### Purpose
- Provide daily fraud trends.  
- Summarize fraud counts, average scores, and anomaly events.

### Key Metrics
- total_transactions  
- fraud_transactions  
- avg_fraud_score  
- burst_events  
- impossible_travel_events  
- shared_device_events  

### Use Cases
- daily monitoring  
- fraud operations reporting  
- executive dashboards  
- anomaly detection  

---

## Summary

Analyst views transform engineered features into clean, interpretable summaries that fraud analysts rely on for investigation, monitoring, and decision‑making.  
They are:

- aggregated  
- explainable  
- operationally useful  
- optimized for human consumption