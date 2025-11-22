-- compare yearly performance of products to the average sales performance of the product
WITH yearly_product_performance AS (
SELECT YEAR(s.order_date) as order_year
    , p.product_name
    , SUM(s.sales) as total_sales
    , SUM(s.quantity) as total_sales_amount
FROM gold.sales_fact s
LEFT JOIN gold.new_product_dim p ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(s.order_date), p.product_name
)
SELECT order_year
    , product_name
    , total_sales
    , AVG(total_sales) OVER (PARTITION BY product_name) as average_sales
    , total_sales_amount
    , AVG(total_sales_amount) OVER (PARTITION BY product_name) as average_sales_amout
    -- yearly performance
    , CASE  WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 
                AND total_sales_amount - AVG(total_sales_amount) OVER (PARTITION BY product_name) < 0
                THEN 'Below Average' 
            WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 
                AND total_sales_amount - AVG(total_sales_amount) OVER (PARTITION BY product_name) > 0
                THEN 'Above Average'
            ElSE 'Average'
        END AS performance
    -- year over year performance
    , CASE  WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0
                THEN 'Sales Increased'
            WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0
                THEN 'Sales Decreased'
            ELSE 'No Change'
        END AS performance_change
FROM yearly_product_performance;


-- analyse sales seasonality 
WITH monthly_product_performance AS (
SELECT month(s.order_date) as order_month
    , p.product_name
    , SUM(s.sales) as total_sales
    , SUM(s.quantity) as total_sales_amount
FROM gold.sales_fact s
LEFT JOIN gold.new_product_dim p ON s.product_key = p.product_key
WHERE order_date IS NOT NULL
GROUP BY month(s.order_date), p.product_name
)
SELECT order_month
    , product_name
    , total_sales
    , AVG(total_sales) OVER (PARTITION BY product_name) as average_sales
    , total_sales_amount
    , AVG(total_sales_amount) OVER (PARTITION BY product_name) as average_sales_amout
    -- monthly performance
    , CASE  WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) < 0 
                AND total_sales_amount - AVG(total_sales_amount) OVER (PARTITION BY product_name) < 0
                THEN 'Below Average' 
            WHEN total_sales - AVG(total_sales) OVER (PARTITION BY product_name) > 0 
                AND total_sales_amount - AVG(total_sales_amount) OVER (PARTITION BY product_name) > 0
                THEN 'Above Average'
            ElSE 'Average'
        END AS performance
    -- month over month performance
    , CASE  WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_month) > 0
                THEN 'Sales Increased'
            WHEN total_sales - LAG(total_sales) OVER (PARTITION BY product_name ORDER BY order_month) < 0
                THEN 'Sales Decreased'
            ELSE 'No Change'
        END AS performance_change
FROM monthly_product_performance;