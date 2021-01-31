-- SELECT [column,] group_function(column), ...
--   FROM	table
-- [WHERE	condition]
-- [GROUP BY column]
-- [ORDER BY column];
-- Funciones más comunes:
--    [ AVG * COUNT * MAX * MIN * STDDEV * SUM * VARIANCE ]
-- AVG retorna el promedio de una expresión.
-- COUNT retorna el número de filas retornada por una consulta.
-- COUNT(DISTINCT expr) retorna el número de filas distintas.
-- MAX retorna el valor máximo de una expresión.
-- MIN retorna el valor mínimo de una expresión.
-- STDDEV retorna la desviación estándar de una población.
-- SUM retorna la sumatoria de una expresión.
-- VARIANCE retorna la varianza de una expresión.
SELECT AVG(salary), COUNT(*), MAX(salary), MIN(salary),
       STDDEV(salary), SUM(salary), VARIANCE(salary)
  FROM employees;

SELECT ROUND(AVG(salary),2) AS "Promedio", COUNT(*) AS "Cant.", 
       MAX(salary) AS "Máximo", MIN(salary) AS "Mínimo",
       ROUND(STDDEV(salary),2) AS "Desviación", SUM(salary) AS "Suma", 
       ROUND(VARIANCE(salary),2) AS "Varianza"
  FROM employees;

SELECT COUNT(commission_pct)
  FROM employees;

SELECT COUNT(DISTINCT commission_pct)
  FROM employees;

SELECT COUNT(NVL(to_char(commission_pct),'No Commission'))
  FROM employees;

SELECT department_id, COUNT(*) -- (2) Retorna el número de filas por departamento
  FROM employees
 GROUP BY department_id -- (1) Agrupa los datos por el ID del departamento
 ORDER BY 1; -- (3) Ordena los datos por ID de departamento en orden ascendente

SELECT department_id, COUNT(*) -- (3) Retorna el número de filas por departamento
  FROM employees
 WHERE department_id IN (30,50,80) -- (1) Busca los empleados que laboran en esos departamentos
 GROUP BY department_id -- (2) Agrupa los datos por el ID del departamento
 ORDER BY 1; -- (4) Ordena los datos por ID de departamento en orden ascendente

SELECT department_id, job_id, COUNT(*) -- (3) Retorna el número de filas por departamento y puesto
  FROM employees
 WHERE department_id IN (30,50,80) -- (1) Busca los empleados que laboran en esos departamentos
 GROUP BY department_id, job_id -- (2) Agrupa los datos por el ID del departamento y del puesto
 ORDER BY 1, 2; -- (4) Ordena los datos por ID de departamento y puesto en orden ascendente

SELECT department_id, job_id, COUNT(*)
  FROM employees
 WHERE department_id = 50
   AND job_id = 'SH_CLERK'
 GROUP BY department_id, job_id;
   
SELECT department_id, job_id, COUNT(*) -- Da error
  FROM employees
 WHERE department_id IN (30,50,80)
-- GROUP BY department_id, job_id -- Cualquier columna o expresión que se encuentre en el SELECT y que 
 ORDER BY 1, 2;                    -- no sea parte de una función de agregación debe estar en el GROUP BY

SELECT department_id, AVG(salary) -- Da error?
  FROM employees
 WHERE AVG(salary) > 200
 GROUP BY department_id;

-- SELECT column, group_function (3)
--   FROM table
-- [WHERE condition] (1)
-- [GROUP BY group_by_expression] (2)
--[HAVING group_condition] (4)
-- [ORDER BY column]; (5)
SELECT department_id, ROUND(AVG(salary),2) -- (2)
  FROM employees
HAVING 0AVG(salary) > 2000 -- (3)
 GROUP BY department_id; -- (1)
 
SELECT job_id, SUM(salary) PAYROLL -- (3) Suma los salarios por puesto
  FROM employees
 WHERE job_id NOT LIKE '%REP%' -- (1) Busca los empleados cuyo puesto no contenga REP
HAVING SUM(salary) > 13000 -- (4) Busca las sumatorias de salarios mayores a 13000
 GROUP BY job_id -- (2) Agrupa los datos por puesto
 ORDER BY SUM(salary); -- (5)

SELECT MAX(ROUND(AVG(salary))) -- Las funciones grupales se pueden anidar hasta dos niveles
  FROM employees
 GROUP BY department_id;
