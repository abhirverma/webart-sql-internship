-- ============================================================
-- Day 1 answers — SELECT, Aggregation & JOINs
-- Run schema/practice_schema_5000.sql first and import the CSVs.
-- ============================================================

-- Q1: distinct product categories
SELECT DISTINCT product_category
FROM orders_practice;

-- Q2: Gold members in Chandigarh
SELECT *
FROM customers_practice
WHERE city = 'Chandigarh' AND membership_tier = 'Gold';

-- Q3: 10 most recent completed orders
SELECT order_id, order_date, amount
FROM orders_practice
WHERE status = 'completed'
ORDER BY order_date DESC
LIMIT 10;

-- Q4: orders over 10,000
SELECT *
FROM orders_practice
WHERE amount > 10000
ORDER BY amount DESC;

-- Q5: customers who signed up in 2025
SELECT *
FROM customers_practice
WHERE signup_date >= '2025-01-01' AND signup_date <= '2025-12-31';

-- Q6: first 20 pending Electronics/Sports orders
SELECT *
FROM orders_practice
WHERE (product_category = 'Electronics' OR product_category = 'Sports')
  AND status = 'pending'
ORDER BY order_id
LIMIT 20;

-- Q7: total completed orders + revenue
SELECT COUNT(order_id) AS completed_orders, SUM(amount) AS total_revenue
FROM orders_practice
WHERE status = 'completed';

-- Q8: revenue per category
SELECT product_category, SUM(amount) AS total_revenue
FROM orders_practice
GROUP BY product_category
ORDER BY total_revenue DESC;

-- Q9: orders per status
SELECT status, COUNT(order_id) AS order_count
FROM orders_practice
GROUP BY status;

-- Q10: categories with revenue > 1,000,000
SELECT product_category, SUM(amount) AS total_revenue
FROM orders_practice
GROUP BY product_category
HAVING SUM(amount) > 1000000;

-- Q11: top 5 sales reps by order count
SELECT sales_rep_id, COUNT(order_id) AS order_count
FROM orders_practice
GROUP BY sales_rep_id
ORDER BY order_count DESC
LIMIT 5;

-- Q12: categories with avg order amount > 5,000
SELECT product_category, AVG(amount) AS avg_amount
FROM orders_practice
GROUP BY product_category
HAVING AVG(amount) > 5000;

-- Q13: order + customer name/city
SELECT o.order_id, c.name, c.city, o.amount
FROM orders_practice o
JOIN customers_practice c ON o.customer_id = c.customer_id;

-- Q14: total spend per customer, including zero-order customers
SELECT c.customer_id, c.name, COALESCE(SUM(o.amount), 0) AS total_spend
FROM customers_practice c
LEFT JOIN orders_practice o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Q15: order + sales rep name/department
SELECT o.order_id, o.sales_rep_id, e.department, e.name
FROM orders_practice o
LEFT JOIN employees_practice e ON o.sales_rep_id = e.employee_id;

-- Q16: employee <-> manager self-join
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees_practice e
LEFT JOIN employees_practice m ON e.manager_id = m.employee_id;

-- Q17: customers who never ordered
SELECT c.customer_id, c.name
FROM customers_practice c
LEFT JOIN orders_practice o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q18: revenue per sales rep
SELECT e.name AS rep_name, e.department, SUM(o.amount) AS total_revenue
FROM employees_practice e
JOIN orders_practice o ON e.employee_id = o.sales_rep_id
GROUP BY e.name, e.department
ORDER BY total_revenue DESC;

-- Q19: single highest-revenue city (completed orders only)
SELECT c.city, SUM(o.amount) AS total_revenue
FROM customers_practice c
JOIN orders_practice o ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 1;
