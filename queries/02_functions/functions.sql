-- ================================================
-- Native PostgreSQL Function: String, Math and Date.
-- ================================================

-- STRING FUNCTIONS --
-- Display employee full name in uppercase
SELECT 
    UPPER(first_name) AS FIRST_NAME, 
    UPPER(last_name)  AS LAST_NAME 
FROM 
    employees;

-- Display employee full name in lowercase
SELECT 
    LOWER(first_name) AS FIRST_NAME, 
    LOWER(last_name)  AS LAST_NAME 
FROM 
    employees;

-- Filter employees whose name contains a specific letter (LOWER + LIKE)
SELECT *
FROM
    employees
WHERE
    LOWER(first_name)
LIKE 
    '%e%';

-- Concatenate 'Z-' prefix with employee_id to track data origin
SELECT 
    CONCAT('Z-', employee_id) AS employee_id_concat, 
    first_name, 
    last_name, 
    email, 
    hire_date, 
    birth_date, 
    salary, 
    is_active, 
    created_at, 
    department_id, 
    role_id
FROM
    employees;

-- Concatenate first and last name into a single column
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name
FROM
    employees;

-- Concatenate department prefix with department name
SELECT
    CONCAT(department_id, ' - ', name) AS full_departments
FROM 
    departments
ORDER BY
    department_id ASC;

-- MATH FUNCTIONS --
-- Square root of a numeric value (SQRT)
SELECT 
    SQRT(score) AS square_root_score
FROM
    performance_reviews;

-- Round salary to zero decimal places (ROUND)
SELECT 
    ROUND(salary) AS round_salary
FROM
    employees;

-- Round average salary per department to 2 decimal places (ROUND + AVG)
SELECT
    department_id,
    ROUND(AVG(salary)) AS avg_salary_per_department
FROM 
    employees
GROUP BY 
    department_id
ORDER BY 
    department_id ASC;

-- Absolute value of a numeric expression (ABS)
SELECT
    ABS(MIN(salary) - MAX(salary)) AS salary_diference
FROM
    employees;

-- DATE FUNCTIONS --
-- Current date (CURRENT_DATE)
SELECT CURRENT_DATE;

-- Current date and time (NOW())
SELECT NOW();

-- Extract year from hire date (DATE_PART)
SELECT
    employee_id,
    DATE_PART('year', hire_date) AS hire_year
FROM
    employees;

-- Extract month from hire date (DATE_PART)
SELECT
    employee_id,
    DATE_PART('month', hire_date) AS hire_month,
    DATE_PART('year', hire_date) AS hire_year
FROM
    employees
ORDER BY
    hire_year DESC,
    hire_month ASC;

-- Count years of service for each employee (DATE_PART)
SELECT
    employee_id,
    DATE_PART('year', AGE(hire_date)) AS years_of_service
FROM
    employees;

-- Calculate employee age from birth date (AGE)
SELECT
    employee_id,
    DATE_PART('year', AGE(birth_date)) AS employee_years
FROM
    employees;

-- Filter employees hired in a specific year (DATE_PART)
SELECT
    employee_id,
    DATE_PART('year', hire_date) AS hire_year
FROM
    employees
WHERE
    DATE_PART('year', hire_date) = 2020; 

-- Filter employees hired in the last 3 years (NOW())
SELECT
    employee_id,
    DATE_PART('year', hire_date) AS hire_year
FROM
    employees
WHERE
    hire_date >= (NOW() - INTERVAL '3 years');