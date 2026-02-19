# Aftersales Performance & Parts Optimization Analytics

## 1. Business Context

This project simulates an end-to-end Aftersales Analytics system for a Construction Equipment company (Volvo CE-like environment). 

The objective is to analyze aftersales performance across:
- Parts sales
- Service operations
- Inventory management
- Telematics usage
- Customer satisfaction

The goal is to generate actionable insights that improve:
- Downtime reduction
- Inventory optimization
- Failure prediction
- Customer retention

This project is about cause and effect.

We are building this chain:

Telematics → Failures → Service Jobs → Parts Usage → Inventory Impact → Downtime → CSAT → NPS

---

## 2. Key Business Questions

1. Which parts drive the highest revenue and margin?
2. What are the top recurring failure patterns by machine model?
3. How do stockouts impact downtime and CSAT?
4. Can telematics data predict breakdown risk?
5. How can demand forecasting reduce inventory shortages?

---

## 3. Data Model Overview

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

## 4. Tools & Technologies

- Python (Pandas, NumPy)
- SQL
- Power BI
- Time Series Forecasting (ARIMA/Prophet)
- Logistic Regression (Failure Risk)

---

## 5. Dashboard Pages

1. Executive Overview
2. Parts Analytics
3. Service & Product Support
4. Digital Usage & Predictive Insights


