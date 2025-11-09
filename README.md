# SQL Data Warehouse - Project Documentation

## Overview

This repository contains a small SQL Data Warehouse project organized into Bronze, Silver and Gold layers. The scripts build the database, create schemas/tables, load CSV datasets into the bronze layer, apply transformations to produce silver tables, and create business-ready views in the gold layer.

This README explains repository structure, the purpose of each script, required prerequisites, and a step-by-step guide to run the full build locally or on a server.

---

## Overview diagram
<img src="docs/data_flow.png" width="700 height= 500"/> <br>
- *Figure: high-level data flow showing sources → bronze ingestion → silver transformations → gold views/analytics.*

## Layer responsibilities

- Bronze: raw ingestion & staging (CSV → permissive tables)
- Silver: cleansing, normalization, deduplication, and intermediate enrichment
- Gold: business-facing dimensions and fact view(s)
<img src="docs/data_layers.png" width="700 height= 500"/> <br>
*Figure: responsibilities and transformations performed at each layer.*

## Project layout (important files)

- `datasets/` - CSV inputs (CRM and ERP sample files).
- `scripts/init_database.sql` - create database and schemas (`bronze`, `silver`, `gold`).
- `scripts/bronze_layer/init_tables.sql` - bronze table DDL.
- `scripts/bronze_layer/load_data_from_csv.sql` - `bronze.load_bronze` procedure that bulk-loads CSVs (prints timings and uses TRY/CATCH).
- `scripts/silver_layer/init_tables.sql` - silver DDL (adds `dwh_create_date`).
- `scripts/silver_layer/run_all_transformations.sql` - orchestrates transformations in `crm_explore_transform/` and `erp_explore_transform/`.
- `scripts/gold_layer/create_gold_views.sql` - orchestrates creation of the analytical views.

## How diagrams map to code

- Data integration/enrichment (joins between CRM and ERP that produce the customer/product enrichments) - see: `docs/data_integration.png` and the silver/gold join logic.

  <img src="docs/data_integration.png" width="700 height= 500"/> <br>
  *Figure: how CRM and ERP records are matched and enriched in silver/gold.*

- Logical data model (entities and relationships) - shown in `docs/data_model.png`; this maps directly to the gold views (customer_dim, new_product_dim/old_product_dim, sales_fact).
  <img src="docs/data_model.png" width="700 height= 500"/> <br>
  *Figure: simplified ER view of customer, product and sales relationships (used by gold views).* 

---

## What I implemented - code level

1) Database & schema setup
	- `scripts/init_database.sql` creates the `DataWareHouse` DB and three schemas to separate stages.

2) Bronze (ingestion)
	- Bronze tables mirror raw CSVs and are intentionally permissive (NVARCHAR / INTEGER) to avoid failures when loading dirty data.
	- `bronze.load_bronze` (in `load_data_from_csv.sql`) uses `BULK INSERT` per file and prints load timings; it TRUNCATEs target tables to keep demo runs idempotent.

3) Silver (transformations)
	- Deduplication: CRM customers use ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) to keep the last record.
	- Product parsing: `prd_key` parsing (SUBSTRING/REPLACE) to extract `cat_id` and normalized `prd_key`.
	- Effective dating: LEAD(prd_start_dt) OVER (...) - 1 to compute `prd_end_dt` for product versioning.
	- Sales normalization: sanity checks for date fields, price, quantity, sales consistency (recalculate where inconsistent).

4) ERP-specific cleansing
	- Removes 'NAS' prefix, normalizes gender, nulls future birthdates in `customer_az_transform.sql`.

5) Gold (business views)
	- Gold defines views: `gold.customer_dim`, `gold.new_product_dim`, `gold.old_product_dim`, `gold.sales_fact`.
	- Views use LEFT JOINs so transactional rows are preserved even when enrichments are missing.
	- Synthetic surrogate keys are produced via ROW_NUMBER() for reporting/demos (replace with persisted surrogates for production).

## Data-quality & defensive choices

- Bronze is deliberately permissive to ensure ingestion completes.
- Silver includes defensive casts, length checks, and CASE mapping to standardize categories and genders.
- Silver adds `dwh_create_date` to capture ingestion/transformation time.
- Silver transformations recalc inconsistent numeric fields (sales/price) to enforce internal consistency.

## Assumptions

- CSVs are comma-separated with a header row (FIRSTROW=2 in BULK INSERT).
- Sales date fields follow YYYYMMDD-like format when present; invalid values are set to NULL.
- Product key format is consistent enough for SUBSTRING-based parsing.

## Short run notes

- `master_script.sql` includes the bronze load, silver transforms and gold view creation (via `:r` includes). Use `sqlcmd` or SSMS to execute these scripts. See earlier README history for example `sqlcmd` commands.
