-- CRM tables initialization
if OBJECT_ID('silver.crm_customer_info', 'U') is not NULL
    DROP TABLE silver.crm_customer_info
CREATE TABLE silver.crm_customer_info (
    cst_id INTEGER
    , cst_key NVARCHAR(50)
    , cst_firstname NVARCHAR(50)
    , cst_lastname NVARCHAR(50)
    , cst_marital_status NVARCHAR(50)
    , cst_gndr NVARCHAR(50)
    , cst_create_date DATE
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );


if OBJECT_ID('silver.crm_product_info', 'U') is not NULL
    DROP TABLE silver.crm_product_info
CREATE TABLE silver.crm_product_info (
    prd_id INTEGER
    , cat_id NVARCHAR(50)
    , prd_key NVARCHAR(50)
    , prd_nm NVARCHAR(50)
    , prd_cost INTEGER
    , prd_line NVARCHAR(50)
    , prd_start_dt DATE
    , prd_end_dt DATE
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );


if OBJECT_ID('silver.crm_sales_info', 'U') is not NULL
    DROP TABLE silver.crm_sales_info
CREATE TABLE silver.crm_sales_info (
    sls_ord_num NVARCHAR(50)
    , sls_prd_key NVARCHAR(50)
    , sls_cust_id INTEGER
    , sls_order_dt DATE
    , sls_ship_dt DATE
    , sls_due_dt DATE
    , sls_sales INTEGER
    , sls_quantity INTEGER
    , sls_price INTEGER
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );


-- ERP tables initialization
if OBJECT_ID('silver.erp_customer', 'U') is not NULL
    DROP TABLE silver.erp_customer
CREATE TABLE silver.erp_customer (
    CID NVARCHAR(50)
    , BDATE DATE
    , GEN NVARCHAR(50)
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );


if OBJECT_ID('silver.erp_location', 'U') is not NULL
    DROP TABLE silver.erp_location
CREATE TABLE silver.erp_location (
    CID NVARCHAR(50)
    , CNTRY NVARCHAR(50)
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );


if OBJECT_ID('silver.erp_px_cat', 'U') is not NULL
    DROP TABLE silver.erp_px_cat
CREATE TABLE silver.erp_px_cat (
    ID NVARCHAR(50)
    , CAT NVARCHAR(50)
    , SUBCAT NVARCHAR(50)
    , MAINTENANCE VARCHAR(50)
    , dwh_create_date DATETIME2 DEFAULT GETDATE()
    );
