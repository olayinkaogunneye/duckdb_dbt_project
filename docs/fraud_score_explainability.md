# Fraud Score Explainability Documentation

The `fraud_score_explainability` model exposes a transparent breakdown of the rule‑based fraud score.  
It is a thin view over `fraud_scoring`, designed for analysts and dashboards.

## Purpose

- Show component scores per transaction.  
- Make it clear *why* a transaction is high‑risk.  
- Provide a simple dominant risk driver label.

## Inputs

- `fraud_scoring`

## Outputs

- velocity_risk_score  
- geo_risk_score  
- device_risk_score  
- behavior_risk_score  
- transaction_risk_score  
- fraud_score  
- fraud_flag  
- dominant_risk_driver  

This table is ideal for:

- analyst investigation screens  
- Power BI explainability visuals  
- comparing rule‑based scoring with future ML models.