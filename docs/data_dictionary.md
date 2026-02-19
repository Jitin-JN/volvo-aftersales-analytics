# Data Dictionary

## Dimension Tables

### dim_region
- region_id
- region_name
- demand_multiplier

### dim_dealer
- dealer_id
- dealer_name
- region_id
- tier

### dim_customer
- customer_id
- customer_type
- region_id
- size_band

### dim_machine_model
- model_id
- model_name
- category
- base_price
- expected_annual_hours

### dim_part
- part_id
- part_name
- part_category
- model_id
- unit_cost
- unit_price
- lead_time_days
- criticality

### dim_failure_code
- failure_code
- failure_category
- severity
- typical_downtime_days

### dim_warehouse
- warehouse_id
- warehouse_city
- region_id

---

## Fact Tables

### fact_machine_sales
- sale_id
- machine_id
- model_id
- sale_date
- dealer_id
- customer_id
- sale_price
- warranty_months

### fact_service_job
- service_job_id
- machine_id
- service_date
- dealer_id
- failure_code
- job_type
- downtime_days
- labor_hours
- service_cost_labor
- is_warranty
- resolution_status

### fact_parts_sales
- parts_line_id
- service_job_id
- part_id
- quantity
- sale_date
- dealer_id
- region_id
- revenue
- cost
- is_emergency_order

### fact_inventory_daily
- snapshot_date
- warehouse_id
- part_id
- on_hand_qty
- reorder_point
- stockout_flag

### fact_telematics_daily
- snapshot_date
- machine_id
- engine_hours_week
- idle_pct
- fuel_consumption
- error_code_count
- health_score

### fact_customer_feedback
- feedback_id
- service_job_id
- customer_id
- feedback_date
- csat
- nps
- comment_category
