-- ================================================
-- Basic SELECT Queries: Filters, Aggregations, Ordering.
-- ================================================

-- Filter employees by department
SELECT * 
FROM 
    employees 
WHERE 
    department_id = 1;

SELECT * 
FROM 
    employees 
WHERE 
    department_id = 3;

SELECT * 
FROM 
    employees 
WHERE 
    department_id = 5;

SELECT * 
FROM 
    employees 
WHERE 
    department_id 
IN (
    SELECT 
        department_id 
    FROM 
        departments 
    WHERE 
        name = 'Infrastructure'
);

-- Filter employees by role
SELECT * 
FROM 
    employees 
WHERE 
    role_id = 1;

SELECT * 
FROM 
    employees 
WHERE 
    role_id = 3;

SELECT * 
FROM 
    employees 
WHERE 
    role_id = 5;

SELECT * 
FROM 
    employees 
WHERE 
    role_id 
IN (
    SELECT 
        role_id 
    FROM 
        roles 
    WHERE 
        title = 'Intern'
);

-- Filter active and inactive employees
SELECT * 
FROM 
    employees 
WHERE 
    is_active = FALSE;

SELECT * 
FROM 
    employees 
WHERE 
    is_active = TRUE;

-- Order employees by salary descending
SELECT * 
FROM 
    employees 
ORDER BY 
    salary DESC;

-- Order employees by hire date ascending
SELECT * 
FROM 
    employees 
ORDER BY 
    hire_date ASC;

-- Order employees by department and salary
SELECT * 
FROM 
    employees 
ORDER BY 
    department_id ASC, 
    salary        DESC;

-- Count employees per department
SELECT 
    department_id, 
    COUNT(*) AS employees_per_department 
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    employees_per_department DESC;

-- Average salary per department
SELECT 
    department_id, 
    ROUND(AVG(salary), 2) AS average_salary_per_department 
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    average_salary_per_department DESC;

-- Max and min salary per department
SELECT 
    department_id, 
    ROUND(MAX(salary), 2) AS max_per_department,
    ROUND(MIN(salary), 2) AS min_per_department  
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    department_id ASC;

-- Total payroll per department
SELECT 
    department_id, 
    ROUND(SUM(salary), 2) AS payroll_per_department
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    payroll_per_department DESC;

-- Departments with more than 5 employees (HAVING)
SELECT 
    department_id, 
    COUNT(*) AS headcount
FROM 
    employees
GROUP BY 
    department_id
HAVING 
    COUNT(*) > 5;

-- Departments with average salary above 5000 (HAVING)
SELECT 
    department_id, 
    ROUND(AVG(salary), 2) AS avg_salary
FROM 
    employees
GROUP BY 
    department_id
HAVING 
    AVG(salary) > 5000;

-- Employees hired between two dates (BETWEEN)
SELECT *
FROM 
    employees
WHERE 
    hire_date 
BETWEEN 
    '2021-01-01' AND '2022-01-01';

-- Employees with salary between two values (BETWEEN)
SELECT *
FROM 
    employees
WHERE 
    salary 
BETWEEN 
    2000 AND 6000;

-- Employees from specific departments (IN)
SELECT *
FROM 
    employees
WHERE 
    department_id 
IN (
    1, 2, 5
);

-- Employees whose first name starts with a specific letter (LIKE)
SELECT *
FROM 
    employees
WHERE 
    first_name
LIKE
    'E%';

-- Employees without a birth date registered (IS NULL)
SELECT *
FROM 
    employees
WHERE 
    birth_date IS NULL;

-- Employees with birth date registered (IS NOT NULL)
SELECT *
FROM 
    employees
WHERE 
    birth_date IS NOT NULL;