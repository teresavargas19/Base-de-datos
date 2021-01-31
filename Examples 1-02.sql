/*
SELECT *|{[DISTINCT] column|expression [alias],...}
  FROM   table
[WHERE condition(s)];
*/
/*
  Condiciones de comparaci�n - Operadores aritm�ticos:
  =   >   >=   <   <=   <> o != o ^=   BETWEEN   IN (set)   LIKE   IS NULL
*/
SELECT last_name, salary, manager_id
  FROM employees
 WHERE manager_id = 100; -- Proyecta informaci�n de empleados que se reportan al 
                         -- empleado 100
                         
SELECT last_name, first_name, salary
  FROM employees
 WHERE last_name = 'King'; -- Proyecta informaci�n de empleados que el apellido 
                           -- sea King
                           
SELECT last_name, salary, hire_date
  FROM employees
 WHERE hire_date BETWEEN '01-JAN-94' AND '31-DEC-94'; -- Busca un rango de fecha

SELECT last_name, salary, department_id
  FROM employees
 WHERE department_id IN (60, 90); -- Busca los empleados que se encuentren en la 
                                  -- lista de IDs
SELECT *
  FROM countries
 WHERE country_name LIKE 'A%'; -- Busca las ciudades que inician con M

SELECT *
  FROM countries
 WHERE country_name LIKE '%a'; -- Busca las ciudades que terminan con a

SELECT *
  FROM countries
 WHERE country_name LIKE '%o%'; -- Busca las ciudades que contengan una o

SELECT *
  FROM countries
 WHERE country_name LIKE '_e_i%'; -- Busca las ciudades que tengan una e en el 
                                  -- segundo caracter
select * from jobs;

insert into jobs values ('PROG','Programmer',2500,3500);

SELECT *
  FROM employees
 WHERE job_id NOT LIKE '%_%'; -- Busca los empleados que tengan una C despu�s de 
                              -- un caracter
SELECT *
  FROM jobs
 WHERE job_id NOT LIKE '%_%'; -- Busca los empleados que tengan una C despu�s de 
                              -- un caracter
select *
from jobs
where job_id like '%\_%' ESCAPE '\'; -- Busca los empleados que tengan un 
                                     -- caracter _
select employee_id, last_name,job_id
from employees
where job_id like '%\_C%' ESCAPE '\'; -- Busca los empleados que tengan una C 
                                      -- despu�s del caracter _
SELECT last_name
  FROM employees
 WHERE department_id = NULL; -- No trae nada

SELECT last_name, department_id
  FROM employees
 WHERE department_id IS NULL; -- Busca los empleados que no tienen un 
                              -- departamento asignado
                              
/*
  Condiciones l�gicas - Operadores l�gicos:
  AND   OR   NOT
*/
SELECT * -- Busca las ciudades que contengan tanto una a como una e en su nombre
  FROM countries
 WHERE country_name LIKE '%a%'
   AND country_name LIKE '%e%';

SELECT * -- Busca las ciudades que contengan una x o una w en su nombre
  FROM countries
 WHERE country_name LIKE '%x%'
    OR country_name LIKE '%w%';
    
SELECT * -- Busca las ciudades que contengan una x y una w en su nombre
  FROM countries
 WHERE country_name LIKE '%x%'
    AND country_name LIKE '%w%';
    
SELECT *
  FROM departments
 WHERE department_id NOT IN (60,90);

SELECT *          -- Busca las ciudades que contengan tanto una r como una w o 
  FROM countries  -- una g en su nombre
 WHERE country_name LIKE '%g%'
    OR country_name LIKE '%r%'
   AND country_name LIKE '%w%';
    
SELECT * -- Busca las ciudades que contengan (una g o una r) y una w en su nombre
  FROM countries
 WHERE (country_name LIKE '%g%'
    OR country_name LIKE '%r%')
   AND country_name LIKE '%w%';

SELECT employee_id, last_name, job_id, department_id
  FROM employees
 WHERE job_id LIKE '%REP%'
  AND department_id = 90;
/*
SELECT expr 
 	FROM table
[WHERE condition(s)]
[ORDER BY	{column, expr, numeric_position} [ASC|DESC]];

Cl�usula ORDER BY
  - ASC  Orden ascendente, de menor a mayor [Default]
  - DESC Orden descendente, de mayor a menor
*/
SELECT last_name, salary
  FROM employees
 WHERE job_id like '%SA%'
 ORDER BY salary; -- Ordenando de manera ascendente [Default]
 
SELECT last_name, salary
  FROM employees
 WHERE job_id like '%SA%'
 ORDER BY salary DESC; -- Ordenando de manera descendente.

SELECT last_name, salary
  FROM employees
 WHERE job_id like '%SA%'
 ORDER BY 2 DESC; -- Ordenando por la posici�n num�rica que ocupa la columna en la proyecci�n.
 
SELECT last_name, salary Salario
  FROM employees
 WHERE job_id like '%SA%'
 ORDER BY Salario DESC; -- Ordenando por un Alias

SELECT last_name, department_id, salary
  FROM employees
 ORDER BY department_id DESC, salary DESC; -- Cu�l es el orden???

SELECT last_name, department_id, salary
  FROM employees
 ORDER BY department_id DESC, salary DESC; -- Cu�l es el orden???

/*
Variables de substituci�n.
Reusa el c�digo, de tal manera que se puede ejecutar la instrucci�n m�ltiples 
veces y esta le pide al usuario que digite un valor como par�metro de entrada 
en tiempos de corrida. Se usa el & y && delante de la variable. Las variables 
de substituci�n se pueden usar en el WHERE, ORDER BY, para especificar una 
columna en el SELECT o una tabla en el FROM o para especificar el SELECT completo.
*/
SELECT *
  FROM departments
 WHERE department_id = &id; -- Variable de substituci�n en el WHERE

SELECT last_name, salary, department_id
  FROM employees
 ORDER BY &column; -- Variable de substituci�n en el ORDER BY

SELECT last_name, salary, &column -- Variable de substituci�n en una columna del SELECT
  FROM employees;

SELECT &query; -- Variable de substituci�n para suplir el query completo

SET VERIFY OFF -- Comando de SQL*Plus que apaga los mensajes
SELECT last_name, &columna -- Pide el valor de columna una sola vez
  FROM employees
 WHERE department_id = &valor
 ORDER BY &columna DESC; -- Toma el valor especificado anteriormente
UNDEFINE id

SET VERIFY OFF -- Comando de SQL*Plus que apaga los mensajes

DEFINE id = 100 -- Deposita 100 directamente a la variable de substituci�n ID
SELECT last_name, salary
  FROM employees
 WHERE employee_id = &id;
UNDEFINE id -- Limpia la variable ID

SET VERIFY OFF -- Apaga el mensaje que se muestra al usar variables de substituci�n
DEFINE id = 100
SELECT last_name, salary
  FROM employees
 WHERE employee_id = &id;
UNDEFINE id

DEFINE valor = '* from employees'
select &valor;
UNDEFINE valor