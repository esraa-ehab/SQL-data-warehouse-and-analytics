-- explore tables and columns
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- explore countries
SELECT DISTINCT country
FROM gold.customer_dim;

-- oldest and youngest customer 
SELECT min(birthdate) AS oldest_birthday
    , DATEDIFF(year, min(birthdate), GETDATE()) as oldest_customer
    , max(birthdate) AS youngest_birthday
    , DATEDIFF(year, max(birthdate), GETDATE()) as youngest_customer
FROM gold.customer_dim;

-- show products by category and subcategory
SELECT DISTINCT category
    , subcategory
    , product_name
FROM gold.new_product_dim
ORDER BY 1, 2, 3;

-- find older and newest order date
SELECT MIN(order_date) AS first_order_sate
    , MAX(order_date) AS last_order_date
    , DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS sales_range_years
FROM gold.sales_fact;

-- generate a report that shows all key metrics
SELECT 'Total sales' AS measure_name, SUM(sales) AS measure_value
FROM gold.sales_fact

UNION ALL

SELECT 'Total quantity', SUM(quantity)
FROM gold.sales_fact

UNION ALL

SELECT 'Average sales', AVG(price)
FROM gold.sales_fact

UNION ALL

SELECT 'Total #. orders', COUNT(DISTINCT order_number)
FROM gold.sales_fact

UNION ALL

SELECT 'Total #. orders', COUNT(DISTINCT product_key)
FROM gold.new_product_dim

UNION ALL

SELECT 'Total #. customers', COUNT(DISTINCT customer_key)
FROM gold.sales_fact
