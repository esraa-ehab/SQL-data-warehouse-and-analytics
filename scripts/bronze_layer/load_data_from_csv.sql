CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start DATETIME, @end DATETIME, @durationMs INT, @batch_start DATETIME;
    BEGIN TRY

        PRINT '=================================================='
        PRINT '   INTIATING BRONZE LAYER DATA LOADING PROCEDURE'
        PRINT '=================================================='

        SET @batch_start = SYSDATETIME();
        
        -- loading to CRM tables
        SET @start = SYSDATETIME();
        TRUNCATE TABLE bronze.crm_customer_info
        PRINT 'Loading data into crm_customer_info table'
        BULK INSERT bronze.crm_customer_info
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_crm/cust_info.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                );
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        PRINT '----------------------------------------------------'


        SET @start = SYSDATETIME()
        TRUNCATE TABLE bronze.crm_product_info
        PRINT 'Loading data into crm_product_info table'
        BULK INSERT bronze.crm_product_info
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_crm/prd_info.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                );
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        PRINT '----------------------------------------------------'


        SET @start = SYSDATETIME();
        TRUNCATE TABLE bronze.crm_sales_info
        PRINT 'Loading data into crm_sales_info table'
        BULK INSERT bronze.crm_sales_info
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_crm/sales_details.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                );      
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        PRINT '----------------------------------------------------'


        -- loading to ERP tables
        SET @start = SYSDATETIME();
        TRUNCATE TABLE bronze.erp_customer
        PRINT 'Loading data into erp_customer table'
        BULK INSERT bronze.erp_customer
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_erp/CUST_AZ12.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                );
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        PRINT '----------------------------------------------------'
        

        SET @start = SYSDATETIME();
        TRUNCATE TABLE bronze.erp_location
        PRINT 'Loading data into erp_location table'
        BULK INSERT bronze.erp_location
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_erp/LOC_A101.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                );
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        
        PRINT '----------------------------------------------------'

        SET @start = SYSDATETIME();
        TRUNCATE TABLE bronze.erp_px_cat
        PRINT 'Loading data into erp_px_cat table'
        BULK INSERT bronze.erp_px_cat
        FROM '/data/Data_Engineering/SQL-Data-Warehouse/datasets/source_erp/PX_CAT_G1V2.csv' WITH (
                FIRSTROW=2
                , FIELDTERMINATOR = ','
                , TABLOCK
                ); 
        SET @end = SYSDATETIME();
        SET @durationMs = DATEDIFF(MILLISECOND, @start, @end);
        PRINT '>> Load duration: ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
        PRINT '----------------------------------------------------'

        PRINT 'Bronze layer loading completed successfully';
        SET @durationMs = DATEDIFF(MILLISECOND, @batch_start, @end);
        PRINT 'Completed loading the entire layer in : ' + CAST(@durationMs AS NVARCHAR(50)) + ' ms';
    END TRY

    BEGIN CATCH
        PRINT '-----------------------------------------';
        PRINT 'Error happend while loading bronze layer';
        PRINT 'Check the error: ' + ERROR_MESSAGE();
        PRINT '-----------------------------------------';
    END CATCH
END;