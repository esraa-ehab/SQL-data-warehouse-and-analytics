------------------------------------------
-- Data Exploration before transformation
------------------------------------------

-- ===================
-- customer_info table
-- ===================
-- check for nulls or duplicates
SELECT cst_id
    , COUNT(*)
FROM bronze.crm_customer_info
GROUP BY cst_id
HAVING cst_id IS NULL
    OR COUNT(*) > 1;

-- check for extra spaces (normalization)
SELECT cst_key
FROM bronze.crm_customer_info
WHERE cst_key != TRIM(cst_key);

SELECT cst_firstname
FROM bronze.crm_customer_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_customer_info
WHERE cst_lastname != TRIM(cst_lastname);

-- data consistency 
SELECT cst_gndr
    , COUNT(*)
FROM bronze.crm_customer_info
GROUP BY cst_gndr;

SELECT cst_marital_status
    , COUNT(*)
FROM bronze.crm_customer_info
GROUP BY cst_marital_status;


-- ==================
-- product_info table
-- ==================
-- check for nulls or duplicates
SELECT prd_id
    , COUNT(*)
FROM bronze.crm_product_info
GROUP BY prd_id
HAVING prd_id IS NULL
    OR COUNT(*) > 1;

-- check null or negative cost
SELECT prd_cost
FROM bronze.crm_product_info
WHERE prd_cost < 0.
    OR prd_cost IS NULL;

-- check invalid order dates
SELECT *
FROM bronze.crm_product_info
WHERE prd_end_dt < prd_start_dt;


-- ===================
-- sales_info table
-- ===================
-- check invalid dates
SELECT nullif(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_info
WHERE sls_order_dt = 0
    OR len(sls_order_dt) != 8
    OR sls_order_dt > 20500101
    OR sls_order_dt < 19000101

-- check if there is order date after shipping date or due date
SELECT *
FROM bronze.crm_sales_info
WHERE sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt

-- check for invalid sales, price, or quantity
SELECT distinct
    sls_sales as old_sales
    , sls_price as old_price
    , sls_quantity
FROM bronze.crm_sales_info
WHERE sls_sales != sls_price * sls_quantity
    OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
    OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
ORDER BY sls_sales, sls_price, sls_quantity


------------------------------------------
-- Data Exploration after transformation
------------------------------------------

-- ===================
-- customer_info table
-- ===================
-- check for nulls or duplicates
-- target: no results
SELECT cst_id
    , COUNT(*)
FROM silver.crm_customer_info
GROUP BY cst_id
HAVING cst_id IS NULL
    OR COUNT(*) > 1

-- check for extra spaces (normalizarion)
-- target: no results
SELECT cst_key
FROM silver.crm_customer_info
WHERE cst_key != TRIM(cst_key);

SELECT cst_firstname
FROM silver.crm_customer_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_customer_info
WHERE cst_lastname != TRIM(cst_lastname);

-- data consistency 
-- target: consistent data
SELECT cst_gndr
    , COUNT(*)
FROM silver.crm_customer_info
GROUP BY cst_gndr;

SELECT DISTINCT cst_marital_status
    , COUNT(*)
FROM silver.crm_customer_info
GROUP BY cst_marital_status;


-- ==================
-- product_info table
-- ==================
-- check for nulls or duplicates
-- target: no results
SELECT prd_id
    , COUNT(*)
FROM silver.crm_product_info
GROUP BY prd_id
HAVING prd_id IS NULL
    OR COUNT(*) > 1;

-- check null or negative cost
-- target: no results
SELECT prd_cost
FROM silver.crm_product_info
WHERE prd_cost < 0.
    OR prd_cost IS NULL;

-- check invalid order dates
-- target: no results
SELECT *
FROM silver.crm_product_info
WHERE prd_end_dt < prd_start_dt;

-- ===================
-- sales_info table
-- ===================

-- check if there is order date after shipping date or due date
SELECT *
FROM silver.crm_sales_info
WHERE sls_order_dt > sls_ship_dt
    OR sls_order_dt > sls_due_dt

-- check for invalid sales, price, or quantity
SELECT distinct
    sls_sales as old_sales
    , sls_price as old_price
    , sls_quantity
FROM silver.crm_sales_info
WHERE sls_sales != sls_price * sls_quantity
    OR sls_sales <= 0 OR sls_price <= 0 OR sls_quantity <= 0
    OR sls_sales IS NULL OR sls_price IS NULL OR sls_quantity IS NULL
ORDER BY sls_sales, sls_price, sls_quantity
