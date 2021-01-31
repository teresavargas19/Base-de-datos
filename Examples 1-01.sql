/*
SELECT *|{[DISTINCT] column|expression [alias],...}
  FROM table;

Donde:
        |  significa o
        {} significa lista de opciones
        [] significa opcional
*/

-- Proyecta todas las columnas de la tabla
SELECT * 
  FROM departments;

-- proyecta los ID de departamentos
SELECT department_id 
  FROM employees;

-- proyecta los ID de departamentos luego de eliminar las duplicidades
SELECT DISTINCT department_id 
  FROM employees;
  
-- proyecta las columnas seleccionadas
SELECT employee_id, last_name, salary, hire_date  
  FROM employees;

-- Alias a las columnas para los encabezados
SELECT department_id AS id, department_name departamento 
  FROM departments;

-- Alias en columnas  
SELECT department_id AS "ID Departamento", department_name "Nombre Departamento" 
  FROM departments; 

-- Proyecci�n de expresiones. �til usar Alias
SELECT last_name "Apellido", salary "Salario", 
       salary * 1.10 AS "Salario Incrementado" 
  FROM employees;

-- Proyecci�n de expresiones (Jerarqu�a de operadores)
SELECT last_name, salary, 
       salary + 100 - 100 * 1.10 "Salario Modif."  
  FROM employees;

-- Proyecci�n de expresiones (Uso de par�ntesis)
SELECT last_name, salary, 
       (salary + 100) / (salary * 1.10) "Salario Modif." 
  FROM employees;

-- Cuidado con las expresiones aritm�ticas con valores NULL
SELECT last_name, salary, commission_pct,
       salary * commission_pct "Salario*Comisi�n"
  FROM employees;                                -- 

-- Concatenaci�n y literales
SELECT last_name, first_name, 
       last_name||', '||first_name AS "Apellido+Nombre" 
  FROM employees;
  
-- DUAL
/*
  DUAL: Es una tabla solo lectura del diccionario de datos que tiene un �nico 
  registro y una �nica columna con un �nico valor 'X'. Para hacer una proyecci�n 
  usando un SELECT Oracle requiere que se haga uso de una tabla. En caso de que 
  se desee proyectar informaci�n que no est� contenida en ninguna tabla, DUAL es 
  la opci�n.
*/
DESCRIBE dual -- Comando de SQL*Plus que permite ver la estructura de una tabla

DESC dual; -- Los comandos de SQL*Plus se pueden abreviar. Se muestra la 
           -- estructura de DUAL

SELECT * -- Muestro el contendio de la tabla DUAL
  FROM dual;

SELECT 'Hola mundo!' -- proyecta un literal haciendo uso de la tabla DUAL
  FROM dual;

SELECT 5800 * 200 -- proyecta una simple expresi�n aritm�tica
  FROM dual;

SELECT 5800 * 200 -- proyecta una simple expresi�n aritm�tica
  FROM employees
 WHERE ROWNUM = 1;
  
SELECT sysdate, user -- proyecta los valores retornados por dos funciones
  FROM dual;

SELECT 'He's a doctor...' -- esta instrucci�n da error ya que le falta cerrar 
  FROM dual;              -- un delimitador
  
SELECT q'$He's a doctor...$' -- q es usada para cambiar de delimitador. 
  FROM dual;                 -- Ahora el delimitador es [].
  
SELECT 'He''s a doctor...' -- Al colocar un ap�strofe seguido, sirve de 
  FROM dual;               -- delimitador de ESCAPE (no da error)
  
/*
Las instrucciones se estar�n creando y ejecutando usando como 
IDE (Integrated development environment) SQL Developer, herramienta 
desarrollada por Oracle y es gratis. Viene con el instalador de Oracle 
y no requiere de una instalaci�n. Consiste en una carpeta con los 
ejecutables y archivos necesarios.
*/
