-- total number of customers by country
SELECT country
    , count(customer_key) AS total_customers
FROM gold.customer_dim
GROUP BY country
ORDER BY total_customers DESC;

-- total number of customers by gender
SELECT gender
    , count(customer_key) AS total_customers
FROM gold.customer_dim
GROUP BY gender
ORDER BY total_customers DESC;

-- total number of customers by gender
SELECT marital_status
    , count(customer_key) AS total_customers
FROM gold.customer_dim
GROUP BY marital_status
ORDER BY total_customers DESC;

-- find total products by category 
SELECT category
    , COUNT(product_key) AS total_products
FROM gold.new_product_dim
GROUP BY category
ORDER BY total_products DESC;

-- find average cost by category 
SELECT category
    , AVG(product_cost) AS average_cost
FROM gold.new_product_dim
GROUP BY category
ORDER BY average_cost DESC;

-- total revenue for each category 
SELECT d.category,
    SUM(f.sales) as total_revenue
FROM gold.sales_fact f
LEFT JOIN gold.new_product_dim d ON f.product_key = d.product_key
GROUP BY d.category
ORDER BY total_revenue DESC;

-- total money spent by each customer
SELECT d.customer_key
    , d.frist_name
    , d.last_name
    , SUM(f.sales) AS total_revenue
FROM gold.sales_fact f
LEFT JOIN gold.customer_dim d ON f.customer_key = d.customer_key
GROUP BY d.customer_key
    , d.frist_name
    , d.last_name
ORDER BY total_revenue DESC;

-- distribution of sales across countries
SELECT d.country
    , SUM(f.quantity) AS total_sold_items
FROM gold.sales_fact f
JOIN gold.customer_dim d ON f.customer_key = d.customer_key
GROUP BY d.country
ORDER BY total_sold_items DESC
