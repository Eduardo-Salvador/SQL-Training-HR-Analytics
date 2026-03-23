-- ================================================================
-- Triggers: BEFORE, AFTER, FOR EACH ROW
-- ================================================================

-- Trigger function: log salary changes to salary_history automatically
CREATE OR REPLACE FUNCTION log_salary_change()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary IS DISTINCT FROM OLD.salary THEN
        INSERT INTO 
            salary_history (employee_id, old_salary, new_salary, reason)
        VALUES 
            (OLD.employee_id, OLD.salary, NEW.salary, 'Salary update');
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger: fire after UPDATE on employees
CREATE TRIGGER trg_log_salary_change
AFTER UPDATE ON 
    employees
FOR EACH ROW
EXECUTE FUNCTION log_salary_change();

-- Trigger function: prevent deletion of active employees
CREATE OR REPLACE FUNCTION prevent_delete_active_employee()
RETURNS TRIGGER AS $$
BEGIN
    IF OLD.is_active = TRUE THEN
        RAISE EXCEPTION 'Cannot delete active employee';
    END IF;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Create trigger: fire before DELETE on employees
CREATE TRIGGER trg_prevent_delete_active_employee
BEFORE DELETE ON 
    employees
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_active_employee();

-- Drop trigger and trigger function
DROP TRIGGER IF EXISTS trg_log_salary_change ON employees;
DROP FUNCTION IF EXISTS log_salary_change;

DROP TRIGGER IF EXISTS trg_prevent_delete_active_employee ON employees;
DROP FUNCTION IF EXISTS prevent_delete_active_employee;