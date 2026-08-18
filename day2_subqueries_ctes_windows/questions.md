# Day 2 — Subqueries, CTEs, Window Functions, CASE WHEN & Views

Same dataset as Day 1: `customers_practice`, `employees_practice`, `orders_practice`.

## Section A — Subqueries

1. Customers who've placed at least one order over 20,000 (subquery with `IN`).
2. For each customer: name, city, and — via a correlated subquery — the total
   spend of every *other* customer in the same city.
3. Sales reps who've processed more orders than the average number of orders
   per rep (subquery inside `HAVING`, compared against a derived table).

## Section B — CTEs

4. Using a CTE: every product category where completed-order revenue exceeds
   500,000, highest first.
5. Using a chained CTE: the top 3 spending customers overall (completed orders).
6. Using a recursive CTE on `employees_practice`: the full org hierarchy —
   name, department, level — ordered by level then name.

## Section C — Window Functions

7. Each customer's own orders ranked highest-to-lowest amount, via `ROW_NUMBER`.
8. Sales reps ranked by total revenue using both `RANK` and `DENSE_RANK` —
   are there any ties?
9. Each order's amount next to the customer's previous order amount (by date)
   and the change between them, via `LAG`.
10. A 7-day moving average of total daily revenue (completed orders only).
11. Customers split into 4 spend quartiles via `NTILE`.

## Section D — CASE WHEN

12. Bucket every order into Small (<500), Medium (500–5,000), Large (>5,000)
    and count orders per bucket.
13. Group customers into Gold / Silver / Other by membership tier, and show
    total spend per group.

## Section E — Views

14. Create `customer_lifetime_value`: customer_id, name, total orders, total
    spend (including zero-order customers). Query it for spend > 50,000.
15. Create `sales_rep_performance`: each rep's name, department, total orders
    handled, total revenue generated. Query it sorted by revenue, highest first.
