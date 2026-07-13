# Device Risk Features Documentation

The `device_risk_features` model computes device‑level and IP‑level behavioral signals that help detect fraud rings, compromised devices, bot activity, and anonymization attempts.  
Device intelligence is one of the strongest fraud indicators because fraudsters often reuse devices, rotate IPs, or share infrastructure across multiple accounts.

This model is part of the **Intermediate Layer** and is materialized as a table in the schema **`main_intermediate`**.

---

## 1. Purpose of the Model

The purpose of the `device_risk_features` model is to:

- identify devices shared across multiple accounts  
- detect IP addresses shared across multiple devices  
- measure device‑level transaction velocity  
- detect device‑level burst activity  
- flag devices previously involved in fraud  
- provide device/IP intelligence for fraud scoring and ML models  

These features reveal hidden relationships between accounts and devices that raw transaction data cannot capture.

---

## 2. Input Dependencies

The model depends on:

- `ref('stg_transactions_clean')`

This ensures:

- clean device hashes  
- standardized IP addresses  
- correct timestamps  
- reliable customer identifiers  

---

## 3. Output Table

The model produces:

- `main_intermediate.device_risk_features`

This table contains:

- all original transaction fields  
- device‑level metrics  
- IP‑level metrics  
- burst detection  
- shared device/IP flags  
- device fraud history flags  

---

## 4. Feature List and Definitions

### 4.1 `accounts_per_device`
Number of distinct customer accounts using the same device.

**Business Meaning:**  
High values indicate:

- mule networks  
- fraud rings  
- shared compromised devices  

---

### 4.2 `ips_per_device`
Number of distinct IP addresses used by the same device.

**Business Meaning:**  
High values indicate:

- VPN hopping  
- anonymization attempts  
- bot networks  

---

### 4.3 `devices_per_ip`
Number of distinct devices sharing the same IP address.

**Business Meaning:**  
High values indicate:

- public WiFi fraud  
- bot farms  
- coordinated fraud rings  

---

### 4.4 `device_txn_count_1h`
Number of transactions performed by the device in the past **1 hour**.

**Business Meaning:**  
Detects device‑level burst activity, often associated with:

- bots  
- automated scripts  
- high‑speed fraud attempts  

---

### 4.5 `shared_device_flag`
Flags when a device is used by **more than 3 accounts**.

**Business Meaning:**  
Strong indicator of:

- mule accounts  
- fraud rings  
- compromised devices  

---

### 4.6 `device_ip_risk_flag`
Flags when a device uses **more than 5 IP addresses**.

**Business Meaning:**  
Indicates:

- VPN rotation  
- IP spoofing  
- anonymization tools  

---

### 4.7 `shared_ip_flag`
Flags when an IP address is shared by **more than 5 devices**.

**Business Meaning:**  
Indicates:

- bot farms  
- shared fraud infrastructure  
- public WiFi abuse  

---

### 4.8 `device_burst_flag`
Flags when a device performs **≥10 transactions in 1 hour**.

**Business Meaning:**  
Classic indicator of:

- bot activity  
- automated fraud scripts  
- rapid account takeover attempts  

---

### 4.9 `high_risk_device_flag`
Flags devices previously involved in fraud.

**Business Meaning:**  
Devices with fraud history are highly likely to be reused for future fraud attempts.

---

## 5. SQL Logic Summary

The model uses:

- `COUNT(DISTINCT ...)` for device/IP aggregation  
- window functions for device‑level velocity  
- CASE statements for anomaly detection  
- subqueries to detect devices with fraud history  
- materialization as a table for performance  

The logic is deterministic, transparent, and reproducible.

---

## 6. Business Rationale

Device‑level intelligence is essential because fraudsters often:

- reuse the same device across multiple accounts  
- rotate IPs to avoid detection  
- use shared infrastructure (bot farms, public WiFi)  
- automate transactions using scripts  
- repeatedly use devices previously involved in fraud  

Device risk features help detect these behaviors early.

---

## 7. Assumptions

- Device hashes are stable and consistent across transactions.  
- IP addresses are correctly standardized in the staging layer.  
- Thresholds (3 accounts, 5 IPs, 10 transactions/hour) are domain‑driven.  
- Fraud history is determined by `is_fraud = TRUE` in staging data.  

---

## 8. Limitations

- Device hashes may not capture true device identity if hashing logic changes.  
- IP rotation may be legitimate for some customers (e.g., travelers).  
- Shared IPs may occur in corporate networks or public WiFi.  
- Thresholds may need tuning for different customer segments.  

---

## 9. Future Enhancements

Potential improvements include:

- device fingerprinting using browser metadata  
- IP reputation scoring (external threat intelligence)  
- ML‑driven device anomaly detection  
- graph‑based device‑account relationship analysis  
- integration with geo‑risk and velocity features for multi‑signal detection  

---

## 10. Summary

The `device_risk_features` model computes device‑level and IP‑level risk signals essential for detecting fraud rings, compromised devices, and automated fraud.  
It provides:

- shared device/IP detection  
- device‑level velocity  
- burst activity flags  
- fraud history flags  
- device/IP risk scoring  

These features are critical inputs for fraud scoring, machine learning, and real‑time monitoring systems.