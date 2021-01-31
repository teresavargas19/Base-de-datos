-- RRHH le solicita un reporte de todos los empleados que
-- ganan un salario mayor al salario de un empleado llamado Abel.
SELECT employee_id, last_name, salary
  FROM employees
 WHERE last_name = 'Abel';
 
SELECT employee_id, last_name, salary
  FROM employees
 WHERE salary > 11000;
 
-- Los subqueries ayudan a resolver este tipo de problemas
-- combinando ambas consulta en una sola.
-- El query interno (subquery) retorna el valor del salario de Abel.
-- El query principal usa este valor para buscar los empleados que ganan m�s.
SELECT employee_id, last_name, salary -- Query Principal
  FROM employees
 WHERE salary > (SELECT salary -- Subquery
                   FROM employees
                  WHERE last_name = 'Abel');

-- SELECT select_list
--   FROM table
--  WHERE expr operator
--		 	               (SELECT select_list
--		                    FROM table);
-- El subquery se ejecuta una vez antes del query principal.
-- El resultado del subquery es usado por el query principal.
-- Lineamientos:
--     1. Encierre los subqueries entre par�ntesis.
--     2. Coloque los subqueries del lado derecho a la condici�n de comparaci�n.
--     3. La cl�usula ORDER BY en el subquery no se necesita a menos que se quiera
--        realizar un an�lisis Top-N.
--     4. Usar operadores de filas simples en subqueries de filas simples.
--     5. Usar operadores de filas m�ltiples en subqueries de filas m�ltiples.
-- Operadores de filas simples: =, >, >=, <, <=, <> o != o ^!
SELECT last_name, job_id, salary -- Busca los empleados que tengan el mismo puesto
  FROM employees                 -- y ganen m�s que un salario retornado en los 
 WHERE job_id =                  -- subqueries
                (SELECT job_id -- Retorna el puesto del empleado 141 (ST_CLERK)
                   FROM employees
                  WHERE employee_id = 141)
   AND salary >
                (SELECT salary -- Retorna el salario del empleado 143 (58.5)
                   FROM employees
                  WHERE employee_id = 143);

-- Usando funciones grupales en un subquery
SELECT last_name, job_id, salary -- Retorna los empleados que tengan un salario igual
  FROM employees                 -- al salario m�nimo
 WHERE salary = 
                (SELECT MIN(salary) -- Retorna el salario m�nimo en el universo de empleados (47.25)
                   FROM employees);

-- Usando subqueries en la cl�usula HAVING
SELECT department_id, MIN(salary) -- Retorna los IDs de departamentos con el salario m�nimo 
  FROM employees                  -- de los empleados cuyo salario m�nimo sea mayor al 
 GROUP BY department_id           -- salario m�nimo del ID de departamento 50.
HAVING MIN(salary) >
                     (SELECT MIN(salary) -- Retorna el salario m�nimo en el universo de empleados
                        FROM employees   -- que laboran en el ID de departamento 50 (47.25)
                       WHERE department_id = 50);

SELECT employee_id, last_name -- Error? Cu�l regla se est� violando?
  FROM employees
 WHERE salary = -- Qu� tipo de operador se est� usando? 
                (SELECT MIN(salary) -- Cu�ntas filas retorna este query?
                   FROM employees
                  GROUP BY department_id);

SELECT last_name, job_id -- Error?
  FROM employees
 WHERE job_id =
                (SELECT job_id -- Cu�ntas filas retorna este query?
                   FROM employees
                  WHERE last_name = 'Haas');

-- Operadores de m�ltiples filas: IN, ANY, ALL
-- IN  [Igual a cualquier miembro de la lista]
-- ANY [Compara expr con cada valor retornado por el subquery]
-- ALL [Compara expr con todos los valores retornados por el subquery]

SELECT employee_id, last_name, job_id, salary
  FROM employees
 WHERE salary < ANY -- Menor al mayor valor retornado por el subquery
                    (SELECT salary
                       FROM employees
                      WHERE job_id = 'IT_PROG')
   AND job_id <> 'IT_PROG';

SELECT employee_id, last_name, job_id, salary
  FROM employees
 WHERE salary < ALL -- Menor al menor valor retornado por el subquery
                    (SELECT salary
                       FROM employees
                      WHERE job_id = 'IT_PROG')
   AND job_id <> 'IT_PROG';

SELECT last_name -- Retorna alguna fila?
  FROM employees
 WHERE employee_id NOT IN -- El operador NOT IN es equivalente a <> ALL.
                          (SELECT manager_id -- Uno de los valores retornados es NULL
                             FROM employees);

SELECT last_name -- Retorna alguna fila?
  FROM employees
 WHERE employee_id NOT IN -- El operador NOT IN es equivalente a <> ALL.
                          (SELECT manager_id -- Uno de los valores retornados es NULL
                             FROM employees
                            WHERE manager_id is not null);
                             
SELECT last_name -- Retorna alguna fila?
  FROM employees
 WHERE employee_id <> ALL -- El operador NOT IN es equivalente a <> ALL.
                          (SELECT manager_id -- Uno de los valores retornados es NULL
                             FROM employees);
SELECT last_name -- Retorna alguna fila?
  FROM employees
 WHERE employee_id IN -- El operador IN es equivalente a = ANY. 
                      (SELECT manager_id -- Uno de los valores retornados es NULL
                         FROM employees);


SELECT last_name, job_id, salary -- Busca los empleados que tengan el mismo puesto
  FROM employees                 -- y ganen m�s que un salario retornado en los 
 WHERE job_id =                  -- subqueries
                (SELECT job_id -- Retorna el puesto del empleado 141 (ST_CLERK)
                   FROM employees
                  WHERE employee_id = 141);
                  
                  
                  