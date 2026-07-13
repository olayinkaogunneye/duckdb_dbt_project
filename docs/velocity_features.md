# Velocity Features Documentation

The `velocity_features` model computes short‑term and long‑term transaction velocity patterns for each customer.  
Velocity signals are among the strongest indicators of fraud, especially for detecting bots, mule accounts, account takeover, and burst activity.

This model is part of the **Intermediate Layer** and is materialized as a table in the schema **`main_intermediate`**.

---

## 1. Purpose of the Model

The purpose of the `velocity_features` model is to:

- measure how frequently a customer transacts  
- detect sudden spikes in activity  
- identify burst behavior  
- compute time differences between consecutive transactions  
- provide temporal features for fraud scoring and machine learning  

Velocity features help reveal abnormal activity patterns that raw transaction data cannot capture.

---

## 2. Input Dependencies

The model depends on:

- `ref('stg_transactions_clean')`

This ensures:

- clean timestamps  
- correct chronological ordering  
- standardized customer identifiers  
- reliable transaction amounts  

---

## 3. Output Table

The model produces:

- `main_intermediate.velocity_features`

This table contains:

- all original transaction fields  
- engineered velocity features  
- anomaly flags  
- temporal risk signals  

---

## 4. Feature List and Definitions

### 4.1 `true_time_since_last_txn`
Corrected time difference (in seconds) between consecutive transactions for the same customer.

**Business Meaning:**  
Detects rapid‑fire activity, bots, or account takeover.

---

### 4.2 `txn_count_1h`
Number of transactions performed by the customer in the past **1 hour**.

**Business Meaning:**  
High values indicate burst activity or automated scripts.

---

### 4.3 `txn_count_24h`
Number of transactions performed by the customer in the past **24 hours**.

**Business Meaning:**  
Useful for detecting mule accounts or repeated small‑value fraud.

---

### 4.4 `avg_amount_1h`
Average transaction amount in the past **1 hour**.

**Business Meaning:**  
Helps detect:

- repeated small test transactions  
- sudden high‑value bursts  
- abnormal short‑term spending patterns  

---

### 4.5 `burst_flag`
Flags when the customer performs **≥5 transactions in 1 hour**.

**Business Meaning:**  
Classic indicator of:

- bot activity  
- account takeover  
- mule account bursts  

---

### 4.6 `prev_txn_count_1h`
Transaction count in the previous hour window.

**Business Meaning:**  
Provides context for detecting sudden changes in velocity.

---

### 4.7 `sudden_velocity_change`
Flags when the difference between current and previous 1‑hour transaction counts is **≥3**.

**Business Meaning:**  
Detects sudden spikes in activity, often associated with:

- compromised accounts  
- bot activation  
- synthetic identity fraud  

---

## 5. SQL Logic Summary

The model uses:

- `LAG()` to compute previous timestamps  
- `EXTRACT(EPOCH)` to compute time differences  
- window functions with `RANGE BETWEEN INTERVAL` for rolling counts and averages  
- CASE statements for anomaly detection  
- materialization as a table for performance  

The logic is deterministic, transparent, and reproducible.

---

## 6. Business Rationale

Velocity features are essential because fraudsters often:

- perform many transactions quickly  
- test accounts with small amounts  
- execute bursts of activity before detection  
- automate transactions using scripts or bots  
- rapidly drain compromised accounts  

Velocity signals help detect these behaviors early.

---

## 7. Assumptions

- Timestamps are clean and correctly ordered (handled in staging).  
- Customers are uniquely identified by `sender_account`.  
- Time windows (1 hour, 24 hours) are appropriate for fraud detection.  
- Burst thresholds (≥5 transactions) are domain‑driven and may evolve.  

---

## 8. Limitations

- Fixed time windows may not capture all fraud patterns.  
- Burst thresholds may need tuning for different customer segments.  
- Velocity features rely heavily on timestamp accuracy.  
- Does not consider cross‑device or cross‑location velocity (handled in other models).  

---

## 9. Future Enhancements

Potential improvements include:

- dynamic velocity thresholds based on customer history  
- ML‑driven anomaly detection for velocity spikes  
- device‑level velocity integration  
- geo‑velocity fusion (distance + time)  
- customer‑specific velocity baselines  

---

## 10. Summary

The `velocity_features` model computes short‑term and long‑term transaction velocity signals essential for detecting fraud.  
It provides:

- time differences  
- rolling counts  
- rolling averages  
- burst detection  
- sudden velocity change flags  

These features are critical inputs for fraud scoring, machine learning, and real‑time monitoring systems.