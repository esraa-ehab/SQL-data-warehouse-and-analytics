-- CRM tables initialization
if OBJECT_ID('bronze.crm_customer_info', 'U') is not NULL
    DROP TABLE bronze.crm_customer_info
CREATE TABLE bronze.crm_customer_info (
    cst_id INTEGER
    , cst_key NVARCHAR
    , cst_firstname NVARCHAR
    , cst_lastname NVARCHAR
    , cst_marital_status NVARCHAR
    , cst_gndr NVARCHAR
    , cst_create_date DATE
    );
GO

if OBJECT_ID('bronze.crm_product_info', 'U') is not NULL
    DROP TABLE bronze.crm_product_info
CREATE TABLE bronze.crm_product_info (
    prd_id INTEGER
    , prd_key NVARCHAR
    , prd_nm NVARCHAR
    , prd_cost INTEGER
    , prd_line NVARCHAR
    , prd_start_dt DATETIME
    , prd_end_dt DATETIME
    );
GO

if OBJECT_ID('bronze.crm_sales_info', 'U') is not NULL
    DROP TABLE bronze.crm_sales_info
CREATE TABLE bronze.crm_sales_info (
    sls_ord_num NVARCHAR
    , sls_prd_key NVARCHAR
    , sls_cust_id INTEGER
    , sls_order_dt INTEGER
    , sls_ship_dt INTEGER
    , sls_due_dt INTEGER
    , sls_sales INTEGER
    , sls_quantity INTEGER
    , sls_price INTEGER
    );
GO

-- ERP tables initialization
if OBJECT_ID('bronze.erp_customer', 'U') is not NULL
    DROP TABLE bronze.erp_customer
CREATE TABLE bronze.erp_customer (
    CID NVARCHAR
    , BDATE DATE
    , GEN NVARCHAR
    );
GO

if OBJECT_ID('bronze.erp_location', 'U') is not NULL
    DROP TABLE bronze.erp_location
CREATE TABLE bronze.erp_location (
    CID NVARCHAR
    , CNTRY NVARCHAR
    );
GO

if OBJECT_ID('bronze.erp_px_cat', 'U') is not NULL
    DROP TABLE bronze.erp_px_cat
CREATE TABLE bronze.erp_px_cat (
    ID NVARCHAR
    , CAT NVARCHAR
    , SUBCAT NVARCHAR
    , MAINTENANCE VARCHAR
    );

