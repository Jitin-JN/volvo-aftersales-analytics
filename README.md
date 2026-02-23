# Volvo Aftersales Analytics (Synthetic End-to-End Project)

## Business Context

This project simulates an end-to-end Aftersales Analytics system for a Construction Equipment company (Volvo CE-like environment). 

The objective is to analyze aftersales performance across:
- Parts sales
- Service operations
- Inventory management
- Telematics usage
- Customer satisfaction

This project is about cause and effect.

I am building this chain:

Telematics → Failures → Service Jobs → Parts Usage → Inventory Impact → Downtime → CSAT → NPS

---

## 📊 Key Features
- 547,500+ synthetic records
- 292,800 daily inventory snapshots
- 1,500 machines simulated
- Stockout risk modeling (2–3%)
- Machine health segmentation
- CSAT impact analysis
- Breakdown probability modeling


---

## Data Model Overview

The project uses a star schema structure with:

Dimension Tables:
- Region
- Dealer
- Customer
- Machine Model
- Part
- Failure Code
- Warehouse
- Date

Fact Tables:
- Machine Sales
- Service Jobs
- Parts Sales
- Inventory Snapshots
- Telematics Usage
- Customer Feedback

---

## 🧱 Tech Stack
- Python (Pandas, NumPy)
- SQL (SQLite)
- Power BI
- Data Modeling (Star Schema)
- DAX

---


## 📈 Dashboards
1. Executive Snapshot
2. Inventory Risk & Customer Impact
3. Machine Health Monitoring

---




