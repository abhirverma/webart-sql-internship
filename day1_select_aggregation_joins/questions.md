# Day 1 — SELECT, Aggregation & JOINs

Dataset: `customers_practice` (250 rows), `employees_practice` (25 rows),
`orders_practice` (5,000 rows). See `../schema/practice_schema_5000.sql`.

## Section A — SELECT, WHERE, ORDER BY, DISTINCT, LIMIT

1. List every distinct `product_category` that appears in orders.
2. Find all customers from Chandigarh with a Gold membership tier.
3. Find the 10 most recent completed orders (order_id, amount, order_date).
4. Find all orders over 10,000, sorted highest to lowest amount.
5. Find all customers who signed up during 2025.
6. Find the first 20 pending orders in the Electronics or Sports category.

## Section B — Aggregate Functions, GROUP BY, HAVING

7. Total number of orders and total revenue, completed orders only.
8. Total revenue per product category, highest first.
9. Number of orders per status (completed / pending / cancelled).
10. Every product category where total revenue exceeds 1,000,000.
11. Top 5 sales reps by number of orders handled.
12. Every product category where the average order amount exceeds 5,000.

## Section C — JOINs

13. Every order with the customer's name and city.
14. Total spend per customer, including customers with zero orders (show 0, don't drop them).
15. Every order with the sales rep's name and department.
16. Self-join on `employees_practice`: every employee's name next to their manager's name (CEO's manager should be blank/NULL).
17. Every customer who has never placed an order.
18. Total revenue per sales rep, with name and department, highest first.
19. The single city with the highest total revenue from completed orders.
