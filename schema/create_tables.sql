CREATE SCHEMA IF NOT EXISTS hr;
SET search_path TO hr;

CREATE TABLE IF NOT EXISTS locations (
	location_id INTEGER GENERATED ALWAYS AS IDENTITY,
	city         VARCHAR(50) NOT NULL,
	state        VARCHAR(30) NOT NULL,
	country      VARCHAR(30) NOT NULL,
    CONSTRAINT pk_locations  PRIMARY KEY (location_id)
);

CREATE TABLE IF NOT EXISTS roles (
    role_id     INTEGER GENERATED ALWAYS AS IDENTITY,
    title       VARCHAR(100)    NOT NULL UNIQUE,
    level       VARCHAR(50),
    min_salary  NUMERIC(10,2)   NOT NULL,
    max_salary  NUMERIC(10,2)   NOT NULL,
    CONSTRAINT pk_roles         PRIMARY KEY (role_id),
    CONSTRAINT valid_min_salary CHECK (min_salary > 0),
    CONSTRAINT valid_max_salary CHECK (max_salary > 0)
);

CREATE TABLE IF NOT EXISTS departments (
    department_id   INTEGER GENERATED ALWAYS AS IDENTITY,
    name            VARCHAR(150)     NOT NULL UNIQUE,
    manager_id      INTEGER,
    location_id     INTEGER,
    created_at      TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_department         PRIMARY KEY (department_id),
    CONSTRAINT fk_location           FOREIGN KEY (location_id)   REFERENCES locations(location_id)
);

CREATE TABLE IF NOT EXISTS employees (
    employee_id     INTEGER GENERATED ALWAYS AS IDENTITY,
    first_name      VARCHAR(150)    NOT NULL,
    last_name       VARCHAR(150)    NOT NULL,
    email           VARCHAR(200)    NOT NULL UNIQUE,
    hire_date       DATE            NOT NULL,
    birth_date      DATE            NOT NULL,
    salary          NUMERIC(10,2)   NOT NULL,
    is_active       BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    department_id   INTEGER,
    role_id         INTEGER,
    CONSTRAINT pk_employee       PRIMARY KEY (employee_id),
    CONSTRAINT fk_department     FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT fk_role           FOREIGN KEY (role_id)       REFERENCES roles(role_id)
);

ALTER TABLE departments
ADD CONSTRAINT fk_manager FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

CREATE TABLE IF NOT EXISTS performance_reviews (
    review_id   INTEGER GENERATED ALWAYS AS IDENTITY,
    employee_id INTEGER      NOT NULL,
    reviewer_id INTEGER      NOT NULL,
    comments    VARCHAR(500),
    score       INTEGER      NOT NULL,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_review      PRIMARY KEY (review_id),
    CONSTRAINT fk_employee    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    CONSTRAINT fk_reviewer    FOREIGN KEY (reviewer_id) REFERENCES employees(employee_id),
    CONSTRAINT valid_score    CHECK (score BETWEEN 1 AND 5)
);

CREATE TABLE IF NOT EXISTS salary_history (
    history_id  INTEGER GENERATED ALWAYS AS IDENTITY,
    employee_id INTEGER          NOT NULL,
    old_salary  NUMERIC(10,2),
    new_salary  NUMERIC(10,2)    NOT NULL,
    reason      VARCHAR(500),
    created_at  TIMESTAMPTZ      NOT NULL DEFAULT NOW(),
    CONSTRAINT pk_salary_history PRIMARY KEY (history_id),
    CONSTRAINT fk_employee       FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);