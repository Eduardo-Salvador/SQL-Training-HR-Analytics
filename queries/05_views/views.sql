-- ================================================================
-- Views: Simple, Joined and Updatable views.
-- ================================================================

-- Simple view: active employees by department
CREATE OR REPLACE VIEW vw_active_employees AS
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    e.salary,
    d.name AS department
FROM 
    employees e
JOIN 
    departments d 
    ON 
        e.department_id = d.department_id
WHERE 
    e.is_active = TRUE;

-- Simple view: employees with department and role name
CREATE OR REPLACE VIEW vw_employees_by_department_and_role AS
SELECT
    d.name AS department,
    r.title AS role,
    COUNT(e.employee_id) FILTER (WHERE e.is_active = TRUE)  AS active_employees,
    COUNT(e.employee_id) FILTER (WHERE e.is_active = FALSE) AS inactive_employees,
    COUNT(e.employee_id) AS total_employees
FROM
    employees e
JOIN 
    departments d 
    ON e.department_id = d.department_id
JOIN 
    roles r 
    ON e.role_id = r.role_id
GROUP BY
    d.name,
    r.title;

-- View with JOIN: headcount and average salary per department
CREATE OR REPLACE VIEW vw_headcount_and_average_salary_per_department AS
SELECT
    d.name AS department,
    COUNT(e.employee_id) AS total_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM
    employees e
JOIN
    departments d
    ON
        e.department_id = d.department_id
GROUP BY
    department
ORDER BY
    avg_salary DESC;

-- View with JOIN: employees with performance review count
CREATE OR REPLACE VIEW vw_employees_with_performance_review_count AS
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    CONCAT(e1.first_name, ' ', e1.last_name) AS reviewer_name,
    pr.comments,
    pr.score,
    pr.created_at
FROM
    performance_reviews pr
JOIN
    employees e
    ON
    pr.employee_id = e.employee_id
JOIN
    employees e1
    ON
    pr.reviewer_id = e1.employee_id
ORDER BY
    employeer_name;

-- View with JOIN: departments with location
CREATE OR REPLACE VIEW vw_departments_with_location AS
SELECT
    d.name AS department,
    l.city,
    l.state,
    l.country
FROM
    departments d
LEFT JOIN
    locations l
    ON
    d.location_id = l.location_id;

-- Querying a view as if it were a table
SELECT * FROM vw_active_employees;

SELECT * FROM vw_employees_by_department_and_role;

SELECT * FROM vw_headcount_and_average_salary_per_department;

SELECT * FROM vw_employees_with_performance_review_count;

SELECT * FROM vw_departments_with_location;

SELECT 
    department, city, state 
FROM 
    vw_departments_with_location 
WHERE 
    city = 'Sao Paulo';

-- Updating a view with CREATE OR REPLACE
CREATE OR REPLACE VIEW vw_departments_with_location AS
SELECT
    d.name AS department,
    l.city,
    l.state,
    l.country,
    l.location_id -- new
FROM
    departments d
LEFT JOIN
    locations l
    ON
    d.location_id = l.location_id;

-- Dropping a view
DROP VIEW vw_departments_with_location;

DROP VIEW IF EXISTS vw_departments_with_location;

DROP VIEW vw_departments_with_location CASCADE;

DROP VIEW IF EXISTS vw_departments_with_location CASCADE;