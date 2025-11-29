:r ./pipeline_scripts/bronze_layer/init_tables.sql
GO
:r ./pipeline_scripts/bronze_layer/load_data_from_csv.sql
GO
EXEC bronze.load_bronze