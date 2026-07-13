# Geo‑Risk Features Documentation

The `geo_risk_features` model computes geographic movement, location‑based anomalies, and travel‑related risk signals for each transaction.  
Geo‑risk features are essential for detecting account takeover, cross‑border fraud, mule activity, and suspicious geographic jumps.

This model is part of the **Intermediate Layer** and is materialized as a table in the schema **`main_intermediate`**.

---

## 1. Purpose of the Model

The purpose of the `geo_risk_features` model is to:

- map transaction locations to latitude/longitude  
- compute distance between consecutive transactions  
- calculate geographic velocity (km/h)  
- detect impossible travel  
- flag high‑risk locations  
- identify sudden geographic jumps  
- provide geo‑spatial features for fraud scoring and ML models  

Geo‑risk features add a spatial dimension to fraud detection that raw transaction data cannot capture.

---

## 2. Input Dependencies

The model depends on:

- `ref('stg_transactions_clean')`

This ensures:

- clean and standardized location names  
- correct timestamps  
- reliable customer identifiers  
- consistent transaction ordering  

---

## 3. Output Table

The model produces:

- `main_intermediate.geo_risk_features`

This table contains:

- all original transaction fields  
- latitude/longitude coordinates  
- distance calculations  
- geographic velocity  
- anomaly flags  
- location‑based risk signals  

---

## 4. Feature List and Definitions

### 4.1 `curr_lat`, `curr_lon`
Latitude and longitude of the current transaction location.

**Business Meaning:**  
Provides spatial coordinates for distance and velocity calculations.

---

### 4.2 `prev_lat`, `prev_lon`
Latitude and longitude of the previous transaction location for the same customer.

**Business Meaning:**  
Allows comparison between consecutive transaction locations.

---

### 4.3 `distance_km`
Distance (in kilometers) between the current and previous transaction locations, computed using the Haversine formula.

**Business Meaning:**  
Detects large geographic jumps that may indicate account takeover or mule activity.

---

### 4.4 `time_diff_seconds`
Time difference (in seconds) between consecutive transactions.

**Business Meaning:**  
Used to compute geographic velocity and detect impossible travel.

---

### 4.5 `geo_velocity_kmh`
Geographic speed (km/h) between consecutive transactions.

Formula:

distance_km / (time_diff_seconds / 3600)


**Business Meaning:**  
Detects impossible travel or suspiciously fast movement across regions.

---

### 4.6 `location_change_flag`
Flags when the customer moves more than **500 km** between consecutive transactions.

**Business Meaning:**  
Large jumps often indicate:

- mule activity  
- cross‑border fraud  
- account takeover  

---

### 4.7 `impossible_travel_flag`
Flags when geographic velocity exceeds **900 km/h** (commercial jet speed).

**Business Meaning:**  
Impossible travel is a strong indicator of:

- compromised accounts  
- bot activity  
- synthetic identity fraud  

---

### 4.8 `high_risk_location_flag`
Flags transactions occurring in known high‑risk regions (e.g., Lagos, Dubai).

**Business Meaning:**  
Certain cities have higher fraud prevalence due to:

- weak regulatory environments  
- high cybercrime activity  
- known fraud rings  

---

## 5. SQL Logic Summary

The model uses:

- a synthetic city‑to‑coordinates lookup table  
- `LAG()` to retrieve previous location and timestamp  
- Haversine formula for distance calculation  
- CASE statements for anomaly detection  
- materialization as a table for performance  

The logic is deterministic, transparent, and reproducible.

---

## 6. Business Rationale

Geo‑risk features are essential because fraudsters often:

- perform transactions from distant locations within minutes  
- use VPNs or proxies to simulate geographic movement  
- operate mule networks across multiple cities  
- compromise accounts and transact from unexpected regions  

Geo‑risk signals help detect these behaviors early.

---

## 7. Assumptions

- Location names are standardized in the staging layer.  
- Coordinates are mapped using a predefined lookup table.  
- Thresholds (500 km, 900 km/h) are domain‑driven and may evolve.  
- Time differences are correctly computed from clean timestamps.  

---

## 8. Limitations

- Synthetic coordinate lookup may not cover all cities.  
- VPN usage can mask true geographic movement.  
- Thresholds may need tuning for different customer segments.  
- Geo‑velocity does not consider multi‑leg travel (e.g., flights).  

---

## 9. Future Enhancements

Potential improvements include:

- integration with real geolocation APIs  
- dynamic thresholds based on customer history  
- IP‑to‑location enrichment  
- geo‑velocity fusion with device/IP signals  
- anomaly detection using ML models  

---

## 10. Summary

The `geo_risk_features` model computes geographic movement and location‑based risk signals essential for detecting fraud.  
It provides:

- distance calculations  
- geographic velocity  
- impossible travel detection  
- high‑risk location flags  
- geographic anomaly detection  

These features are critical inputs for fraud scoring, machine learning, and real‑time monitoring systems.