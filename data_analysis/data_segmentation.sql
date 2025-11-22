-- segment product into price ranges
WITH products_segments AS (
SELECT product_key
    , product_name
    , product_cost
    , CASE 
        WHEN product_cost < 100 THEN 'Below 100'
        WHEN product_cost BETWEEN 100 AND 500 THEN '100-500'
        WHEN product_cost BETWEEN 500 AND 1000 THEN '500-1000'
        ELSE 'Above 1000'
        END AS cost
FROM gold.new_product_dim)

SELECT cost
    , COUNT(product_key) No_of_products
FROM products_segments
GROUP BY cost
ORDER BY No_of_products;


-- segment customers into categories based on their spending range 
WITH customers_spendings
AS (
    SELECT c.customer_key
        , CONCAT (frist_name, ' ', last_name) AS 'name'
        , MIN(s.order_date) AS oldest_order_date
        , MAX(s.order_date) AS latest_order_date
        , SUM(sales) AS total_spendings
    FROM gold.sales_fact s
    LEFT JOIN gold.customer_dim c
        ON s.customer_key = c.customer_key
    GROUP BY c.customer_key, c.frist_name, c.last_name
), customers_spending_class AS (
        --spendings: max=15998  min=2 
        SELECT customer_key
            , name
            , oldest_order_date
            , latest_order_date
            , total_spendings
            , DATEDIFF(MONTH, oldest_order_date, latest_order_date) as lifespan
            , CASE 
                WHEN DATEDIFF(MONTH, oldest_order_date, latest_order_date) >= 12 AND total_spendings > 5000
                    THEN 'VIP'
                WHEN DATEDIFF(MONTH, oldest_order_date, latest_order_date) >= 12 AND total_spendings < 5000
                    THEN 'Regular'
                ELSE 'New'
                END AS customer_class
        FROM customers_spendings
)

SELECT customer_class, COUNT(customer_key) as total_customers, SUM(total_spendings) as total_spendings
FROM customers_spending_class
GROUP BY customer_class
ORDER BY total_customers DESC;
