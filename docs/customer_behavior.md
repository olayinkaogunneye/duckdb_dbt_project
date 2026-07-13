# Customer Behavior Features Documentation

The `customer_behavior` model computes long‑term and short‑term behavioral patterns for each customer using RFM‑style metrics (Recency, Frequency, Monetary).  
Behavioral features are essential for detecting account takeover, sudden spending anomalies, synthetic identity fraud, and unusual activity patterns.

This model is part of the **Intermediate Layer** and is materialized as a table in the schema **`main_intermediate`**.

---

## 1. Purpose of the Model

The purpose of the `customer_behavior` model is to:

- measure how recently a customer transacted  
- quantify short‑term and long‑term transaction frequency  
- compute monetary patterns over time  
- detect sudden changes in spending behavior  
- identify abnormal activity compared to historical norms  
- provide customer‑level behavioral features for fraud scoring and ML models  

These features add deep behavioral intelligence to each transaction.

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

- `main_intermediate.customer_behavior`

This table contains:

- all original transaction fields  
- recency metrics  
- frequency metrics  
- monetary metrics  
- anomaly flags  
- behavioral risk signals  

---

## 4. Feature List and Definitions

### 4.1 `recency_seconds`
Time (in seconds) since the customer’s previous transaction.

**Business Meaning:**  
Long gaps followed by sudden activity often indicate account takeover or mule activation.

---

### 4.2 `txn_count_7d`
Number of transactions performed by the customer in the past **7 days**.

**Business Meaning:**  
Captures short‑term activity patterns and helps detect sudden bursts.

---

### 4.3 `txn_count_30d`
Number of transactions performed by the customer in the past **30 days**.

**Business Meaning:**  
Provides long‑term behavioral context for frequency analysis.

---

### 4.4 `avg_amount_30d`
Average transaction amount over the past **30 days**.

**Business Meaning:**  
Useful for detecting:

- sudden high‑value transactions  
- abnormal spending patterns  
- account takeover attempts  

---

### 4.5 `total_amount_30d`
Total transaction amount over the past **30 days**.

**Business Meaning:**  
Helps identify:

- high‑spending customers  
- mule accounts moving large volumes  
- sudden spikes in total spend  

---

### 4.6 `prev_amount`
Amount of the customer’s previous transaction.

**Business Meaning:**  
Used to detect sudden changes in spending behavior.

---

### 4.7 `sudden_spend_change`
Flags when the difference between current and previous transaction amounts exceeds **50%**.

**Business Meaning:**  
Strong indicator of:

- account takeover  
- unusual spending behavior  
- synthetic identity fraud  

---

### 4.8 `unusual_frequency_pattern`
Flags when:

- short‑term activity (7 days) is high  
- long‑term activity (30 days) is low  

**Business Meaning:**  
Detects sudden bursts of activity inconsistent with historical behavior.

---

## 5. SQL Logic Summary

The model uses:

- `LAG()` to compute previous timestamps and amounts  
- `EXTRACT(EPOCH)` for recency calculations  
- window functions with `RANGE BETWEEN INTERVAL` for rolling frequency and monetary metrics  
- CASE statements for anomaly detection  
- materialization as a table for performance  

The logic is deterministic, transparent, and reproducible.

---

## 6. Business Rationale

Behavioral features are essential because fraudsters often:

- activate dormant accounts  
- perform sudden bursts of activity  
- drastically change spending patterns  
- test accounts with small transactions before large fraud  
- behave differently from legitimate customers  

Behavioral signals help detect these patterns early.

---

## 7. Assumptions

- Timestamps are clean and correctly ordered (handled in staging).  
- Customers are uniquely identified by `sender_account`.  
- Time windows (7 days, 30 days) are appropriate for fraud detection.  
- Spend change threshold (50%) is domain‑driven and may evolve.  

---

## 8. Limitations

- Fixed time windows may not capture all customer behaviors.  
- Spend change thresholds may need tuning for different customer segments.  
- Behavioral features rely heavily on timestamp accuracy.  
- Does not consider device or geo behavior (handled in other models).  

---

## 9. Future Enhancements

Potential improvements include:

- dynamic recency/frequency thresholds based on customer history  
- ML‑driven behavioral anomaly detection  
- customer segmentation for personalized thresholds  
- integration with velocity and geo‑risk features  
- long‑term behavioral trend analysis  

---

## 10. Summary

The `customer_behavior` model computes long‑term and short‑term behavioral signals essential for detecting fraud.  
It provides:

- recency metrics  
- frequency metrics  
- monetary metrics  
- sudden spend change detection  
- abnormal frequency pattern detection  

These features are critical inputs for fraud scoring, machine learning, and real‑time monitoring systems.