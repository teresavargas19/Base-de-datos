-- Non-PairWise Comparisson
SELECT manager_id, 
       department_id
  FROM employees
 WHERE first_name = 'Daniel';

SELECT employee_id,
       manager_id, 
       department_id
  FROM employees
 WHERE manager_id IN 
       (SELECT manager_id 
          FROM employees
         WHERE first_name = 'Daniel')
   AND department_id IN 
       (SELECT department_id
          FROM employees
         WHERE first_name = 'Daniel');

-- PairWise Comparisson
SELECT employee_id,
       manager_id, 
       department_id
  FROM employees
 WHERE (manager_id,department_id) IN 
       (SELECT manager_id,department_id 
          FROM employees
         WHERE first_name = 'Daniel');
         
-- Non-PairWise Comparisson
SELECT manager_id, department_id
  FROM employees
 WHERE first_name = 'John';

SELECT employee_id, 
       manager_id, 
       department_id,
       job_id
  FROM employees
 WHERE manager_id IN
       (SELECT manager_id 
          FROM employees
         WHERE first_name = 'John')
   AND department_id IN
       (SELECT department_id
          FROM employees
         WHERE first_name = 'John')
   AND job_id IN 
       (SELECT job_id
          FROM employees
         WHERE first_name = 'John')
   AND first_name <> 'John';

/*
108	100
123	50
100	80
*/

-- PairWise Comparisson
SELECT employee_id, 
       manager_id, 
       department_id,
       job_id
  FROM employees
 WHERE (manager_id, department_id, job_id) IN
       (SELECT manager_id, department_id, job_id
          FROM employees
         WHERE first_name = 'John')
   AND first_name <> 'John';

-- Scalar Subquery
SELECT employee_id, last_name,
       (CASE
        WHEN department_id =
             (SELECT department_id 
                FROM departments
               WHERE location_id = 1800)
        THEN 'Canada' 
        ELSE 'USA' 
         END) location
  FROM employees;

-- Correlated Subquery
SELECT department_id, last_name, salary,
       (SELECT ROUND(AVG(salary))
          FROM employees
         WHERE department_id = e.department_id) avgsal
  FROM employees e
 WHERE salary > 
               (SELECT AVG(salary)
                  FROM employees
                 WHERE department_id = e.department_id
               )
 ORDER BY 1,2;
 
-- WITH
-- Use la cláusula WITH para escribir una consulta que despliegue el nombre
-- del departamento y el total de salarios de aquellos cuyo total de salarios 
-- sea mayor al promedio de salarios de todos los departamentos
WITH dept_costs AS (
   SELECT d.department_name,
          SUM(e.salary) AS dept_total
     FROM employees e JOIN departments d
       ON e.department_id = d.department_id
    GROUP BY d.department_name
    ORDER BY 1),
      avg_cost AS (
   SELECT SUM(dept_total)/COUNT(*) AS dept_avg
     FROM dept_costs)
SELECT * 
  FROM dept_costs 
 WHERE dept_total >
       (SELECT dept_avg 
          FROM avg_cost)
 ORDER BY department_name;

-- Busca las variables declaradas en un Bloque PL/SQL 
-- pero no referenciadas
WITH subprograms_with_exception
  AS (SELECT DISTINCT owner
                    , object_name
                    , object_type
                    , name
        FROM all_identifiers has_exc
       WHERE has_exc.owner = USER
         AND has_exc.usage = 'DECLARATION'
         AND has_exc.TYPE = 'VARIABLE'),
     subprograms_with_raise_handle
  AS (SELECT DISTINCT owner
                    , object_name
                    , object_type
                    , name
        FROM all_identifiers with_rh
       WHERE with_rh.owner = USER
         AND with_rh.usage in ('REFERENCE','ASSIGNMENT')
         AND with_rh.TYPE = 'VARIABLE')
SELECT *
  FROM subprograms_with_exception
 MINUS
SELECT *
  FROM subprograms_with_raise_handle;

-- Se crea un procedimiento para sumar dos valores
-- y mostrar su resultado por pantalla
-- La variable C se define pero no se usa.
DROP PROCEDURE suma;
CREATE OR REPLACE PROCEDURE suma AS
   A NUMBER(3):= 78;
   B NUMBER(3):= 39;
   C NUMBER(3); -- Esta variable se declara pero no se usa
   R NUMBER(3);
BEGIN
   R := A + B; -- Se realiza la suma
   DBMS_OUTPUT.PUT_LINE('El resultado de la suma es: '||R);
     -- Se muestra el resultado por pantalla
END;
/

SET SERVEROUTPUT ON 
  -- Permite que el valor se muestre por pantalla
EXECUTE suma; 
  -- Ejecuta el procedimiento