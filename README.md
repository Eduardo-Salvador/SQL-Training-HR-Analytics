<div align="center">

[English](#sql-training--hr-analytics) · [Português-BR](#sql-learning--hr-analytics-1)

[![Generic badge](https://img.shields.io/badge/STATUS-FINISHED-<COLOR>.svg)](https://shields.io/) [![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)]([https://GitHub.com/Naereen/ama](https://github.com/Eduardo-Salvador))

---

![USA](https://img.shields.io/badge/🇺🇸-English-blue)

# SQL Training — HR Analytics

A structured SQL learning project using PostgreSQL, covering fundamentals through advanced database programming. Built as a portfolio piece demonstrating progressive SQL proficiency.

## Stack

![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

## About PostgreSQL

PostgreSQL is an open source relational database management system with nearly 40 years of active development. It follows the SQL standard closely, supports advanced features like window functions, CTEs, stored procedures, user-defined functions and triggers. It runs on all major cloud providers and is the standard choice for backend and analytics roles in the tech market.

## What this project covers

The project is structured in progressive layers, each folder building on the previous one.

The schema layer defines the database structure using DDL, tables, data types, constraints, primary and foreign keys, and populates it with realistic seed data using DML insert statements.

The basics layer covers the core of SQL querying: filtering rows with WHERE, sorting with ORDER BY, aggregating with GROUP BY and HAVING, and pattern matching with LIKE and BETWEEN.

The functions layer explores PostgreSQL native functions for string manipulation, mathematical operations and date handling, including UPPER, LOWER, CONCAT, ROUND, NOW(), DATE_PART, AGE and INTERVAL.

The intermediate layer covers JOIN operations between multiple tables including INNER, LEFT, RIGHT and self JOIN, as well as subqueries, correlated subqueries and EXISTS expressions.

The analysis layer applies everything learned to real HR Analytics business questions: headcount per department, salary distribution, performance scoring, employee tenure and salary evolution.

The views layer introduces CREATE OR REPLACE VIEW to encapsulate reusable query logic, including the FILTER aggregate for conditional counting within a single query.

The advanced layer covers CTEs for readable multi-step logic, window functions for ranking and comparison without collapsing rows (ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, SUM and AVG over partitions), index creation for query optimization and EXPLAIN ANALYZE for execution plan analysis.

The programmability layer covers server-side logic: stored procedures with IN and OUT parameters and transaction control, user-defined functions in both LANGUAGE SQL and LANGUAGE plpgsql with IF/ELSE logic and RETURNS TABLE, and triggers that fire automatically on INSERT, UPDATE and DELETE events.


## Setup

Clone the repository and start the database:

    git clone https://github.com/Eduardo-Salvador/SQL-Training-HR-Analytics.git
    cd SQL-Training-HR-Analytics
    docker compose up -d

Connect DBeaver to the database:

    Host: localhost
    Port: 5432
    Database: hr_analytics
    Username: postgres
    Password: admin123

Run the schema and seed files in order:

    schema/create_tables.sql
    schema/seed_data.sql

## Schema

The project uses a fictional HR dataset with 6 tables: locations, roles, departments, employees, performance_reviews and salary_history. Employees have departments, roles, performance reviews and salary history records.

## Queries

| File | Concepts |
|------|----------|
| queries/01_basics/select_basics.sql | SELECT, WHERE, GROUP BY, ORDER BY, HAVING, BETWEEN, IN, LIKE, IS NULL |
| queries/02_functions/functions.sql | UPPER, LOWER, CONCAT, LENGTH, ROUND, ABS, SQRT, NOW(), CURRENT_DATE, DATE_PART, AGE, INTERVAL |
| queries/03_intermediate/joins_and_subqueries.sql | INNER JOIN, LEFT JOIN, RIGHT JOIN, self JOIN, subqueries, EXISTS, NOT EXISTS |
| queries/04_analysis/business_analysis.sql | Business analytics queries: headcount, salary analysis, turnover, performance scoring |
| queries/05_views/views.sql | CREATE OR REPLACE VIEW, simple views, joined views, FILTER aggregate |
| queries/06_advanced/advanced.sql | CTEs, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, SUM/AVG OVER PARTITION, indexes, EXPLAIN ANALYZE |
| queries/07_stored_procedures/stored_procedures.sql | CREATE PROCEDURE, IN/OUT parameters, transactions, COMMIT, ROLLBACK, EXCEPTION handling |
| queries/08_functions/functions.sql | User-defined functions, LANGUAGE SQL, LANGUAGE plpgsql, IF/ELSE, RETURNS TABLE, overloading |
| queries/09_triggers/triggers.sql | AFTER UPDATE trigger, BEFORE DELETE trigger, NEW/OLD variables, RAISE EXCEPTION |

---

![Brazil](https://img.shields.io/badge/🇧🇷-Português-green)

# SQL Learning — HR Analytics

Projeto de aprendizado de SQL estruturado usando PostgreSQL, cobrindo desde os fundamentos até programação avançada de banco de dados. Construído como projeto de portfólio demonstrando progressão de habilidades em SQL.

## Stack

![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

## Sobre o PostgreSQL

PostgreSQL é um sistema gerenciador de banco de dados relacional de código aberto com quase 40 anos de desenvolvimento ativo. Segue o padrão SQL com fidelidade, suporta funcionalidades avançadas como window functions, CTEs, stored procedures, funções criadas pelo usuário e triggers. Roda nos principais provedores de nuvem e é a escolha padrão para vagas de backend e analytics no mercado de tecnologia.

## O que esse projeto cobre

O projeto é estruturado em camadas progressivas, onde cada pasta constrói sobre a anterior.

A camada de schema define a estrutura do banco usando DDL, tabelas, tipos de dados, constraints, chaves primárias e estrangeiras, e popula com dados fictícios realistas usando instruções DML de insert.

A camada de básicos cobre o núcleo de consultas SQL: filtrar linhas com WHERE, ordenar com ORDER BY, agregar com GROUP BY e HAVING, e buscar padrões com LIKE e BETWEEN.

A camada de funções explora as funções nativas do PostgreSQL para manipulação de texto, operações matemáticas e tratamento de datas, incluindo UPPER, LOWER, CONCAT, ROUND, NOW(), DATE_PART, AGE e INTERVAL.

A camada intermediária cobre operações de JOIN entre múltiplas tabelas incluindo INNER, LEFT, RIGHT e self JOIN, além de subqueries, subqueries correlacionadas e expressões EXISTS.

A camada de análises aplica tudo que foi aprendido em perguntas reais de negócio em HR Analytics: headcount por departamento, distribuição salarial, score de performance, tempo de empresa e evolução salarial.

A camada de views apresenta CREATE OR REPLACE VIEW para encapsular lógica de consulta reutilizável, incluindo o agregado FILTER para contagem condicional dentro de uma única query.

A camada avançada cobre CTEs para lógica de múltiplas etapas legível, window functions para ranking e comparação sem colapsar linhas (ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, SUM e AVG over partitions), criação de índices para otimização de queries e EXPLAIN ANALYZE para análise do plano de execução.

A camada de programabilidade cobre lógica server-side: stored procedures com parâmetros IN e OUT e controle de transação, funções criadas pelo usuário em LANGUAGE SQL e LANGUAGE plpgsql com lógica IF/ELSE e RETURNS TABLE, e triggers que disparam automaticamente em eventos de INSERT, UPDATE e DELETE.

## Setup

Clone o repositório e suba o banco:

    git clone https://github.com/Eduardo-Salvador/SQL-Training-HR-Analytics.git
    cd SQL-Training-HR-Analytics
    docker compose up -d

Conecte o DBeaver ao banco:

    Host: localhost
    Port: 5432
    Database: hr_analytics
    Username: postgres
    Password: admin123

Execute os arquivos de schema e seed nessa ordem:

    schema/create_tables.sql
    schema/seed_data.sql

## Schema

O projeto usa um dataset fictício de RH com 6 tabelas: locations, roles, departments, employees, performance_reviews e salary_history. Funcionários têm departamentos, cargos, avaliações de performance e histórico salarial.

## Queries

| Arquivo | Conceitos |
|---------|-----------|
| queries/01_basics/select_basics.sql | SELECT, WHERE, GROUP BY, ORDER BY, HAVING, BETWEEN, IN, LIKE, IS NULL |
| queries/02_functions/functions.sql | UPPER, LOWER, CONCAT, LENGTH, ROUND, ABS, SQRT, NOW(), CURRENT_DATE, DATE_PART, AGE, INTERVAL |
| queries/03_intermediate/joins_and_subqueries.sql | INNER JOIN, LEFT JOIN, RIGHT JOIN, self JOIN, subqueries, EXISTS, NOT EXISTS |
| queries/04_analysis/business_analysis.sql | Queries de analytics de RH: headcount, análise salarial, performance, tempo de empresa |
| queries/05_views/views.sql | CREATE OR REPLACE VIEW, views simples, views com JOIN, FILTER aggregate |
| queries/06_advanced/advanced.sql | CTEs, ROW_NUMBER, RANK, DENSE_RANK, LAG, LEAD, SUM/AVG OVER PARTITION, índices, EXPLAIN ANALYZE |
| queries/07_stored_procedures/stored_procedures.sql | CREATE PROCEDURE, parâmetros IN/OUT, transações, COMMIT, ROLLBACK, tratamento de exceção |
| queries/08_functions/functions.sql | Funções criadas pelo usuário, LANGUAGE SQL, LANGUAGE plpgsql, IF/ELSE, RETURNS TABLE, overloading |
| queries/09_triggers/triggers.sql | Trigger AFTER UPDATE, trigger BEFORE DELETE, variáveis NEW e OLD, RAISE EXCEPTION |

---
