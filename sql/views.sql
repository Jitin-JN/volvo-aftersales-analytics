DROP VIEW IF EXISTS vw_service_enriched;
CREATE VIEW vw_service_enriched AS
SELECT
  s.*,
  d.tier AS dealer_tier,
  d.region_id AS dealer_region_id,
  f.failure_category,
  f.severity,
  m.model_name
FROM fact_service_job s
LEFT JOIN dim_dealer d ON d.dealer_id = s.dealer_id
LEFT JOIN dim_failure_code f ON f.failure_code = s.failure_code
LEFT JOIN dim_machine_model m ON m.model_id = s.model_id;

DROP VIEW IF EXISTS vw_parts_enriched;
CREATE VIEW vw_parts_enriched AS
SELECT
  p.*,
  dp.part_name,
  dp.part_category,
  dp.criticality,
  dp.lead_time_days
FROM fact_parts_sales p
LEFT JOIN dim_part dp ON dp.part_id = p.part_id;

DROP VIEW IF EXISTS vw_feedback_enriched;
CREATE VIEW vw_feedback_enriched AS
SELECT
  fb.*,
  c.customer_type,
  c.size_band,
  c.region_id AS customer_region_id
FROM fact_customer_feedback fb
LEFT JOIN dim_customer c ON c.customer_id = fb.customer_id;