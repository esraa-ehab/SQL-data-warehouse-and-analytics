
# SQL End to End Data Warehouse and Data Analytics (ETL pipeline, Data Modeling, Analytics Reports)

This project demonstrates how real-world business data can be shaped into reliable, repeatable analytics. It is a compact, working example of an end-to-end data pipeline.

<img src="docs/data_flow.png" width="700 height= 500"/> <br>
- *Figure: high-level data flow showing sources → bronze ingestion → silver transformations → gold views/analytics.*

What to expect here:
- A curated set of SQL scripts that take raw CSV extracts and turn them into business-ready datasets.
- Exploratory analyses that show how the data was interrogated to define metrics and model choices.
- Clear examples of common data-engineering concerns: handling messy input, deduplication, and producing stable analytic views.

Highlights
- Outcome-oriented: final `gold` views (dimensions and facts) are designed for analysts and product managers to answer questions like customer lifetime, product trends, and sales performance.
- Reproducible steps: a simple orchestrator (`pipeline_scripts/master_script.sql`) runs the core pipeline end-to-end.
- Analysis-first: folders `analysis_reports/` and `data_analysis/` contain the queries and notes that guided metric definitions.

Try the demo (quick)
- Open `pipeline_scripts/master_script.sql` to see the pipeline order. For a quick inspection, browse `gold_layer/` to view the final SQL that defines the analytic datasets.
- If you want to run the pipeline on your machine or a demo server, the easiest path is to run `pipeline_scripts/master_script.sql` using your SQL client - the scripts are implemented for a SQL Server-like environment.

What I’d like viewers to notice
- The thought process: review the EDA in `data_analysis/` to see how edge cases and key metrics were identified.
- The transformation decisions: look at `silver_layer/` to see how raw data is normalized and deduplicated.
- The consumer view: `gold_layer/` shows how the data is shaped to be immediately useful for reporting.


## Key Concepts

- **Bronze**: raw ingestion and staging. CSVs are loaded with permissive DDL to avoid failures from dirty input.
- **Silver**: cleansing, normalization, deduplication, and intermediate enrichment. Silver produces production-quality tables ready for analytics.
- **Gold**: business-facing views (dimensions and facts) designed for reporting and BI.

---

## Repository Structure (top-level)
- `pipeline_scripts/` : orchestrating scripts and SQL modules used to create the database, load data, run transformations, and create gold views.
  - `init_database.sql` : create the target database and base schemas used by the pipeline.
  - `master_script.sql` : top-level orchestrator that runs the bronze, silver and gold scripts in order.
  - `bronze_layer/` : DDL and ingestion logic for raw CSV loads (`init_tables.sql`, `load_data_from_csv.sql`).
  - `silver_layer/` : DDL and transformation orchestration (`init_tables.sql`, `run_all_transformations.sql`) and subfolders for CRM/ERP-specific transformations.
  - `gold_layer/` : scripts to create analytical views and final dimensions/facts (`create_gold_views.sql`, `customer_dimension.sql`, `sales_fact.sql`, `current_product_dimension.sql`, `old_product_dimension.sql`).
- `datasets/` : sample CSV files used by the pipeline. Contains `source_crm/` and `source_erp/` subfolders.
- `analysis_reports/` and `data_analysis/` : exploratory SQL and reports used during analysis and validation.
- `docs/` : diagrams and additional documentation (data flow and data model images).

---

## Transformations Summary

- Deduplication: CRM records are deduplicated using window functions (e.g., `ROW_NUMBER() OVER (PARTITION BY <id> ORDER BY <date> DESC)`) to keep the latest record.
- Product parsing and effective dating: product keys are parsed to extract category identifiers, and `LEAD()`/`LAG()` are used to compute effective start/end dates for versioned product records.
- Sales normalization: price, quantity and date fields are validated and corrected when inconsistent or out-of-range.
- ERP-specific cleanup: custom cleaning for ERP source files (prefix removal, consistent casing, nulling impossible dates).
- Gold views: dimensions (`customer_dim`, `product_dim`) and `sales_fact` are exposed as `SELECT`able views. Views intentionally use outer joins to preserve transaction rows even when enrichment is missing.

---

## Data Quality & Assumptions

- CSVs are expected in `datasets/` with header rows. The loader scripts may assume a specific file path — update paths in `load_data_from_csv.sql` for your environment.
- Scripts currently assume a SQL Server-compatible dialect (T-SQL): `BULK INSERT`, `TRY/CATCH`, `sqlcmd` style includes. Adjust for other RDBMS if needed.
- Bronze uses permissive column types to maximize ingestion success; silver performs type enforcement and validation.

---

## Pipeline Orchestration
- The full ETL pipeline is executed via `pipeline_scripts/master_script.sql`, which runs:
Database intialization → Bronze (raw ingestion) → Silver (cleaning & transformations) → Gold (analytics views)
in a fully reproducible sequence, without external scripting.

---

## Prerequisites

- A SQL Server instance (local or remote) compatible with the T-SQL features used here.
- `sqlcmd` (or a GUI client such as SSMS / Azure Data Studio) to execute the scripts.
