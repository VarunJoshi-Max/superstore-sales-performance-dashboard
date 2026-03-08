/*
Project: Superstore Sales Performance Analysis
Task: Data Analytics & Business Intelligence – Task 3
Author: Varun Arun Joshi
Intern ID: MT2603

Purpose:
This SQL script performs advanced data analysis on the Superstore dataset.
It includes business queries to analyze sales trends, regional performance,
product profitability, customer segments, and growth metrics.

Key Concepts Used:
- Aggregation (SUM, AVG)
- CASE statements
- Subqueries
- Window functions
- Business performance analysis

Tools Used:
PostgreSQL, Excel, Power BI
*/


-- Monthly Sales & Profit Trend --

SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY month
ORDER BY month;


-- Sales Performance by Region --

SELECT 
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_sales DESC;


-- Profit by Product Category --

SELECT 
    product_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit
FROM orders
GROUP BY product_category
ORDER BY total_profit DESC;


--Order Value Classification--

SELECT 
    order_id,
    sales,
    CASE
        WHEN sales > 1000 THEN 'High Value'
        WHEN sales BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_category
FROM orders;


--Identify Underperforming Regions--

SELECT
    region,
    SUM(profit) AS total_profit
FROM orders
GROUP BY region
ORDER BY total_profit;



--Monthly Growth Rate--

SELECT
    t1.month,
    t1.monthly_sales,
    ((t1.monthly_sales - t2.monthly_sales) / t2.monthly_sales) * 100 AS growth_percentage
FROM
(
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY month
) t1
LEFT JOIN
(
    SELECT
        DATE_TRUNC('month', order_date) AS month,
        SUM(sales) AS monthly_sales
    FROM orders
    GROUP BY month
) t2
ON t1.month = t2.month + INTERVAL '1 month'
ORDER BY t1.month;



--Top Customers--

SELECT
    customer_name,
    SUM(sales) AS total_revenue
FROM orders
GROUP BY customer_name
ORDER BY total_revenue DESC
LIMIT 10;


-- Segment Contribution --

SELECT
    customer_segment,
    SUM(sales) AS total_sales
FROM orders
GROUP BY customer_segment
ORDER BY total_sales DESC;


--Discount Impact--

SELECT
    discount,
    AVG(profit) AS avg_profit
FROM orders
GROUP BY discount
ORDER BY discount;


--Separate Customers Table--

CREATE TABLE customers AS
SELECT
    DENSE_RANK() OVER (ORDER BY customer_name) AS customer_id,
    customer_name,
    region,
    segment
FROM orders
GROUP BY customer_name, region, segment;