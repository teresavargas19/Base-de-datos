-- INSERT INTO table [(column [, column...])]
-- VALUES	(value [, value...]);
-- Con esta sintaxis sólo se inserta un registro a la vez

-- Insertar un registro especificando valores para cada columna
-- Se listan los valores en el mismo orden de las columnas de la tabla
-- De manera opcional se listan las columnas en la cláusula INSERT
-- Los valores tipo caracter y fecha se encierran entre comillas simples

INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES (175, 'Public Relations', 100, 1700);

-- Insertar valores nulos
-- De manera implícita
INSERT INTO	departments (department_id, department_name)
VALUES (300, 'Compras'); -- Se insertan valores nulos en las columnas no especificadas

-- De manera explícita
INSERT INTO	departments -- Se insertan valores nulos en las últimas dos columnas
VALUES (145, 'Finance', NULL, NULL);

-- Insertando valores especiales [SYSDATE - Función que retorna la fecha del SO]
INSERT INTO employees 
       (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, 
        commission_pct, manager_id, department_id)
VALUES (901,'Louis', 'Popp', 'LPOPP1', '515.124.4567', SYSDATE, 'AC_ACCOUNT', 6900, 
        NULL, 205, 100);
        
-- Insertando una fecha específica
INSERT INTO employees
VALUES (902, 'Den', 'Raphealy', 'DRAPHEAL1', '515.127.4561',
        TO_DATE('FEB 3, 1999', 'MON DD, YYYY'), 'AC_ACCOUNT', 
        11000, NULL, 100, 30);

-- Insertando valores usando variables de substitución para reusar la instrucción
INSERT INTO departments 
       (department_id, department_name, location_id)
VALUES (&department_id, '&department_name',&location);

-- Insertando valores usando subquery
-- No use la claúsula VALUES
-- Deben coincidir el número de columnas en la cláusula INSERT con las columnas
-- que se incluyen en el subquery
DELETE sales_reps;

INSERT INTO sales_reps(id, name, salary, commission_pct)
SELECT employee_id, last_name, salary, commission_pct
  FROM employees
 WHERE job_id LIKE '%REP%';

-- UPDATE	table
--    SET	column = value [, column = value, ...]
-- [WHERE condition];
-- El UPDATE permite actualizar filas existentes
UPDATE employees -- El empleado 113 es movido al ID de departamento 70
   SET department_id = 70
 WHERE employee_id = 113;

UPDATE employees -- Todos los empleados son movidos al ID de departamento 70
   SET department_id = 70;
-- WHERE employee_id = 113;

-- Actualizar registros usando subquery
UPDATE employees -- Actualiza el puesto y el salario
   SET job_id = (SELECT job_id -- Retorna el puesto del empleado 205
                   FROM employees 
                  WHERE employee_id = 205), 
       salary = (SELECT salary -- Retorna el salario del empleado 205
                   FROM employees 
                  WHERE employee_id = 205) 
 WHERE employee_id =  114; -- Busca al empleado 114

-- DELETE [FROM] table
-- [WHERE	condition];
-- Borra filas de una tabla
DELETE FROM departments -- Elimina el departamento Finance
 WHERE department_name = 'Compras';

DELETE FROM departments; -- Elimina todos los departamentos
-- WHERE department_name = 'Finance';

-- Eliminando registros usando subquery
DELETE FROM departments -- Elimina los departamentos que no tienen empleados
 WHERE department_id NOT IN
                (SELECT DISTINCT department_id
                   FROM employees
                  WHERE department_id IS NOT NULL);
                  
-- TRUNCATE TABLE table_name;
-- Elimina todas las filas de la tabla dejando la estructura intacta
-- Pertenece al lenguaje DDL

create table JOB_GRADES (
GRADE_LEVEL VARCHAR2(3),
LOWEST_SAL NUMBER,
HIGHEST_SAL NUMBER);

insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('A',1000, 2999);
insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('B',3000, 5999);
insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('C',6000, 9999);
insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('D',10000, 14999);
insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('E',15000, 24999);
insert into JOB_GRADES (GRADE_LEVEL, LOWEST_SAL,HIGHEST_SAL)
values ('F',25000, 40000);
commit; 

DELETE job_grades;

SELECT * FROM job_grades;

desc job_grades

commit;

rollback;

TRUNCATE TABLE job_grades;

-- Manejo de transacciones
-- Qué es una transacción? Es un conjunto de instrucciones DML que forman una
-- unidad lógica de trabajo. También la constituye una instrucción DDL o DCL.
-- Inicia: Con la primera instrucción DML.
-- Finaliza:
--    * Con la instrucción COMMIT o ROLLBACK
--    * Una instrucción DDL o DCL (hacen COMMIT implícito)
--    * Si el usuario sale de la aplicación SQL*Plus (COMMIT implícito)
--    * Si el sistema falla (ROLLBACK implícito)
SELECT DEPARTMENT_ID FROM DEPARTMENTS MINUS SELECT DEPARTMENT_ID FROM EMPLOYEES;

SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_ID = 120;
SELECT *
FROM departments
WHERE department_name = 'Finance';

SELECT * FROM EMPLOYEES WHERE DEPARTMENT_ID = 100;


DELETE FROM departments -- Elimina el departamento Finance
 WHERE department_name = 'Treasury';
COMMIT; -- Asienta la transacción anterior a la base de datos

DELETE FROM departments CASCADE CONSTRAINT; 
ROLLBACK; -- Deshace la transacción anterior dejando la tabla en el estado anterior

-- Controlando transacciones
-- SAVEPOINT name;
-- ROLLBACK TO SAVEPOINT name;
INSERT INTO departments(department_id, department_name, manager_id, location_id)
VALUES (700, 'Relaciones Publicas', 100, 1700);

INSERT INTO	departments (department_id, department_name)
VALUES (301, 'Produccion');

SELECT *
  FROM departments
 WHERE department_name IN ('Relaciones Publicas', 'Produccion');
 
SAVEPOINT A; -- Crea una marca

DELETE FROM departments -- Elimina el departamento Finance
 WHERE department_name = 'Produccion';

SELECT *
  FROM departments
 WHERE department_name IN ('Relaciones Publicas', 'Produccion');

ROLLBACK TO SAVEPOINT A; -- Deshace el DELETE y mantiene los dos INSERTs.

SELECT *
  FROM departments
 WHERE department_name IN ('Relaciones Publicas', 'Produccion');

SELECT employee_id, last_name,
                email, hire_date, job_id, salary, 
                department_id
         FROM   employees
         WHERE  department_id = 50;

-- Conectado como HR (sesión #1)
CREATE TABLE employees3 AS 
SELECT * FROM employees;

select salary
from employees3 
where employee_id = 103; -- 9000

update employees3
set salary = salary * 1.10
where employee_id = 103;

select salary
from employees3 
where employee_id = 103; -- 9900

-- Conectado como HR (sesión #2)
select salary
from employees3
where employee_id = 142; -- 3100

update employees3
set salary = salary * 1.10
where employee_id = 142;

select salary
from employees3 
where employee_id = 142; -- 3100

-- Conectado como HR (sesión #1)
select salary
from employees3 
where employee_id = 142; -- 3100

update employees3
set salary = salary * 1.10
where employee_id = 142;

select salary
from employees3
where employee_id = 142; -- 3410

-- Conectado como HR (sesión #2)
select salary
from employees3
where employee_id = 103; -- 9000

update employees3
set salary = salary * 1.10
where employee_id = 103;

-- Conectado como System
-- Identificar las sesiones que están bloqueando transacciones
select sid, serial#, username
from v$session
where sid in
(select blocking_session from v$session);

-- Matar las sesiones que están bloqueando transacciones
alter system kill session '112,189' immediate;