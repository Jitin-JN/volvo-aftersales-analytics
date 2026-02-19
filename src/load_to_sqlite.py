import os
import sqlite3
import pandas as pd

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
RAW_DIR = os.path.join(PROJECT_ROOT, "data", "raw")
PROCESSED_DIR = os.path.join(PROJECT_ROOT, "data", "processed")
SQL_DIR = os.path.join(PROJECT_ROOT, "sql")

os.makedirs(PROCESSED_DIR, exist_ok=True)

DB_PATH = os.path.join(PROCESSED_DIR, "aftersales.db")
SCHEMA_PATH = os.path.join(SQL_DIR, "schema.sql")

TABLES = [
    ("dim_date", "dim_date.csv", ["date"]),
    ("dim_region", "dim_region.csv", []),
    ("dim_dealer", "dim_dealer.csv", []),
    ("dim_customer", "dim_customer.csv", []),
    ("dim_machine_model", "dim_machine_model.csv", []),
    ("dim_part", "dim_part.csv", []),
    ("dim_failure_code", "dim_failure_code.csv", []),
    ("dim_warehouse", "dim_warehouse.csv", []),
    ("fact_machine_sales", "fact_machine_sales.csv", ["sale_date"]),
    ("fact_telematics_daily", "fact_telematics_daily.csv", ["snapshot_date"]),
    ("fact_service_job", "fact_service_job.csv", ["service_date"]),
    ("fact_parts_sales", "fact_parts_sales.csv", ["sale_date"]),
]

def main():
    # Connect
    conn = sqlite3.connect(DB_PATH)
    conn.execute("PRAGMA foreign_keys = ON;")

    # Run schema
    with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
        conn.executescript(f.read())

    # Load CSVs
    for table_name, csv_name, parse_dates in TABLES:
        path = os.path.join(RAW_DIR, csv_name)
        if not os.path.exists(path):
            raise FileNotFoundError(f"Missing {path}")

        df = pd.read_csv(path, parse_dates=parse_dates if parse_dates else None)

        # Convert datetime columns to ISO text for SQLite
        for c in parse_dates:
            if c in df.columns:
                df[c] = pd.to_datetime(df[c]).dt.strftime("%Y-%m-%d")

        df.to_sql(table_name, conn, if_exists="append", index=False)
        print(f"Loaded {table_name}: {len(df):,} rows")

    conn.commit()
    conn.close()
    print(f"\n✅ SQLite DB created at: {DB_PATH}")

if __name__ == "__main__":
    main()
