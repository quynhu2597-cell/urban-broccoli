# urban-broccoli

E-commerce Sales Analysis using SQL

1. Business Problem
The company wants to understand its sales performance, customer behavior, and operational efficiency.
Key questions:
What are the main drivers of revenue?
Which products and categories perform best?
How do customers behave over time?
What factors affect customer satisfaction?

 2. Dataset
Dataset: Brazilian E-Commerce Public Dataset by Olist
Data includes:
Orders
Order items
Customers
Payments
Reviews
Products

 3 Create Master Table (JOIN)
SELECT 
    o.order_id,
    o.customer_id,
    oi.product_id,
    p.product_category_name,
    oi.price,
    oi.freight_value,
    op.payment_value,
    r.review_score,
    o.order_status,
    o.order_purchase_timestamp
INTO ecommerce_master
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN order_payments op ON o.order_id = op.order_id
LEFT JOIN order_reviews r ON o.order_id = r.order_id;
 4. Data Analysis (SQL Queries)

 4.1 Total Revenue
SELECT SUM(payment_value) AS total_revenue
FROM ecommerce_master;

 4.2 Monthly Revenue Trend
SELECT 
    FORMAT(order_purchase_timestamp, 'yyyy-MM') AS month,
    SUM(payment_value) AS revenue
FROM ecommerce_master
GROUP BY FORMAT(order_purchase_timestamp, 'yyyy-MM')
ORDER BY month;

 4.3 Top Product Categories
SELECT TOP 10
    product_category_name,
    SUM(payment_value) AS revenue
FROM ecommerce_master
GROUP BY product_category_name
ORDER BY revenue DESC;

 4.4 Customer Segmentation (New vs Returning)
WITH first_order AS (
    SELECT customer_id, MIN(order_purchase_timestamp) AS first_date
    FROM ecommerce_master
    GROUP BY customer_id
)

SELECT 
    CASE 
        WHEN m.order_purchase_timestamp = f.first_date THEN 'New'
        ELSE 'Returning'
    END AS customer_type,
    COUNT(DISTINCT m.customer_id) AS total_customers
FROM ecommerce_master m
JOIN first_order f ON m.customer_id = f.customer_id
GROUP BY 
    CASE 
        WHEN m.order_purchase_timestamp = f.first_date THEN 'New'
        ELSE 'Returning'
    END;

 4.5 Rating vs Revenue
SELECT 
    review_score,
    COUNT(*) AS total_orders,
    AVG(payment_value) AS avg_order_value
FROM ecommerce_master
GROUP BY review_score
ORDER BY review_score;

 4.6 Delivery Performance (Estimated vs Actual)
SELECT 
    AVG(DATEDIFF(day, order_purchase_timestamp, order_delivered_customer_date)) AS avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL;

 5. Key Insights
Revenue is concentrated in a few top product categories
Returning customers contribute significantly to total revenue
Higher review scores correlate with higher order value
Delivery time impacts customer satisfaction

🧾 6. Conclusion
This analysis provides insights into revenue drivers, customer behavior, and operational performance, helping businesses make data-driven decisions.

💼 7. Skills Demonstrated
SQL Data Cleaning
Data Transformation
Multi-table Joins
Aggregation & Grouping
Window Functions
Business Analysis
