SELECT last_name 
from employees
where employee_id <> any (select manager_id from employees);

select *
from departments
where manager_id =
(select employee_id 
 from employees
 where last_name = 'Urman');

delete employees where 

select employee_id 
from employees
minus
select manager_id
from employees
minus
select manager_id
from departments;

select last_name from employees where employee_id = 112;

DECLARE
   last_name VARCHAR2(25) := 'Urman';
BEGIN
   DELETE FROM employees WHERE last_name = last_name;
END;
/

SET SERVEROUTPUT ON
DECLARE
   vlast_name VARCHAR2(25) := 'Himuro';
BEGIN
   DELETE FROM employees WHERE last_name = vlast_name;
   DBMS_OUTPUT.PUT_LINE('Cantidad de registros borrados: '||SQL%ROWCOUNT);
END;
/

SELECT * 
  FROM employees
 WHERE department_id = 5;

SET SERVEROUTPUT ON
DECLARE
  deptno   employees.department_id%TYPE := 5; 
BEGIN							
  DELETE FROM   employees
  WHERE  department_id = deptno;
END;
/

SET SERVEROUTPUT ON
DECLARE
  deptno   employees.department_id%TYPE := 5; 
BEGIN							
  DELETE FROM   employees
  WHERE  department_id = deptno;
  DBMS_OUTPUT.PUT_LINE('Cantidad de registros borrados: '||SQL%ROWCOUNT);
END;
/

DROP TABLE copy_emp;

CREATE TABLE copy_emp AS 
SELECT employee_id AS empno, first_name, last_name, email, phone_number,
       hire_date, job_id, salary, commission_pct, manager_id, department_id
  FROM employees
 WHERE rownum < 1;

DESC copy_emp

SELECT *
  FROM copy_emp;
  
SELECT *
  FROM employees;

delete copy_emp;

BEGIN
MERGE INTO copy_emp c
USING employees e
   ON (e.employee_id = c.empno)
 WHEN MATCHED THEN
UPDATE SET
       c.first_name     = e.first_name,
       c.last_name      = e.last_name,
       c.email          = e.email,
       c.phone_number   = e.phone_number,
       c.hire_date      = e.hire_date,
       c.job_id         = e.job_id,
       c.salary         = e.salary,
       c.commission_pct = e.commission_pct,
       c.manager_id     = e.manager_id,
       c.department_id  = e.department_id
  WHEN NOT MATCHED THEN
INSERT VALUES(e.employee_id,  e.first_name, e.last_name,
       e.email, e.phone_number, e.hire_date, e.job_id,
       e.salary, e.commission_pct, e.manager_id, 
       e.department_id);
END;
/

SELECT * 
  FROM copy_emp;

UPDATE employees
   SET salary = salary * 1.05
 WHERE employee_id = 202;

SELECT employee_id, first_name, last_name, salary
  FROM employees
 WHERE employee_id = 203;

DELETE copy_emp
WHERE EMPNO = 203;
 
DELETE employees
WHERE last_name = 'Pataballa';

SELECT empno, first_name, last_name, salary
  FROM copy_emp
 WHERE empno = 203;

SELECT *
  FROM employees
 WHERE last_name = 'Pataballa';
 
SELECT *
  FROM copy_emp
 WHERE last_name = 'Pataballa';
 
 
 MERGE INTO copy_emp c
USING employees e
   ON (e.employee_id = c.empno)
 WHEN MATCHED THEN
UPDATE SET
       c.first_name     = e.first_name,
       c.last_name      = e.last_name,
       c.email          = e.email,
       c.phone_number   = e.phone_number,
       c.hire_date      = e.hire_date,
       c.job_id         = e.job_id,
       c.salary         = e.salary,
       c.commission_pct = e.commission_pct,
       c.manager_id     = e.manager_id,
       c.department_id  = e.department_id
  WHEN NOT MATCHED THEN
INSERT VALUES(e.employee_id,  e.first_name, e.last_name,
       e.email, e.phone_number, e.hire_date, e.job_id,
       e.salary, e.commission_pct, e.manager_id, 
       e.department_id);
       

SET SERVEROUTPUT ON
DECLARE
  v_rows_deleted VARCHAR2(30);
  v_empno employees.employee_id%TYPE := &id;
BEGIN
  DELETE FROM  employees 
  WHERE employee_id = v_empno;
  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('Empleado no encontrado...');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Empleado encontrado...');
  END IF;
  v_rows_deleted := (SQL%ROWCOUNT ||' row deleted.');
  DBMS_OUTPUT.PUT_LINE (v_rows_deleted);
END;
/

select employee_id
from employees 
where employee_id not in (select manager_id from employees where manager_id is not null);