-- ============================================================
-- Day 2 answers — Subqueries, CTEs, Window Functions, CASE WHEN, Views
-- ============================================================

-- Q1: customers with at least one order over 20,000
SELECT *
FROM customers_practice
WHERE customer_id IN (
    SELECT customer_id
    FROM orders_practice
    WHERE amount > 20000
);

-- Q2: total spend of OTHER customers in the same city (correlated subquery)
SELECT
    c.name,
    c.city,
    (
        SELECT COALESCE(SUM(o.amount), 0)
        FROM orders_practice o
        JOIN customers_practice c2 ON c2.customer_id = o.customer_id
        WHERE c2.city = c.city AND c2.customer_id != c.customer_id
    ) AS other_customers_total_spent
FROM customers_practice c;

-- Q3: sales reps who processed more orders than the average per rep
SELECT sales_rep_id, COUNT(*) AS total_count
FROM orders_practice
GROUP BY sales_rep_id
HAVING COUNT(*) > (
    SELECT AVG(total_count)
    FROM (
        SELECT COUNT(*) AS total_count
        FROM orders_practice
        GROUP BY sales_rep_id
    ) AS average_total
);

-- Q4: categories with completed revenue > 500,000 (CTE)
WITH category_revenue AS (
    SELECT product_category, SUM(amount) AS total_revenue
    FROM orders_practice
    WHERE status = 'completed'
    GROUP BY product_category
)
SELECT product_category, total_revenue
FROM category_revenue
WHERE total_revenue > 500000
ORDER BY total_revenue DESC;

-- Q5: top 3 spending customers (chained CTE)
WITH customer_total AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM orders_practice
    WHERE status = 'completed'
    GROUP BY customer_id
),
ranked_customers AS (
    SELECT customer_id, total_spent,
           DENSE_RANK() OVER (ORDER BY total_spent DESC) AS rank_spent
    FROM customer_total
)
SELECT customer_id, total_spent
FROM ranked_customers
WHERE rank_spent <= 3;

-- Q6: recursive CTE — full org hierarchy
WITH RECURSIVE org_chart AS (
    SELECT employee_id, name, department, manager_id, 1 AS level
    FROM employees_practice
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.name, e.department, e.manager_id, oc.level + 1
    FROM employees_practice e
    JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT name, department, level
FROM org_chart
ORDER BY level, name;

-- Q7: each customer's orders ranked by amount (ROW_NUMBER)
SELECT customer_id, amount,
       ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS rank_in_customer
FROM orders_practice;

-- Q8: sales reps ranked by revenue — RANK vs DENSE_RANK
SELECT sales_rep_id, SUM(amount) AS total_revenue,
       RANK()       OVER (ORDER BY SUM(amount) DESC) AS rank_revenue,
       DENSE_RANK() OVER (ORDER BY SUM(amount) DESC) AS denserank_revenue
FROM orders_practice
GROUP BY sales_rep_id
ORDER BY total_revenue DESC;

-- Q9: previous order amount + change, per customer (LAG)
SELECT customer_id, order_date, amount,
       LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_amount,
       amount - LAG(amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS change
FROM orders_practice
ORDER BY customer_id, order_date;

-- Q10: 7-day moving average of daily completed revenue
SELECT order_date, daily_revenue,
       ROUND(AVG(daily_revenue) OVER (
           ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ), 2) AS moving_avg_7day
FROM (
    SELECT order_date, SUM(amount) AS daily_revenue
    FROM orders_practice
    WHERE status = 'completed'
    GROUP BY order_date
) daily
ORDER BY order_date;

-- Q11: customers split into 4 spend quartiles (NTILE)
SELECT customer_id, total_spent,
       NTILE(4) OVER (ORDER BY total_spent DESC) AS spend_quartile
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM orders_practice
    WHERE status = 'completed'
    GROUP BY customer_id
) customer_spend
ORDER BY spend_quartile, total_spent DESC;

-- Q12: bucket orders into Small / Medium / Large
SELECT
    CASE
        WHEN amount < 500 THEN 'Small'
        WHEN amount BETWEEN 500 AND 5000 THEN 'Medium'
        ELSE 'Large'
    END AS order_bucket,
    COUNT(*) AS order_count
FROM orders_practice
GROUP BY order_bucket
ORDER BY order_count DESC;

-- Q13: group customers by membership tier, total spend per group
SELECT
    CASE
        WHEN c.membership_tier = 'Gold' THEN 'Gold'
        WHEN c.membership_tier = 'Silver' THEN 'Silver'
        ELSE 'Other'
    END AS tier_group,
    SUM(o.amount) AS total_spend
FROM orders_practice o
JOIN customers_practice c ON o.customer_id = c.customer_id
GROUP BY tier_group
ORDER BY total_spend DESC;

-- Q14: customer_lifetime_value view
CREATE VIEW customer_lifetime_value AS
SELECT
    c.customer_id,
    c.name,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_spend
FROM customers_practice c
LEFT JOIN orders_practice o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

SELECT * FROM customer_lifetime_value
WHERE total_spend > 50000;

-- Q15: sales_rep_performance view
CREATE VIEW sales_rep_performance AS
SELECT
    e.employee_id,
    e.name,
    e.department,
    COUNT(o.order_id) AS total_orders,
    COALESCE(SUM(o.amount), 0) AS total_revenue
FROM employees_practice e
LEFT JOIN orders_practice o ON e.employee_id = o.sales_rep_id
GROUP BY e.employee_id, e.name, e.department;

SELECT * FROM sales_rep_performance
ORDER BY total_revenue DESC;
