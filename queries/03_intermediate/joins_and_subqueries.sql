-- ================================================
-- Intermediate Queries: JOINs, Subqueries, EXISTS.
-- ================================================

-- INNER JOIN --
-- Employees with their department name
SELECT  
    a.employee_id,
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    b.name AS department_name,
    a.department_id
FROM
    employees a
INNER JOIN
    departments b
    ON
        a.department_id = b.department_id;

-- Employees with their role title
SELECT
    a.employee_id,
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    r.title AS role_title,
    a.role_id
FROM
    employees a
INNER JOIN
    roles r
    ON
        a.role_id = r.role_id;

-- Employees with department and role (multiple joins)
SELECT
    a.employee_id,
    CONCAT(a.first_name, ' ', a.last_name) AS name,
    b.name AS department_name,
    a.department_id,
    r.title AS role_title,
    a.role_id
FROM
    employees a
INNER JOIN
    departments b 
    ON 
    	a.department_id = b.department_id
INNER JOIN
    roles r
	ON 
		a.role_id = r.role_id;

-- Performance reviews with employee name and reviewer name
SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
    r.comments,
    r.score,
    CONCAT(rv.first_name, ' ', rv.last_name) AS reviewer_name
FROM
    performance_reviews r
INNER JOIN
    employees e
    ON
        r.employee_id = e.employee_id
INNER JOIN
    employees rv
    ON
        r.reviewer_id = rv.employee_id;

-- LEFT JOIN --
-- All employees including those without a department
SELECT 
	a.employee_id, 
	CONCAT(a.first_name, ' ', a.last_name) AS name,
	b.name AS department_name
FROM 
	employees a
LEFT JOIN 
	departments b 
	ON 
		a.department_id = b.department_id;

-- All employees including those without a performance review
SELECT 
    e.employee_id, 
    CONCAT(e.first_name, ' ', e.last_name) AS name, 
    r.comments, 
    r.score 
FROM 
    employees e 
LEFT JOIN 
    performance_reviews r 
	ON 
		e.employee_id = r.employee_id;

-- All departments including those without employees
SELECT 
	d.department_id, 
	d.name AS department_name, 
	COUNT(a.employee_id) AS employees
FROM 
	departments d
LEFT JOIN 
	employees a 
	ON 
		d.department_id = a.department_id
GROUP BY 
	d.department_id, 
	d.name;

-- RIGHT JOIN --
-- All departments including those with no employees assigned
SELECT 
	d.department_id, 
	d.name AS department_name, 
	COUNT(a.employee_id) AS employees
FROM 
	employees a
RIGHT JOIN 
	departments d
	ON 
		a.department_id = d.department_id
GROUP BY 
	d.department_id, 
    d.name;

-- SUBQUERIES --
-- Employees with salary above the company average
SELECT 
	employee_id, 
   	CONCAT(first_name, ' ', last_name) AS name, 
    salary, 
    (
        SELECT 
            ROUND(AVG(salary), 2) 
        FROM 
            employees
    ) AS company_salary_average 
FROM 
    employees 
WHERE 
    salary > (
        SELECT 
            AVG(salary) 
        FROM employees
    );

-- Employees belonging to the Engineering department (subquery)
SELECT 
	employee_id, 
   	CONCAT(first_name, ' ', last_name) AS name, 
    salary,
    department_id,
    (
        SELECT 
            name 
        FROM 
            departments 
        WHERE 
            name = 'Engineering'
    ) AS department_name
FROM
    employees
WHERE
    department_id = (
        SELECT 
            department_id 
        FROM 
            departments 
        WHERE 
            name = 'Engineering'
    );

-- Departments that have at least one active employee (EXISTS)
SELECT 
	d.department_id,
    d.name
FROM
    departments d
WHERE EXISTS (
    SELECT 
        1 
    FROM 
        employees e 
    WHERE 
        e.department_id = d.department_id
);

-- Employees who have never received a performance review (NOT EXISTS)
SELECT 
    e.employee_id, 
    CONCAT(e.first_name, ' ', e.last_name) AS full_name
FROM 
    employees e
WHERE NOT EXISTS (
    SELECT 
        1
    FROM 
        performance_reviews r
    WHERE 
        r.employee_id = e.employee_id
);

-- Top 3 highest salaries per department (subquery)
SELECT
    e1.employee_id,
    CONCAT(e1.first_name, ' ', e1.last_name) AS full_name,
    e1.department_id,
    e1.salary
FROM
    employees e1
WHERE 3 > (
    SELECT
        COUNT(DISTINCT e2.salary)
    FROM
        employees e2
    WHERE
        e2.salary > e1.salary
        AND e1.department_id = e2.department_id
)
ORDER BY
    e1.department_id ASC,
    e1.salary DESC;