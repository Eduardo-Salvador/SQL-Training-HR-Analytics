-- ================================================================
-- Business Analysis: HR Analytics Queries.
-- ================================================================

-- Headcount per department with department name
SELECT
    b.name,
    COUNT(a.employee_id) AS headcount
FROM
    employees a
INNER JOIN
    departments b
    ON
    a.department_id = b.department_id
GROUP BY
    b.name;

-- Headcount per role title
SELECT
    r.title,
    COUNT(a.employee_id) AS headcount
FROM
    employees a
INNER JOIN
    roles r
    ON
    a.role_id = r.role_id
GROUP BY
    r.title;

-- Active vs inactive employees count
SELECT
    COUNT(a.employee_id) AS active_employees,
    (
        SELECT
            COUNT(a2.employee_id) AS inactive_employees
        FROM
            employees a2
        WHERE
            a2.is_active = FALSE
    )
FROM
    employees a
WHERE
    a.is_active = TRUE;

-- Average salary per department with department name
SELECT
    b.name,
    ROUND(AVG(a.salary), 2) AS average_salary
FROM
    employees a
INNER JOIN
    departments b
    ON
    a.department_id = b.department_id
GROUP BY
    b.name
ORDER BY
    average_salary DESC;

-- Salary range per role (min, max, average)
SELECT
    r.title,
    r.min_salary,
    r.max_salary,
    ROUND(AVG(a.salary), 2) AS average_salary
FROM 
    employees a
INNER JOIN
    roles r
    ON
    a.role_id = r.role_id
GROUP BY
    r.title, 
    r.min_salary, 
    r.max_salary
ORDER BY
    average_salary DESC;

-- Top 5 highest paid employees with department and role
SELECT
    e1.employee_id,
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name,
    d.name AS department_name,
    r.title,
    e1.salary
FROM
    employees e1
INNER JOIN
    departments d
    ON
        e1.department_id = d.department_id
INNER JOIN
    roles r
    ON
        e1.role_id = r.role_id
WHERE
    5 > (
        SELECT
            COUNT(DISTINCT(e2.salary))
        FROM 
            employees e2
        WHERE
            e2.salary > e1.salary
            AND e1.department_id = e2.department_id
            AND e1.role_id = e2.role_id
  )
ORDER BY 
	department_name, 
	e1.salary DESC;

-- Employees above average salary in their own department
SELECT
    e1.employee_id,
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name,
    e1.salary,
    d.name AS department_name,
    ROUND((
        SELECT 
            AVG(e2.salary)
        FROM 
            employees e2
        WHERE 
            e2.department_id = e1.department_id
    ), 2) AS dept_avg_salary
FROM
    employees e1
INNER JOIN
    departments d 
    ON 
        e1.department_id = d.department_id
WHERE
    e1.salary > (
        SELECT 
            AVG(e2.salary)
        FROM 
            employees e2
        WHERE 
            e2.department_id = e1.department_id
    )
ORDER BY
    d.name ASC,
    e1.salary DESC;

-- Departments with average salary above company average
SELECT
    d.name AS department_name,
    ROUND(AVG(e.salary), 2) AS dept_avg_salary,
    ROUND((
        SELECT 
            AVG(salary) 
        FROM 
            employees), 2
    ) AS company_avg_salary
FROM
    employees e
INNER JOIN
    departments d 
    ON 
        e.department_id = d.department_id
GROUP BY
    d.department_id, d.name
HAVING
    AVG(e.salary) > (
        SELECT 
            AVG(salary) 
        FROM 
            employees
    )
ORDER BY
    dept_avg_salary DESC;

-- Employees hired per year
SELECT
    DATE_PART('year', hire_date) AS year,
    COUNT(employee_id) AS employees_hired
FROM
    employees
GROUP BY
    year
ORDER BY
    year ASC;

-- Employees hired per month in a specific year
SELECT
    DATE_PART('year', hire_date) AS year,
    DATE_PART('month', hire_date) AS month,
    COUNT(employee_id) AS employees_hired
FROM
    employees
WHERE
    DATE_PART('year', hire_date) = 2022
GROUP BY
    month, 
    year
ORDER BY
    month ASC;

-- Average years of service per department
SELECT
    d.name AS department_name,
    ROUND(AVG(DATE_PART('year', AGE(e.hire_date)))) AS avg_year_service
FROM
    employees e
INNER JOIN
    departments d
    ON
        e.department_id = d.department_id
GROUP BY
    department_name
ORDER BY
    avg_year_service DESC;

-- Employees with more than 3 years of service
SELECT
    e.employee_id,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    ROUND((DATE_PART('year', AGE(e.hire_date)))) AS year_service
FROM
    employees e
WHERE
    ROUND((DATE_PART('year', AGE(e.hire_date)))) > 3;

-- Average performance score per department
SELECT
    d.name AS department_name,
    ROUND(AVG(pr.score), 2) AS avg_score
FROM
    performance_reviews pr
INNER JOIN
    employees e
    ON
        pr.employee_id = e.employee_id
INNER JOIN
    departments d
    ON
        e.department_id = d.department_id
GROUP BY
    department_name
ORDER BY
    avg_score ASC;

-- Top 3 reviewed employees (most reviews received)
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.name AS department_name,
    COUNT(pr.employee_id) AS total_reviews_received
FROM
    performance_reviews pr
INNER JOIN
    employees e
    ON
        pr.employee_id = e.employee_id
INNER JOIN
    departments d
    ON
        e.department_id = d.department_id
GROUP BY
    full_name,
    department_name
ORDER BY
    total_reviews_received DESC
LIMIT 3;

-- Employees with average performance score below 3
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    d.name AS department_name,
    ROUND(AVG(pr.score), 2) AS avg_score
FROM
    performance_reviews pr
INNER JOIN
    employees e
    ON
        pr.employee_id = e.employee_id
INNER JOIN
    departments d
    ON
        e.department_id = d.department_id
GROUP BY
    full_name,
    department_name
HAVING
    avg_score < 3
ORDER BY
    avg_score DESC;
    
-- Departments with no performance reviews registered
SELECT 
    d.name AS department_name,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    pr.score
FROM 
    departments d
LEFT JOIN 
    employees e 
    ON 
        e.department_id = d.department_id
LEFT JOIN 
    performance_reviews pr 
    ON 
        pr.employee_id = e.employee_id
WHERE 
    pr.review_id IS NULL
ORDER BY
    d.name DESC;

-- Salary evolution per employee (current vs first registered salary)
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    s1.old_salary AS first_salary,
    e.salary AS current_salary,
    (e.salary - s1.old_salary) AS diff_salary
FROM
    salary_history s1
INNER JOIN
    employees e
    ON
        s1.employee_id = e.employee_id
WHERE 
    s1.created_at = (
    SELECT 
        MIN(s2.created_at)
    FROM 
        salary_history s2
    WHERE 
        s2.employee_id = s1.employee_id
);

-- Employees who received a salary increase
SELECT DISTINCT
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    TRUE as is_salary_increase
FROM
    salary_history s1
INNER JOIN
    employees e
    ON
        s1.employee_id = e.employee_id
WHERE 
    e.salary > s1.old_salary;

-- Employees who received a salary decrease
SELECT DISTINCT
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    TRUE as is_salary_decrease
FROM
    salary_history s1
INNER JOIN
    employees e
    ON
        s1.employee_id = e.employee_id
WHERE 
    e.salary < s1.old_salary;