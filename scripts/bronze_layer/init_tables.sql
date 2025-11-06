-- CRM tables initialization
if OBJECT_ID('bronze.crm_customer_info', 'U') is not NULL
    DROP TABLE bronze.crm_customer_info
CREATE TABLE bronze.crm_customer_info (
    cst_id INTEGER
    , cst_key NVARCHAR(50)
    , cst_firstname NVARCHAR(50)
    , cst_lastname NVARCHAR(50)
    , cst_marital_status NVARCHAR(50)
    , cst_gndr NVARCHAR(50)
    , cst_create_date DATE
    );


if OBJECT_ID('bronze.crm_product_info', 'U') is not NULL
    DROP TABLE bronze.crm_product_info
CREATE TABLE bronze.crm_product_info (
    prd_id INTEGER
    , prd_key NVARCHAR(50)
    , prd_nm NVARCHAR(50)
    , prd_cost INTEGER
    , prd_line NVARCHAR(50)
    , prd_start_dt DATETIME
    , prd_end_dt DATETIME
    );


if OBJECT_ID('bronze.crm_sales_info', 'U') is not NULL
    DROP TABLE bronze.crm_sales_info
CREATE TABLE bronze.crm_sales_info (
    sls_ord_num NVARCHAR(50)
    , sls_prd_key NVARCHAR(50)
    , sls_cust_id INTEGER
    , sls_order_dt INTEGER
    , sls_ship_dt INTEGER
    , sls_due_dt INTEGER
    , sls_sales INTEGER
    , sls_quantity INTEGER
    , sls_price INTEGER
    );


-- ERP tables initialization
if OBJECT_ID('bronze.erp_customer', 'U') is not NULL
    DROP TABLE bronze.erp_customer
CREATE TABLE bronze.erp_customer (
    CID NVARCHAR(50)
    , BDATE DATE
    , GEN NVARCHAR(50)
    );


if OBJECT_ID('bronze.erp_location', 'U') is not NULL
    DROP TABLE bronze.erp_location
CREATE TABLE bronze.erp_location (
    CID NVARCHAR(50)
    , CNTRY NVARCHAR(50)
    );


if OBJECT_ID('bronze.erp_px_cat', 'U') is not NULL
    DROP TABLE bronze.erp_px_cat
CREATE TABLE bronze.erp_px_cat (
    ID NVARCHAR(50)
    , CAT NVARCHAR(50)
    , SUBCAT NVARCHAR(50)
    , MAINTENANCE VARCHAR(50)
    );

