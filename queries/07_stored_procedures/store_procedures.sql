-- ================================================================
-- Stored Procedures: IN, OUT, INOUT parameters and transactions
-- ================================================================

-- Simple procedure: update employee salary
CREATE OR REPLACE PROCEDURE update_employee_salary(
    IN p_employee_id INTEGER,
    IN p_new_salary  NUMERIC,
    IN p_reason      VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_salary     NUMERIC;
BEGIN
    SELECT 
        salary INTO v_old_salary
    FROM 
        employees
    WHERE 
        employee_id = p_employee_id;

    UPDATE 
        employees
    SET 
        salary = p_new_salary
    WHERE 
        employee_id = p_employee_id;

    INSERT INTO 
        salary_history (employee_id, old_salary, new_salary, reason)
    VALUES 
        (p_employee_id, v_old_salary, p_new_salary, p_reason);
END;
$$;

-- Procedure with IN parameter: deactivate all employees from a department
CREATE OR REPLACE PROCEDURE desactivate_all_employees_from_a_department(
    IN p_department_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE 
        employees
    SET 
        is_active = FALSE
    WHERE 
        department_id = p_department_id;
END;
$$;

-- Procedure with IN and OUT parameter: get department headcount
CREATE OR REPLACE PROCEDURE get_department_headcount(
    IN p_department_id INTEGER,
    OUT p_headcount INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT 
        COUNT(employee_id) INTO p_headcount
    FROM 
        employees
    WHERE 
        department_id = p_department_id;
END;
$$;

-- Procedure with transaction: salary adjustment with history log
CREATE OR REPLACE PROCEDURE update_employee_salary(
    IN p_employee_id INTEGER,
    IN p_new_salary  NUMERIC,
    IN p_reason      VARCHAR(500)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_old_salary     NUMERIC;
BEGIN
    SELECT 
        salary INTO v_old_salary
    FROM 
        employees
    WHERE 
        employee_id = p_employee_id;

    UPDATE 
        employees
    SET 
        salary = p_new_salary
    WHERE 
        employee_id = p_employee_id;

    INSERT INTO 
        salary_history (employee_id, old_salary, new_salary, reason)
    VALUES 
        (p_employee_id, v_old_salary, p_new_salary, p_reason);
        
    COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE NOTICE 'Erro: %', SQLERRM;
END;
$$;

-- Drop a procedure
DROP PROCEDURE get_department_headcount(INTEGER, INTEGER);