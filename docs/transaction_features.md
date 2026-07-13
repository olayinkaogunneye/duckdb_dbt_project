# Transaction Features Documentation

The `transaction_features` model enriches each transaction with categorical and risk‑based attributes derived from the cleaned staging dataset.  
These features provide foundational risk signals that help identify suspicious merchant categories, risky transaction types, and unusual spending patterns.

This model is part of the **Intermediate Layer** and is materialized as a table in the schema **`main_intermediate`**.

---

## 1. Purpose of the Model

The purpose of the `transaction_features` model is to:

- categorize transaction amounts into meaningful buckets  
- assign risk scores to transaction types  
- assign risk scores to merchant categories  
- provide categorical features for downstream fraud scoring and ML models  
- enhance raw transactional attributes with business‑driven intelligence  

These features serve as the first layer of fraud risk enrichment.

---

## 2. Input Dependencies

The model depends on:

- `ref('stg_transactions_clean')`

This ensures:

- clean timestamps  
- standardized categories  
- correct data types  
- reliable input values  

---

## 3. Output Table

The model produces:

- `main_intermediate.transaction_features`

This table contains:

- all original transaction fields  
- engineered categorical features  
- risk scores  
- amount buckets  

---

## 4. Feature List and Definitions

### 4.1 `amount_bucket`
Categorizes transaction amounts into discrete buckets.

Example buckets:

- **low** — small transactions  
- **medium** — typical customer spending  
- **high** — large transactions  
- **very_high** — unusually large transactions  

**Business Meaning:**  
Large or unusual amounts often correlate with fraud attempts, especially in account takeover or mule activity.

---

### 4.2 `transaction_type_risk`
Assigns a risk score to each transaction type.

Example logic:

- **high risk:** international transfer, crypto purchase  
- **medium risk:** online payment, card‑not‑present  
- **low risk:** ATM withdrawal, POS purchase  

**Business Meaning:**  
Certain transaction types are more frequently associated with fraud patterns.

---

### 4.3 `merchant_category_risk`
Assigns a risk score to merchant categories.

Example logic:

- **high risk:** travel, luxury goods, electronics  
- **medium risk:** retail, restaurants  
- **low risk:** groceries, utilities  

**Business Meaning:**  
Fraudsters often target high‑value merchant categories to maximize gain.

---

## 5. SQL Logic Summary

The model applies:

- CASE statements for amount bucketing  
- CASE statements for transaction type risk scoring  
- CASE statements for merchant category risk scoring  
- joins to staging data  
- materialization as a table  

The logic is deterministic and fully transparent.

---

## 6. Business Rationale

### Amount Bucketing  
Helps detect:

- unusually large transactions  
- sudden spending spikes  
- mule account behavior  

### Transaction Type Risk  
Helps detect:

- risky transaction flows  
- account takeover patterns  
- card‑not‑present fraud  

### Merchant Category Risk  
Helps detect:

- high‑value fraud attempts  
- suspicious merchant targeting  
- abnormal customer behavior  

These features provide essential context for fraud scoring.

---

## 7. Assumptions

- Merchant categories are standardized in the staging layer.  
- Transaction types are normalized and consistent.  
- Amounts are positive and correctly typed.  
- Risk scoring logic is domain‑driven and may evolve over time.  

---

## 8. Limitations

- Risk scores are rule‑based and may not capture emerging fraud patterns.  
- Amount buckets may need tuning for different customer segments.  
- Merchant risk scoring depends on accurate category mapping.  

---

## 9. Future Enhancements

Potential improvements include:

- dynamic amount bucketing using quantiles  
- ML‑driven merchant risk scoring  
- customer‑specific risk scoring (personalized thresholds)  
- integration with external merchant risk databases  
- anomaly detection based on historical customer behavior  

---

## 10. Summary

The `transaction_features` model enriches raw transactional attributes with categorical and risk‑based intelligence.  
It provides:

- amount buckets  
- transaction type risk  
- merchant category risk  

These features form the foundation for velocity, geo‑risk, device‑risk, and behavioral models, and are essential for fraud scoring and machine‑learning pipelines.