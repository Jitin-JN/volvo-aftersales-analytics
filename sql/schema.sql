PRAGMA foreign_keys = ON;

-- Drop tables if rerun
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_region;
DROP TABLE IF EXISTS dim_dealer;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_machine_model;
DROP TABLE IF EXISTS dim_part;
DROP TABLE IF EXISTS dim_failure_code;
DROP TABLE IF EXISTS dim_warehouse;

DROP TABLE IF EXISTS fact_machine_sales;
DROP TABLE IF EXISTS fact_telematics_daily;
DROP TABLE IF EXISTS fact_service_job;
DROP TABLE IF EXISTS fact_parts_sales;

-- Dimensions
CREATE TABLE dim_date (
  date TEXT PRIMARY KEY,
  date_key INTEGER,
  year INTEGER,
  month INTEGER,
  month_name TEXT,
  quarter INTEGER,
  week INTEGER,
  day_name TEXT,
  is_weekend INTEGER
);

CREATE TABLE dim_region (
  region_id TEXT PRIMARY KEY,
  region_name TEXT,
  demand_multiplier REAL
);

CREATE TABLE dim_dealer (
  dealer_id TEXT PRIMARY KEY,
  dealer_name TEXT,
  region_id TEXT,
  tier TEXT
);

CREATE TABLE dim_customer (
  customer_id TEXT PRIMARY KEY,
  customer_name TEXT,
  customer_type TEXT,
  region_id TEXT,
  size_band TEXT
);

CREATE TABLE dim_machine_model (
  model_id TEXT PRIMARY KEY,
  model_name TEXT,
  category TEXT,
  base_price_inr INTEGER,
  expected_annual_hours INTEGER
);

CREATE TABLE dim_part (
  part_id TEXT PRIMARY KEY,
  part_name TEXT,
  part_category TEXT,
  model_id TEXT,
  unit_cost_inr REAL,
  unit_price_inr REAL,
  lead_time_days INTEGER,
  criticality TEXT
);

CREATE TABLE dim_failure_code (
  failure_code TEXT PRIMARY KEY,
  failure_name TEXT,
  failure_category TEXT,
  severity TEXT,
  typical_downtime_days INTEGER
);

CREATE TABLE dim_warehouse (
  warehouse_id TEXT PRIMARY KEY,
  warehouse_city TEXT,
  region_id TEXT
);

-- Facts
CREATE TABLE fact_machine_sales (
  sale_id TEXT PRIMARY KEY,
  machine_id TEXT UNIQUE,
  model_id TEXT,
  sale_date TEXT,
  dealer_id TEXT,
  customer_id TEXT,
  warranty_months INTEGER,
  sale_price_inr INTEGER
);

CREATE TABLE fact_telematics_daily (
  snapshot_date TEXT,
  machine_id TEXT,
  engine_hours REAL,
  idle_pct REAL,
  fuel_consumption_liters REAL,
  error_code_count INTEGER,
  health_score REAL
);

CREATE TABLE fact_service_job (
  service_job_id TEXT PRIMARY KEY,
  machine_id TEXT,
  service_date TEXT,
  dealer_id TEXT,
  model_id TEXT,
  job_type TEXT,
  failure_code TEXT,
  downtime_days INTEGER,
  labor_hours REAL,
  service_cost_labor_inr INTEGER,
  is_warranty INTEGER,
  resolution_status TEXT
);

CREATE TABLE fact_parts_sales (
  parts_line_id TEXT PRIMARY KEY,
  service_job_id TEXT,
  part_id TEXT,
  quantity INTEGER,
  sale_date TEXT,
  dealer_id TEXT,
  region_id TEXT,
  revenue_inr REAL,
  cost_inr REAL,
  is_emergency_order INTEGER
);

-- Helpful indexes (important for speed)
CREATE INDEX idx_telematics_machine_date ON fact_telematics_daily(machine_id, snapshot_date);
CREATE INDEX idx_service_machine_date ON fact_service_job(machine_id, service_date);
CREATE INDEX idx_parts_service_job ON fact_parts_sales(service_job_id);
CREATE INDEX idx_parts_part_date ON fact_parts_sales(part_id, sale_date);
CREATE INDEX idx_service_failure ON fact_service_job(failure_code);
