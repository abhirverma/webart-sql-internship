-- ============================================================
-- Day 1 Practice Dataset: Schema Setup
-- Run this FIRST in pgAdmin's Query Tool, then import the CSVs
-- (see import instructions in the questions document).
-- ============================================================

DROP TABLE IF EXISTS orders_practice;
DROP TABLE IF EXISTS customers_practice;
DROP TABLE IF EXISTS employees_practice;

-- ------------------------------------------------------------
-- CUSTOMERS (~250 rows)
-- ------------------------------------------------------------
CREATE TABLE customers_practice (
    customer_id     INT PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    city            VARCHAR(50),
    signup_date     DATE,
    membership_tier VARCHAR(20)   -- 'Bronze', 'Silver', 'Gold'
);

-- ------------------------------------------------------------
-- EMPLOYEES (25 rows) — CEO -> 4 managers -> reps, some in Sales
-- ------------------------------------------------------------
CREATE TABLE employees_practice (
    employee_id INT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    department  VARCHAR(30),      -- Sales, Marketing, Support, Operations
    manager_id  INT REFERENCES employees_practice(employee_id),
    city        VARCHAR(50)
);

-- ------------------------------------------------------------
-- ORDERS (5,000 rows) — the main practice table
-- ------------------------------------------------------------
CREATE TABLE orders_practice (
    order_id         INT PRIMARY KEY,
    customer_id      INT REFERENCES customers_practice(customer_id),
    sales_rep_id     INT REFERENCES employees_practice(employee_id),
    product_category VARCHAR(30),
    amount           NUMERIC(10, 2) NOT NULL,
    order_date       DATE NOT NULL,
    status           VARCHAR(20) NOT NULL  -- 'completed', 'pending', 'cancelled'
);

-- ============================================================
-- AFTER running the above, import the CSVs into each table:
-- pgAdmin -> right-click table -> Import/Export Data -> Import
-- -> select the matching CSV -> make sure "Header" is set to Yes.
-- Import order matters (foreign keys): customers_practice and
-- employees_practice FIRST, then orders_practice.
-- ============================================================

-- Sanity checks after import:
-- SELECT COUNT(*) FROM customers_practice;  -- expect 250
-- SELECT COUNT(*) FROM employees_practice;  -- expect 25
-- SELECT COUNT(*) FROM orders_practice;     -- expect 5000
