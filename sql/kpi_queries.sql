-- Aftersales revenue & margin (overall)
SELECT
  SUM(revenue_inr) AS total_revenue_inr,
  SUM(cost_inr) AS total_cost_inr,
  SUM(revenue_inr - cost_inr) AS total_margin_inr,
  ROUND(100.0 * SUM(revenue_inr - cost_inr) / NULLIF(SUM(revenue_inr),0), 2) AS margin_pct
FROM fact_parts_sales;

-- Revenue by region (after sales)
SELECT
  r.region_name,
  SUM(p.revenue_inr) AS revenue_inr,
  ROUND(100.0 * SUM(p.revenue_inr) / (SELECT SUM(revenue_inr) FROM fact_parts_sales), 2) AS revenue_share_pct
FROM fact_parts_sales p
JOIN dim_region r ON r.region_id = p.region_id
GROUP BY r.region_name
ORDER BY revenue_inr DESC;

-- Top 15 parts by revenue
SELECT
  p.part_id,
  dp.part_name,
  dp.part_category,
  SUM(p.quantity) AS qty,
  SUM(p.revenue_inr) AS revenue_inr,
  SUM(p.revenue_inr - p.cost_inr) AS margin_inr
FROM fact_parts_sales p
JOIN dim_part dp ON dp.part_id = p.part_id
GROUP BY p.part_id, dp.part_name, dp.part_category
ORDER BY revenue_inr DESC
LIMIT 15;

-- Downtime KPI (breakdowns only) by model
SELECT
  m.model_name,
  COUNT(*) AS breakdown_jobs,
  ROUND(AVG(s.downtime_days), 2) AS avg_downtime_days,
  SUM(s.downtime_days) AS total_downtime_days
FROM fact_service_job s
JOIN dim_machine_model m ON m.model_id = s.model_id
WHERE s.job_type = 'Breakdown'
GROUP BY m.model_name
ORDER BY avg_downtime_days DESC;

-- Repeat issue rate by failure category
SELECT
  f.failure_category,
  COUNT(*) AS breakdown_jobs,
  SUM(CASE WHEN s.resolution_status = 'Repeat' THEN 1 ELSE 0 END) AS repeat_jobs,
  ROUND(100.0 * SUM(CASE WHEN s.resolution_status = 'Repeat' THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate_pct
FROM fact_service_job s
JOIN dim_failure_code f ON f.failure_code = s.failure_code
WHERE s.job_type = 'Breakdown'
GROUP BY f.failure_category
ORDER BY repeat_rate_pct DESC;

-- Telematics health vs errors
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

-- Warranty vs non-warranty breakdown cost
SELECT
  is_warranty,
  COUNT(*) AS breakdown_jobs,
  ROUND(AVG(service_cost_labor_inr), 2) AS avg_labor_cost_inr,
  SUM(service_cost_labor_inr) AS total_labor_cost_inr
FROM fact_service_job
WHERE job_type = 'Breakdown'
GROUP BY is_warranty
ORDER BY is_warranty DESC;
