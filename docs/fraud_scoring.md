# Fraud Scoring Model Documentation

The `fraud_scoring` model combines all engineered features into a single, explainable fraud scoring table.  
It produces a **composite fraud_score (0–1)** and a **fraud_flag** based on rule‑driven weights across velocity, geo‑risk, device risk, customer behavior, and transaction risk.

---

## 1. Purpose

- Aggregate all intermediate features into one scoring dataset.  
- Provide an interpretable, rule‑based fraud score.  
- Offer a baseline scoring layer before ML models.  
- Enable analysts to see *why* a transaction is risky via component scores.

---

## 2. Inputs

- `transaction_features`  
- `velocity_features`  
- `geo_risk_features`  
- `device_risk_features`  
- `customer_behavior`

Joined on `transaction_id`.

---

## 3. Outputs

Key fields:

- `fraud_score` — composite score (0–1).  
- `fraud_flag` — boolean flag (score ≥ 0.7).  
- `velocity_risk_score`  
- `geo_risk_score`  
- `device_risk_score`  
- `behavior_risk_score`  
- `transaction_risk_score`  

Plus all original transaction and feature fields.

---

## 4. Scoring Logic (High Level)

- **Velocity:** bursts, spikes → `velocity_risk_score`  
- **Geo:** impossible travel, big jumps, risky cities → `geo_risk_score`  
- **Device/IP:** shared devices, shared IPs, bursts, fraud history → `device_risk_score`  
- **Behavior:** sudden spend change, unusual frequency, dormant‑then‑active → `behavior_risk_score`  
- **Transaction:** very high amounts, high‑risk types, high‑risk merchants → `transaction_risk_score`  

Final score:



\[
fraud\_score =
0.25 \cdot velocity +
0.20 \cdot geo +
0.25 \cdot device +
0.20 \cdot behavior +
0.10 \cdot transaction
\]



Threshold:

- `fraud_flag = TRUE` if `fraud_score ≥ 0.7`.

---

## 5. Use Cases

- Real‑time rule‑based fraud screening.  
- Baseline model before ML deployment.  
- Analyst review queues (sort by `fraud_score`).  
- Feature importance exploration for future ML models.

---

## 6. Next Step

Once this is stable, the natural next move is:

- build `ml_feature_table.sql` using this same feature set  
- then train an ML model and replace/augment `fraud_score` with model predictions.