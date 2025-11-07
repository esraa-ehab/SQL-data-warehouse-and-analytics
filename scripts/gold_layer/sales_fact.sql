CREATE OR ALTER VIEW gold.sales_fact AS
SELECT si.sls_ord_num AS order_number
    , cd.customer_key
    , npd.product_key
    , si.sls_order_dt AS order_date
    , si.sls_ship_dt AS shipping_date
    , si.sls_due_dt AS due_date
    , si.sls_sales AS sales
    , si.sls_quantity AS quantity
    , si.sls_price AS price
FROM silver.crm_sales_info AS si
LEFT JOIN gold.customer_dim AS cd
    ON si.sls_cust_id = cd.customer_id
LEFT JOIN gold.new_product_dim AS npd
    ON si.sls_prd_key = npd.product_number