-- Aftersales Revenue + Margin (overall)
SELECT
  ROUND(SUM(revenue_inr), 2) AS total_revenue_inr,
  ROUND(SUM(cost_inr), 2) AS total_cost_inr,
  ROUND(SUM(revenue_inr - cost_inr), 2) AS total_margin_inr,
  ROUND(100.0 * SUM(revenue_inr - cost_inr) / NULLIF(SUM(revenue_inr), 0), 2) AS margin_pct,
  COUNT(*) AS parts_lines
FROM fact_parts_sales;

-- Revenue & Margin by Region
SELECT
  r.region_name,
  ROUND(SUM(p.revenue_inr), 2) AS revenue_inr,
  ROUND(SUM(p.revenue_inr - p.cost_inr), 2) AS margin_inr,
  ROUND(100.0 * SUM(p.revenue_inr - p.cost_inr) / NULLIF(SUM(p.revenue_inr),0), 2) AS margin_pct
FROM fact_parts_sales p
JOIN dim_region r ON r.region_id = p.region_id
GROUP BY r.region_name
ORDER BY revenue_inr DESC;

-- Monthly Revenue Trend
SELECT
  substr(sale_date, 1, 7) AS year_month,
  ROUND(SUM(revenue_inr), 2) AS revenue_inr,
  ROUND(SUM(revenue_inr - cost_inr), 2) AS margin_inr
FROM fact_parts_sales
GROUP BY substr(sale_date, 1, 7)
ORDER BY year_month;

-- Breakdown Rate (share of service jobs)
SELECT
  ROUND(100.0 * SUM(CASE WHEN job_type='Breakdown' THEN 1 ELSE 0 END) / COUNT(*), 2) AS breakdown_rate_pct,
  COUNT(*) AS total_service_jobs
FROM fact_service_job;

-- Downtime KPIs (overall + breakdown only)
SELECT
  ROUND(AVG(downtime_days), 2) AS avg_downtime_days_all,
  ROUND(AVG(CASE WHEN job_type='Breakdown' THEN downtime_days END), 2) AS avg_downtime_days_breakdown,
  SUM(downtime_days) AS total_downtime_days
FROM fact_service_job;

-- Repeat Rate by Failure Category
SELECT
  f.failure_category,
  COUNT(*) AS breakdown_jobs,
  SUM(CASE WHEN s.resolution_status='Repeat' THEN 1 ELSE 0 END) AS repeat_jobs,
  ROUND(100.0 * SUM(CASE WHEN s.resolution_status='Repeat' THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct,
  ROUND(AVG(s.downtime_days), 2) AS avg_downtime_days
FROM fact_service_job s
JOIN dim_failure_code f ON f.failure_code = s.failure_code
WHERE s.job_type='Breakdown'
GROUP BY f.failure_category
ORDER BY repeat_rate_pct DESC, breakdown_jobs DESC;

-- Top Models by Downtime
SELECT
  m.model_name,
  COUNT(*) AS breakdown_jobs,
  ROUND(AVG(s.downtime_days), 2) AS avg_downtime_days,
  SUM(s.downtime_days) AS total_downtime_days
FROM fact_service_job s
JOIN dim_machine_model m ON m.model_id = s.model_id
WHERE s.job_type='Breakdown'
GROUP BY m.model_name
ORDER BY total_downtime_days DESC
LIMIT 10;

-- Inventory Stockout Rate (overall + by warehouse)
SELECT ROUND(AVG(stockout_flag), 4) AS stockout_rate
FROM fact_inventory_daily;

SELECT
  warehouse_id,
  ROUND(AVG(stockout_flag), 4) AS stockout_rate
FROM fact_inventory_daily
GROUP BY warehouse_id
ORDER BY stockout_rate DESC;

-- Stockout impact on CSAT
SELECT
  is_stockout_impacted,
  COUNT(*) AS feedback_rows,
  ROUND(AVG(csat_score), 3) AS avg_csat,
  ROUND(AVG(nps_score), 3) AS avg_nps,
  ROUND(100.0 * SUM(CASE WHEN nps_group='Detractor' THEN 1 ELSE 0 END) / COUNT(*), 2) AS detractor_rate_pct
FROM fact_customer_feedback
GROUP BY is_stockout_impacted
ORDER BY is_stockout_impacted DESC;

-- Downtime bucket vs CSAT (service ops insight)
SELECT
  CASE
    WHEN downtime_days <= 1 THEN '0-1'
    WHEN downtime_days <= 3 THEN '2-3'
    WHEN downtime_days <= 7 THEN '4-7'
    ELSE '8+'
  END AS downtime_bucket,
  COUNT(*) AS feedback_rows,
  ROUND(AVG(csat_score), 3) AS avg_csat
FROM fact_customer_feedback
GROUP BY downtime_bucket
ORDER BY downtime_bucket;

-- Emergency Orders and Margin Impact
SELECT
  is_emergency_order,
  COUNT(*) AS parts_lines,
  ROUND(AVG(revenue_inr - cost_inr), 2) AS avg_line_margin_inr,
  ROUND(100.0 * SUM(revenue_inr - cost_inr) / NULLIF(SUM(revenue_inr),0), 2) AS margin_pct
FROM fact_parts_sales
GROUP BY is_emergency_order
ORDER BY is_emergency_order DESC;

-- Telematics health bands vs avg errors 
SELECT
  CASE
    WHEN health_score >= 85 THEN '85-100'
    WHEN health_score >= 70 THEN '70-84'
    WHEN health_score >= 55 THEN '55-69'
    WHEN health_score >= 40 THEN '40-54'
    ELSE '05-39'
  END AS health_band,
  COUNT(*) AS rows,
  ROUND(AVG(error_code_count), 2) AS avg_errors,
  ROUND(AVG(engine_hours), 2) AS avg_engine_hours
FROM fact_telematics_daily
GROUP BY health_band
ORDER BY health_band DESC;