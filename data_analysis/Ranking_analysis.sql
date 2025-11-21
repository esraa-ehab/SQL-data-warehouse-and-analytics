-- which 5 products generate the heighest revenue?
SELECT *
FROM (
    SELECT d.product_name
        , SUM(f.sales) AS revenue
        , Dense_rank() OVER (ORDER BY SUM(f.sales) DESC) AS revenue_rank
    FROM gold.sales_fact f
    JOIN gold.new_product_dim d
        ON f.product_key = d.product_key
    GROUP BY d.product_name
    ) t
WHERE revenue_rank <= 5
ORDER BY revenue_rank, revenue DESC;

-- which worst 5 performing products?
SELECT *
FROM (
    SELECT d.product_name
        , SUM(f.sales) AS revenue
        , Dense_rank() OVER (ORDER BY SUM(f.sales)) AS revenue_rank
    FROM gold.sales_fact f
    JOIN gold.new_product_dim d
        ON f.product_key = d.product_key
    GROUP BY d.product_name
    ) t
WHERE revenue_rank <= 5
ORDER BY revenue_rank, revenue;

-- which 5 subcategory generate the heighest revenue?
SELECT *
FROM (
    SELECT d.subcategory
        , SUM(f.sales) AS revenue
        , Dense_rank() OVER (ORDER BY SUM(f.sales) DESC) AS revenue_rank
    FROM gold.sales_fact f
    JOIN gold.new_product_dim d
        ON f.product_key = d.product_key
    GROUP BY d.subcategory
    ) t
WHERE revenue_rank <= 5
ORDER BY revenue_rank, revenue DESC;

-- which 10 customers generate the heighest revenue?
SELECT *
FROM (
    SELECT d.frist_name
        , d.last_name
        , SUM(f.sales) AS revenue
        , Dense_rank() OVER (ORDER BY SUM(f.sales) DESC) AS revenue_rank
    FROM gold.sales_fact f
    JOIN gold.customer_dim d
        ON f.customer_key = d.customer_key
    GROUP BY d.frist_name
        , d.last_name
    ) t
WHERE revenue_rank <= 10
ORDER BY revenue_rank, revenue DESC, frist_name ASC, last_name ASC;

-- which 3 customers are the most inactive?
SELECT *
FROM (
    SELECT d.frist_name
        , d.last_name
        , COUNT(distinct f.order_number) AS total_orders
        , Dense_rank() OVER (ORDER BY COUNT(distinct f.order_number)) AS order_rank
    FROM gold.sales_fact f
    JOIN gold.customer_dim d
        ON f.customer_key = d.customer_key
    GROUP BY d.frist_name
        , d.last_name
    ) t
WHERE order_rank <= 10
ORDER BY order_rank, total_orders, frist_name, last_name;