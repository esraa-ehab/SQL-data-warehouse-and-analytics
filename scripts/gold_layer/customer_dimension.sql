CREATE OR ALTER VIEW gold.customer_dim AS
SELECT 
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) as customer_key
    , ci.cst_id AS customer_id
    , ci.cst_key AS customer_number
    , ci.cst_firstname AS frist_name
    , ci.cst_lastname AS last_name
    , la.cntry as country
    , ci.cst_marital_status AS marital_status
    , CASE 
        WHEN ci.cst_gndr != 'Unknown' THEN ci.cst_gndr
        ELSE coalesce(ca.gen, 'Unknown')
    END AS gender
    , ca.bdate as birthdate
    , ci.cst_create_date as create_date
FROM silver.crm_customer_info as ci
LEFT JOIN silver.erp_customer as ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_location as la
ON ci.cst_key = la.cid;