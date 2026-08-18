# SQL Practice - Data Analytics Internship (WebArt Softech)

SQL I worked through during a data analytics internship, using a synthetic
e-commerce dataset (250 customers, 25 employees, 5,000 orders). Split into
two parts:

- **Day 1**: SELECT / WHERE / ORDER BY, GROUP BY / HAVING, JOINs
- **Day 2**: subqueries, CTEs (including a recursive one), window functions
  (RANK, ROW_NUMBER, LAG, NTILE, moving averages), CASE WHEN, and views

## Schema

Three tables, set up in [`schema/practice_schema_5000.sql`](schema/practice_schema_5000.sql):

```
customers_practice (customer_id PK, name, city, signup_date, membership_tier)
employees_practice (employee_id PK, name, department, manager_id FK -> self, city)
orders_practice     (order_id PK, customer_id FK, sales_rep_id FK, product_category,
                      amount, order_date, status)
```

`employees_practice.manager_id` references itself, so there's a small org
hierarchy in there (CEO, then managers, then reps). `orders_practice` is the
main one, 5,000 rows, tied to both of the others.

Small samples of each CSV are in [`data/sample/`](data/sample/). Didn't
upload the full 5,000 rows, just enough to show the shape of the data.

## A few things I found running these

Pulled these by actually running the queries against the real data, not
just writing SQL that looked right on paper.

Top 3 spenders (completed orders only) are Divya Singh (Hyderabad, ~₹184.7k),
Radhika Gupta (Bangalore, ~₹184.6k), and Anita Singh (Amritsar, ~₹168.7k).
First and second are basically neck and neck. (`day2/answers.sql`, Q5)

Revenue by city is a lot closer than I expected. Pune's on top at ₹1.80M,
but Amritsar and Ahmedabad are right behind it at ₹1.77M and ₹1.76M, not the
runaway winner I assumed one city would be. (`day1/answers.sql`, Q19)

Out of 5,000 orders, most (3,083) land in the "Medium" bucket (₹500-5,000),
1,398 are "Large," and only 519 are "Small." Most of the order volume sits
in the middle, not at either end. (`day2/answers.sql`, Q12)

Top 4 sales reps by revenue are all in Sales (makes sense) and all cleared
₹6.9M+, led by Gaurav Nair at ₹7.44M. Ran RANK and DENSE_RANK side by side
to check for ties at the top, and there weren't any. (`day2/answers.sql`, Q8)

The recursive CTE for the org chart was probably the one I learned the most
from. It walks the manager_id self-join starting from the CEO (level 1) down
through the management layers to the reps. Same pattern shows up for things
like category trees in real schemas, so glad I got this one working.
(`day2/answers.sql`, Q6)

## Structure

```
schema/                          -- table definitions
day1_select_aggregation_joins/   -- questions.md + answers.sql (19 questions)
day2_subqueries_ctes_windows/    -- questions.md + answers.sql (15 questions)
data/sample/                     -- small CSV samples
```

Each `questions.md` has the question, the matching `answers.sql` has the
query, same order.

## Notes

- Tested against PostgreSQL (pgAdmin), also checked it runs on SQLite.
- `sales_rep_performance` (Day 2, Q15) was asked in the worksheet but I
  hadn't actually written it yet, so I added it here. Same LEFT JOIN +
  COALESCE pattern as `customer_lifetime_value` (Q14), just for reps instead
  of customers.
- Dataset's synthetic/generated, made for practice.
