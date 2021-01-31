--  SELECT	table1.column, table2.column
--    FROM	table1
--[NATURAL JOIN table2] |
--[   JOIN table2 USING (column_name)] |
--[   JOIN table2 ON (table1.column_name = table2.column_name)]|
--[LEFT|RIGHT|FULL OUTER JOIN table2 ON (table1.column_name = table2.column_name)]|
--[  CROSS JOIN table2];

-- NATURAL JOIN
-- Relaciona las tablas por las columnas que tengan el mismo nombre y mismo 
-- tipo de datos. No se requiere especificar los nombres de las columnas en 
-- la relación.
 SELECT employee_id, last_name, department_id, department_name
   FROM employees 
NATURAL JOIN departments;

 SELECT employee_id, e.last_name, d.department_id, d.department_name
   FROM employees e -- Da error. Por qué?
NATURAL JOIN departments d;

desc employees

desc departments
  
-- JOIN + USING
-- Debo especificar la columna por donde se establece la relación.
-- Los nombres de las columnas deben tener el mismo nombre, aunque difieran 
-- en el tipo de datos. 
-- No prefije la columna referenciada con el nombre de la tabla o ALIAS.
-- Útil cuando se quiere establecer la relación por una columna en particular 
-- y no por todas las columnas comunes.
-- Entre las tablas EMPLOYEES y DEPARTMENTS hay más de una columna común 
-- (cuáles son?)
SELECT employee_id, last_name, department_name -- Error?
  FROM employees 
  JOIN departments
 USING (departments.department_id);

SELECT employee_id, last_name, departments.department_id, department_name -- Error?
  FROM employees -- Error? YES
  JOIN departments
 USING (department_id);

SELECT employee_id, last_name, department_id, department_name,
       e.manager_id, d.manager_id  -- Error? NO
  FROM employees e
  JOIN departments d
 USING (department_id);

SELECT employee_id, last_name, department_id, department_name,
       manager_id -- Error? YES
  FROM employees 
  JOIN departments
 USING (department_id);
 
SELECT employee_id, last_name, department_id, department_name,
       e.manager_id -- Error? NO
  FROM employees e
  JOIN departments d
 USING (department_id);

SELECT employees.employee_id, employees.last_name, department_id, 
       departments.department_name
  FROM employees 
  JOIN departments
 USING (department_id);
 
 SELECT employee_id, last_name, department_id, department_name,
       manager_id -- Error?
  FROM employees 
  JOIN departments
 USING (department_id, manager_id);
  
-- JOIN table2 ON (table1.column_name = table2.column_name)
SELECT employee_id, last_name, departments.department_id, 
       department_name -- Error? YES
  FROM employees 
  JOIN departments
    ON (department_id = departments.department_id);

SELECT employee_id, last_name, department_id, department_name
  FROM employees e -- Error? YES
  JOIN departments d 
    ON (e.department_id = d.department_id);


SELECT employee_id, last_name, departments.department_id, 
       department_name
  FROM employees 
  JOIN departments
    ON (employees.department_id = departments.department_id);

SELECT e.employee_id, e.last_name, d.department_id, department_name
  FROM employees e -- Uso de ALIAS simplifica la consulta
  JOIN departments d -- Uso de ALIAS mejora el rendimiento de la consulta [usa menos memoria]
    ON (e.department_id = d.department_id);
     
-- SELF-JOIN usando la cláusula ON
-- Buscar el ID y nombre del empleado y ID y nombre del supervisor.
-- Esto aplica el método de recursividad
-- Se debe llamar la tabla dos veces y darle ALIAS diferentes.
-- El primer ALIAS se usará para buscar los datos del empleado.
-- El segundo ALIAS se usará para buscar los datos del supervisor.

select employee_id, last_name, manager_id
  from employees
 where employee_id = 201;
 
select employee_id, last_name, manager_id
  from employees
 where employee_id = 100;
 
DESC EMPLOYEES

SELECT e.employee_id AS "ID Emp.", e.last_name AS "Nombre Emp.", 
       s.employee_id AS "ID Sup.", s.last_name AS "Nombre Sup."
  FROM employees e -- Datos del empleado
  JOIN employees s -- Datos del supervisor
    ON (e.manager_id = s.employee_id)
  WHERE e.employee_id = 201
  order by e.employee_id;  
    
SELECT e.employee_id AS "ID Emp.", e.last_name AS "Nombre Emp.", e.manager_id
  FROM employees e -- Datos del empleado
 WHERE e.employee_id = 198;
 
SELECT s.employee_id AS "ID Sup.", s.last_name AS "Nombre Sup.", s.manager_id
  FROM employees s -- Datos del supervisor
 WHERE s.employee_id = 124;

-- Se pueden incluir múltiples consultas a un JOIN
SELECT employee_id, last_name, d.department_id, department_name
  FROM employees e
  JOIN departments d
    ON (e.department_id = d.department_id)
 WHERE e.job_id = 'ST_CLERK';

