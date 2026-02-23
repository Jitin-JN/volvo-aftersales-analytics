# Volvo Aftersales Analytics (End-to-End Project)

## 🧠 My Thought Process Behind This Project

When I saw the Graduate Apprentice Trainee role for Aftersales Data Analyst at Volvo, I wanted to build something that is very close to real business problems in automotive industry.

Instead of doing a simple dashboard project, I decided to simulate a complete aftersales ecosystem.

I asked myself:
- How does aftersales revenue get affected?
- How do stockouts impact customer satisfaction?
- Can machine health data help reduce breakdown risk?
- How do different teams (parts, service, digital) use data differently?

So I designed this project from scratch with realistic business thinking. This project simulates an end-to-end Aftersales Analytics system for a Construction Equipment company (Volvo CE-like environment). 

The objective is to analyze aftersales performance across:
- Parts sales
- Service operations
- Inventory management
- Telematics usage
- Customer satisfaction

This project is about cause and effect.

I am building this chain: Telematics → Failures → Service Jobs → Parts Usage → Inventory Impact → Downtime → CSAT → NPS

---

## 📊 Key Features
 I Generated Synthetic Data using Python which includes:
 
- 1,500 machines
- 200 spare parts
- 4 warehouses
- Daily inventory snapshots (292,800 rows)
- Telematics health monitoring data
- Service job history
- Customer feedback (CSAT & NPS)

This helped me practice:
- Data modeling
- Realistic business assumptions
- Cross-table relationships


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

<img width="1237" height="706" alt="image" src="https://github.com/user-attachments/assets/d8b07324-be2e-4404-b84b-1ed99e066b03" />
<br>

<img width="1123" height="625" alt="image" src="https://github.com/user-attachments/assets/05db42f7-6b77-4f2c-8bd6-d60ea776f36e" />
<br>

<img width="1122" height="626" alt="image" src="https://github.com/user-attachments/assets/59537763-1846-4d52-9487-8f2e60a884e6" />

---

## What This Project Demonstrates

Through this project, I demonstrate that I can:

- Think in business terms, not just technical terms
- Design realistic data simulation
- Build operational KPIs
- Connect inventory risk with customer impact
- Translate machine health into actionable insight
- Build executive-level Power BI dashboards




---




