# Power BI Model

## Tables to load
- vw_service_enriched
- vw_parts_enriched
- fact_inventory_daily
- vw_feedback_enriched
- fact_telematics_daily
- dim_date (optional; Power BI can create its own date table)

## Relationship plan (Star Schema)
1) Date table:
- Date[Date] -> 1-many -> vw_service_enriched[service_date]
- Date[Date] -> 1-many -> vw_parts_enriched[sale_date]
- Date[Date] -> 1-many -> fact_inventory_daily[snapshot_date]
- Date[Date] -> 1-many -> vw_feedback_enriched[service_date]
- Date[Date] -> 1-many -> fact_telematics_daily[snapshot_date]

2) Service ↔ Parts:
- vw_service_enriched[service_job_id] -> 1-many -> vw_parts_enriched[service_job_id]

3) Service ↔ Feedback:
- vw_service_enriched[service_job_id] -> 1-many -> vw_feedback_enriched[service_job_id]

4) Inventory:
- dim_part[part_id] -> 1-many -> fact_inventory_daily[part_id]
- dim_warehouse[warehouse_id] -> 1-many -> fact_inventory_daily[warehouse_id]

5) Telematics:
- fact_telematics_daily[machine_id] many-1 -> fact_machine_sales[machine_id]
- fact_machine_sales[model_id] many-1 -> dim_machine_model[model_id]
- fact_machine_sales[dealer_id] many-1 -> dim_dealer[dealer_id]
- fact_machine_sales[customer_id] many-1 -> dim_customer[customer_id]

## Core Measures (DAX)
- Total Revenue = SUM(vw_parts_enriched[revenue_inr])
- Total Cost = SUM(vw_parts_enriched[cost_inr])
- Margin = [Total Revenue] - [Total Cost]
- Margin % = DIVIDE([Margin], [Total Revenue])

- Breakdown Jobs = CALCULATE(COUNTROWS(vw_service_enriched), vw_service_enriched[job_type] = "Breakdown")
- Total Service Jobs = COUNTROWS(vw_service_enriched)
- Breakdown Rate % = DIVIDE([Breakdown Jobs], [Total Service Jobs])

- Avg Downtime = AVERAGE(vw_service_enriched[downtime_days])
- Repeat Rate % = DIVIDE(
    CALCULATE(COUNTROWS(vw_service_enriched), vw_service_enriched[resolution_status] = "Repeat"),
    CALCULATE(COUNTROWS(vw_service_enriched), vw_service_enriched[job_type] = "Breakdown")
  )

- Stockout Rate = AVERAGE(fact_inventory_daily[stockout_flag])

- Avg CSAT = AVERAGE(vw_feedback_enriched[csat_score])
- Avg NPS = AVERAGE(vw_feedback_enriched[nps_score])
- Detractor Rate % = DIVIDE(
    CALCULATE(COUNTROWS(vw_feedback_enriched), vw_feedback_enriched[nps_group] = "Detractor"),
    COUNTROWS(vw_feedback_enriched)
  )

## Dashboard Pages
1) Executive Snapshot: Revenue, Margin %, Breakdown Rate, Avg Downtime, Avg CSAT, Avg NPS (with trends)
2) Inventory & Stockouts: stockout rate, emergency orders, stockout impact on CSAT, top impacted parts
3) Reliability & Telematics: health bands, errors vs health, breakdowns vs health, at-risk machines