SELECT employee_id, last_name, d.department_id, department_name
  FROM employees e, departments d
 WHERE e.department_id = d.department_id
   AND e.job_id = 'ST_CLERK';
 
create table job_grades
(grade_level varchar2(3),
lowest_sal number,
highest_sal number);

insert into job_grades values('A',1000,2999);
insert into job_grades values('B',3000,5999);
insert into job_grades values('C',6000,9999);
insert into job_grades values('D',10000,14999);
insert into job_grades values('E',15000,24999);
insert into job_grades values('F',25000,40000);

select * from job_grades;

 -- Se pueden establecer más de dos relaciones
SELECT employee_id, last_name, job_title, grade_level, department_name, 
       city, c.country_name, r.region_name
  FROM employees e 
  JOIN departments d 
    ON (d.department_id = e.department_id)
  JOIN locations l 
    ON (d.location_id = l.location_id)
  JOIN countries c
    ON (l.country_id = c.country_id)
  JOIN regions r
    ON (c.region_id = r.region_id)
  JOIN job_grades jg
    ON (e.salary BETWEEN jg.lowest_sal AND jg.highest_sal)
  JOIN jobs j
    ON (e.job_id = j.job_id)
  ;

-- Nonequijoins usando BETWEEN
-- Se usa cuando no hay una relación directa entre dos tablas
-- En tal caso no se usa el operador de igual (=)
-- Usaremos las tablas EMPLOYEES y JOB_GRADES
SELECT *
  FROM job_grades;

SELECT e.last_name, e.salary, j.grade_level
  FROM employees e 
  JOIN job_grades j
    ON e.salary = j.lowest_sal;

SELECT e.last_name, e.salary, j.grade_level
  FROM employees e 
  JOIN job_grades j
    ON e.salary = j.highest_sal;
    
SELECT e.last_name, e.salary, j.grade
  FROM employees e 
  JOIN job_grades j
    ON e.salary BETWEEN j.lowest_sal AND j.highest_sal;

-- Outer Joins
-- Útil cuando en una relación hay registros que no coinciden 
-- y aún así queremos mostrarlos
--[LEFT|RIGHT|FULL OUTER JOIN table2 ON (table1.column_name = table2.column_name)]
SELECT EMPLOYEE_ID,LAST_NAME,FIRST_NAME, SALARY 
FROM EMPLOYEES 
WHERE DEPARTMENT_ID IS NULL;

SELECT department_id FROM departments
MINUS
SELECT department_id FROM employees;

SELECT e.last_name, e.first_name, e.department_id, d.department_name
  FROM   employees e JOIN departments d -- Muestra los empleados que están en un departamento +
    ON   (e.department_id = d.department_id)
  --WHERE EMPLOYEE_ID = 178
  ORDER BY 1;
  
SELECT e.last_name, e.first_name, e.department_id, d.department_name
  FROM   employees e LEFT OUTER JOIN departments d -- Muestra los empleados que están en un departamento +
    ON   (e.department_id = d.department_id)
--  WHERE EMPLOYEE_ID = 178
  ORDER BY 1;

SELECT e.last_name, e.department_id, d.department_name
  FROM   employees e LEFT /*OUTER*/ JOIN departments d -- Muestra los empleados que están en un departamento +
    ON   (e.department_id = d.department_id) ;     -- los empleados que no están en un departamento.

SELECT e.last_name, e.department_id, d.department_name
  FROM   employees e JOIN departments d -- Muestra los empleados que están en un departamento +
    ON   (e.department_id = d.department_id)
  ORDER BY 2;      -- los departamentos que no tienen empleados.
    
SELECT e.last_name, e.department_id, d.department_name
  FROM   employees e RIGHT OUTER JOIN departments d -- Muestra los empleados que están en un departamento +
    ON   (e.department_id = d.department_id) ;      -- los departamentos que no tienen empleados.

SELECT e.last_name, e.department_id, d.department_name -- Muestra los empleados que están en un departamento +
  FROM   employees e FULL OUTER JOIN departments d     -- los empleados que no están en un departamento + los
    ON   (e.department_id = d.department_id);          -- departamentos que no tienen empleados.

-- Producto cartesiano: 
-- Tiende a generar un gran número de filas, y el resultado no suele ser útil. 
-- Se debe siempre  incluir una condición de unión válida a menos que se tenga 
-- una necesidad específica para combinar todas las filas de todas las tablas. 
-- Son útiles para algunas pruebas en donde se necesita generar un gran número de 
-- filas para simular una cantidad razonable de datos.
-- CROSS JOIN permite crear un producto cartesiano.
SELECT COUNT(*)
  FROM employees; --107
  
SELECT COUNT(*)
  FROM departments; -- 27

-- 107 * 27 = 2889

SELECT last_name, department_name
  FROM employees            -- Combina todas las filas de empleados con las filas 
 CROSS JOIN departments;    -- de departamentos.

SELECT last_name, department_name
  FROM employees e, departments d, locations l
 WHERE e.department_id = d.department_id
       ;
 