-- ================================================================
-- CTEs, Window Functions, Indexes and EXPLAIN:
-- ================================================================

-- CTEs --
-- Employees above average salary using CTE
WITH dept_infos AS (
    SELECT 
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        e.salary,
        d.name AS department_name,
        ROUND(AVG(e.salary) OVER (), 2) AS avg_salary
    FROM employees e
    JOIN
        departments d
        ON
            e.department_id = d.department_id
)
SELECT full_name, salary, avg_salary
FROM dept_infos
WHERE salary > avg_salary;

-- Top 3 salaries per department using CTE
WITH salary_ranking AS (
    SELECT
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        e.salary,
        d.name AS department_name,
        RANK() OVER (PARTITION BY e.department_id ORDER BY salary DESC) AS salary_rank
    FROM employees e
    JOIN
        departments d
        ON
            e.department_id = d.department_id
)
SELECT * FROM salary_ranking WHERE salary_rank <= 3;

-- Departments with headcount and average salary using CTE
WITH departments_infos AS (
    SELECT
        d.name AS department_name,
        COUNT(e.employee_id) AS headcount,
        ROUND(AVG(e.salary), 2) AS avg_salary
    FROM 
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
    GROUP BY 
        department_name
    ORDER BY 
        avg_salary DESC
)
SELECT * FROM departments_infos;

-- WINDOW FUNCTIONS --
-- ROW_NUMBER: rank employees by salary within each department
WITH ranking_employees_with_department AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM ranking_employees_with_department;

-- RANK: rank employees by salary within each department (allows ties)
WITH ranking_employees_with_department_allow_ties AS (
    SELECT
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM ranking_employees_with_department_allow_ties;

-- DENSE_RANK: rank employees by salary within each department (no gaps)
WITH ranking_employees_with_department_no_gaps AS (
    SELECT
        DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM ranking_employees_with_department_no_gaps;

-- ROW_NUMBER: top 3 highest paid employees per department
WITH ranking_top3_employees_per_department AS (
    SELECT
        ROW_NUMBER() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM ranking_top3_employees_per_department WHERE salary_rank <= 3;

-- SUM OVER PARTITION: total payroll per department alongside each employee
WITH sum_over_partition AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary,
        SUM(e.salary) OVER (PARTITION BY e.department_id) AS dept_payroll
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM sum_over_partition;

-- AVG OVER PARTITION: department average salary alongside each employee
WITH avg_over_partition AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary,
        ROUND(AVG(e.salary) OVER (PARTITION BY e.department_id), 2) AS avg_salary_dept
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM avg_over_partition;

-- LAG: compare each employee salary with the previous employee in the same department
WITH compate_lag_salaries AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary,
        LAG(e.salary) OVER (PARTITION BY e.department_id ORDER BY e.hire_date) AS lag_salary,
        (e.salary - LAG(e.salary) OVER (PARTITION BY e.department_id ORDER BY e.hire_date)) AS comparation_salaries
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM compate_lag_salaries;

-- LEAD: compare each employee salary with the next employee in the same department
WITH compate_lead_salaries AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        d.name AS department_name,
        e.salary,
        LEAD(e.salary) OVER (PARTITION BY e.department_id ORDER BY e.hire_date) AS lead_salary,
        (e.salary - LEAD(e.salary) OVER (PARTITION BY e.department_id ORDER BY e.hire_date)) AS comparation_salaries
    FROM
        employees e
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM compate_lead_salaries;

-- LAG: compare each performance score with the previous review of the same employee
WITH compate_lag_scores AS (
    SELECT
        CONCAT(e.first_name, ' ', e.last_name) AS full_name,
        pr.score,
        LAG(pr.score) OVER (PARTITION BY pr.employee_id ORDER BY pr.created_at) AS lag_score,
        (pr.score - LAG(pr.score) OVER (PARTITION BY pr.employee_id ORDER BY pr.created_at)) AS comparation_scores
    FROM
        performance_reviews pr
    JOIN 
        employees e
        ON 
            pr.employee_id = e.employee_id
    JOIN 
        departments d 
        ON 
            e.department_id = d.department_id
)
SELECT * FROM compate_lag_scores;

-- INDEXES --
-- Create B-Tree index on department_id
CREATE INDEX idx_employees_department
ON 
    employees (department_id);

-- Create B-Tree index on role_id
CREATE INDEX idx_role_id
ON 
    employees (role_id);

-- Create Hash index on email
CREATE INDEX idx_employees_email
ON 
    employees 
USING HASH (email);

-- Create partial index on active employees
CREATE INDEX idx_active_employees
ON 
    employees (department_id)
WHERE 
    is_active = TRUE;

-- Drop index
DROP INDEX idx_active_employees;

DROP INDEX CONCURRENTLY idx_role_id;

-- EXPLAIN --
-- EXPLAIN: simple select without index
EXPLAIN SELECT * FROM employees;

-- EXPLAIN ANALYZE: simple select without index
EXPLAIN ANALYZE SELECT * FROM employees;

-- EXPLAIN ANALYZE: select after creating index
EXPLAIN ANALYZE SELECT * FROM employees WHERE email = 'sabrina.silva@hranalytics.com';