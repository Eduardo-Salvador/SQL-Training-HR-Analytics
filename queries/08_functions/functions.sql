-- ================================================================
-- User-Defined Functions: SQL, plpgsql, RETURNS TABLE
-- ================================================================

-- Simple function (LANGUAGE SQL): concatenate full name
CREATE OR REPLACE FUNCTION full_name(fname VARCHAR, lname VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS $$
    SELECT fname || ' ' || lname;
$$;

-- Function with IF/ELSE (LANGUAGE plpgsql): classify salary level
CREATE OR REPLACE FUNCTION salary_level(sal NUMERIC)
RETURNS VARCHAR
LANGUAGE plpgsql
AS $$
BEGIN
    IF sal < 3000 THEN
        RETURN 'Junior';
    ELSIF sal < 8000 THEN
        RETURN 'Mid';
    ELSE
        RETURN 'Senior';
    END IF;
END;
$$;

-- Function with RETURNS TABLE: employees by department
CREATE OR REPLACE FUNCTION employees_by_department(p_dept_id INTEGER)
RETURNS TABLE(employee_id INTEGER, full_name TEXT, salary NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN 
        QUERY
    SELECT 
        e.employee_id, CONCAT(e.first_name, ' ', e.last_name), e.salary
    FROM 
        employees e
    WHERE 
        e.department_id = p_dept_id;
END;
$$;

-- Function overloading: same name different parameter types
CREATE OR REPLACE FUNCTION full_name(fname VARCHAR, lname VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
AS $$
    SELECT fname || ' ' || lname;
$$;

CREATE OR REPLACE FUNCTION full_name(l_employee_id INTEGER)
RETURNS VARCHAR
LANGUAGE SQL
AS $$
    SELECT
        CONCAT(d.first_name, ' ', d.last_name)
    FROM
        employees d
    WHERE
        l_employee_id = d.employee_id
$$;

-- Drop a function
DROP FUNCTION full_name(INTEGER);

DROP FUNCTION IF EXISTS full_name(VARCHAR, VARCHAR);

DROP FUNCTION full_name(INTEGER) CASCADE;