-- Objetos de base de datos
-- Vista: 
--    * Presenta un subconjunto lógico o combinaciones de datos.
--    * Es una tabla lógica a partir de una tabla u otra vista.
--    * No contiene datos, sin embargo es como una ventada a través de la cual los datos
--      de tablas pueden ser vistos o cambiados.
--    * A las tablas usadas para crear la vista se les conoce con el nombre de tablas base.
--    * La vista es almacenada en el diccionario de datos como una instrucción SELECT.
-- Ventajas:
--    * Restringe el acceso a los datos ya que la vista despliega columnas seleccionadas de la tabla.
--    * Hace que consultas complicadas se puedan correr a través de consultas simples.
--    * Provee la independencia de los datos para usuarios y aplicaciones. Una vista puede ser usada
--      para recuperar datos de varias tablas.
--    * Provee acceso a los datos de acuerdo a criterios particulares.
-- Vistas simples y complejas - diferencias.
-- CREATE [OR REPLACE] [FORCE|NOFORCE] VIEW view
--   [(alias[, alias]...)]
-- AS subquery
-- [WITH CHECK OPTION [CONSTRAINT constraint]]
-- [WITH READ ONLY [CONSTRAINT constraint]];
-- 
-- OR REPLACE		        Recrea la vista si existe.
-- FORCE		            Crea la vista ya sea que la tabla base exista o no.
-- NOFORCE		          Crea la vista sólo si existe la tabla base [opción defecto].
-- view		              Es el nombre de la vista.
-- alias		            Especifica los nombres de las expresiones seleccionadas por el query de la vista.
-- subquery		          Es una instrucción SELECT.
-- WITH CHECK OPTION		Restringe que solamente las filas a las que la vista tiene acceso
--                      puedan ser insertadas o actualizadas.
-- constraint		        Es el nombre asignado a la restricción CHECK OPTION o READ ONLY.
-- WITH READ ONLY		    Asegura que ninguna operación DML sea realizada usando la vista.
DROP VIEW empvu80;

CREATE OR REPLACE VIEW empvu80 AS
SELECT employee_id, last_name, salary
  FROM employees
 WHERE department_id = 80;

DESC empvu80;

SELECT *
  FROM empvu80;
  
SELECT last_name, salary
  FROM empvu80
 WHERE salary > 8000
 ORDER BY salary desc;

CREATE VIEW empvu80 AS -- Si la vista existe da un error
SELECT employee_id, last_name, salary
  FROM employees
 WHERE department_id IN (50,80);
 
CREATE OR REPLACE VIEW empvu80 AS -- Si la vista no existe la crea, pero si existe la actualiza
SELECT employee_id, last_name, salary, department_id
  FROM employees
 WHERE department_id IN (50,80);

SELECT *
  FROM empvu80;

DESC empvu80

CREATE OR REPLACE VIEW salvu50 AS
SELECT employee_id ID_NUMBER, last_name NAME, -- Asigna ALIAS a las columnas en el SELECT
       salary*12 ANN_SALARY 
  FROM employees
 WHERE department_id = 50;

DESC salvu50

SELECT *
  FROM salvu50;
  
CREATE OR REPLACE VIEW empvu80
  (id_number, name, sal, department_id) AS -- Asigna ALIAS a las columnas en el CREATE
SELECT employee_id, 
       first_name || ' ' || last_name, 
       salary, department_id
  FROM employees
 WHERE department_id IN (50,80);

DESC empvu80

-- Realizando operaciones DML
SELECT *
  FROM empvu80;
  
select *
from empvu80
where id_number = 176;

select employee_id, salary
  from employees
where employee_id = 176;  

UPDATE empvu80
   SET sal = sal * 1.05
 WHERE id_number = 176;
 
SELECT salary,department_id -- $9,030
  FROM employees
 WHERE employee_id = 176;  

SELECT *
  FROM empvu80
 WHERE id_number = 176;

alter trigger UPDATE_JOB_HISTORY disable;

UPDATE empvu80 -- Error?
   SET department_id = 999
 WHERE id_number = 176;
 
select *
from departments
where department_id = 90;

UPDATE empvu80 -- No da Error;
   SET department_id = 90
 WHERE id_number = 176;
 
SELECT * 
  FROM empvu80
 WHERE id_number = 176; -- Por qué ahora no encuentra al empleado 176?
 
UPDATE employees
   SET department_id = 80 -- Se regresa al empleado 176 al departamento 80 
 WHERE employee_id = 176; -- en la tabla base.

SELECT *
  FROM empvu80
 WHERE id_number = 176;

UPDATE empvu80 -- No da Error;
   SET department_id = 50
 WHERE id_number = 176;
 
SELECT * 
  FROM empvu80
 WHERE id_number = 176; -- Por qué ahora encuentro al empleado 176?

CREATE OR REPLACE VIEW empvu80
  (id_number, name, sal, department_id) AS
SELECT employee_id, 
       first_name || ' ' || last_name, 
       salary, department_id
  FROM employees
 WHERE department_id IN (50,80)
  WITH CHECK OPTION;

update employees set department_ID = 80
where employee_id = 176;

SELECT * 
  FROM empvu80
  WHERE id_number = 176;

UPDATE empvu80 -- Error? Interpretarlo
   SET department_id = 90
 WHERE id_number = 176;

UPDATE empvu80 -- No da Error? Por qué?
   SET department_id = 50
 WHERE id_number = 176;

UPDATE empvu80 -- No da error. Por qué?
   SET sal = sal * 1.05
 WHERE id_number = 176;

CREATE OR REPLACE VIEW empvu80
  (id_number, name, sal, department_id) AS
SELECT employee_id, 
       first_name || ' ' || last_name, 
       salary, department_id
  FROM employees
 WHERE department_id = 80
  WITH READ ONLY;

UPDATE empvu80 -- Error? Interpretar.
   SET sal = sal * 1.05
 WHERE id_number = 176;
 
UPDATE empvu80 -- No da Error? Por qué?
   SET department_id = 50
 WHERE id_number = 176;

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

-- Creando una vista compleja
CREATE OR REPLACE VIEW hr_data AS
SELECT e.employee_id, e.last_name, e.salary,
       d.department_name,
       l.street_address, l.city,
       c.country_name,
       r.region_name,
       j.job_title,
       jg.grade_level
  FROM employees e
  JOIN departments d ON (e.department_id = d.department_id)
  JOIN locations l ON (d.location_id = l.location_id)
  JOIN countries c ON (l.country_id = c.country_id)
  JOIN regions r ON (c.region_id = r.region_id)
  JOIN jobs j ON (e.job_id = j.job_id)
  JOIN job_grades jg ON e.salary BETWEEN jg.lowest_sal AND jg.highest_sal;

DESC hr_data

SELECT * 
  FROM hr_data;

SELECT last_name, country_name
  FROM hr_data
 WHERE street_address like '%Centre%';

-- DROP VIEW view;
DROP VIEW salvu50; -- Eliminar vista salvu50

CREATE VIEW jobgrades_vu
AS select * from job_grades;

select *
from jobgrades_vu;

drop table job_grades;



-- Consultado el diccionario de datos para ver información acerca de las vistas
SELECT *
  FROM user_views
 WHERE view_name = 'HR_DATA';

-- Revisar las reglas al ejecutar operaciones de DML a través de una vista

-- Objetos de base de datos
-- Secuencias: 
--    * Genera números únicos automáticamente.
--    * Se puede compartir.
--    * Puede usarse para crear valores de una llave primaria.
--    * Reemplaza código de programación.
--    * Acelera la eficiencia al acceder valores de secuencia en memoria.
-- CREATE SEQUENCE sequence
--       [INCREMENT BY n]
--       [START WITH n]
--       [{MAXVALUE n | NOMAXVALUE}]
--       [{MINVALUE n | NOMINVALUE}]
--       [{CYCLE | NOCYCLE}]
--       [{CACHE n | NOCACHE}];
--
-- sequence		        Nombre del generador de secuencia.
-- INCREMENT BY n		  Especifica el intervalo entre secuencias, donde n es un entero.
--                    Si se omite, la secuencia se incrementa en 1.
-- START WITH n		    Especifica la primera secuencia a ser generada.
--                    Si se omite, la secuencia inicia en 1.
-- MAXVALUE n		      Especifica el valor máximo que alcanza una secuencia.
-- NOMAXVALUE		      Especifica un valor máximo de 10^27 para una secuencia ascendente y -1
--                    si la secuencia es descendente. Esta es la opción defecto.
-- MINVALUE n		      Especifica el valor mínimo de la secuencia.
-- NOMINVALUE		      Especifica un valor mínimo de 1 para una secuencia ascendente y –(10^26) 
--                    en una secuencia descendente. Esta es la opción defecto.
-- CYCLE | NOCYCLE	  Especifica si la secuencia continuará generando valores después de haber
--                    alcanzado su valor máximo o mínimo. NOCYCLE es la opción defecto.
-- CACHE n | NOCACHE	Especifica cuántos valores se asignarán y mantendrán en memoria.
--                    Por defecto Oracle asigna 20 valores.
DROP SEQUENCE dept_deptid_seq;
CREATE SEQUENCE dept_deptid_seq
       INCREMENT BY 5
       START WITH 5
       MAXVALUE 40
       NOCACHE
       NOCYCLE;
       
SELECT dept_deptid_seq.CURRVAL -- Error? Interpretar
  FROM dual;
  
SELECT dept_deptid_seq.NEXTVAL
  FROM dual;

DROP SEQUENCE dept_deptid_seq;
CREATE SEQUENCE dept_deptid_seq
       INCREMENT BY 5
       START WITH 5
       MAXVALUE 20
       NOCACHE
       CYCLE;

SELECT dept_deptid_seq.NEXTVAL -- Repetir hasta que llegue al máximo
  FROM dual;                   -- Cuando llega al máximo, a cuál valor regresa con el CYCLE?

DROP SEQUENCE dept_deptid_seq;
CREATE SEQUENCE dept_deptid_seq
       INCREMENT BY 5
       START WITH 5
       MINVALUE 5
--       MAXVALUE 20
       NOCACHE;
--       CYCLE;

SELECT dept_deptid_seq.NEXTVAL -- Repetir hasta que llegue al máximo.
  FROM dual;                   -- Cuando llega al máximo, a cuál valor regresa con el CYCLE?

DROP TABLE depts;
CREATE TABLE depts
(
 id NUMBER(10) CONSTRAINT depts_id_pk PRIMARY KEY
);

INSERT INTO depts (id)
VALUES (dept_deptid_seq.NEXTVAL);

SELECT *
  FROM depts;
  


-- Consultando el diccionario de datos para ver información acerca de las secuencias
SELECT *
  FROM user_sequences
 WHERE lower(sequence_name) = 'dept_deptid_seq';
  
-- Objetos de base de datos
-- Índices: 
--    * Útil cuando se quiere rapidez para recuperar filas usando punteros.
--    * Reduce I/O al disco al usar un método de ruta de acceso rápido para
--      localizar datos rápidamente.
--    * Es independiente de la tabla que indexa.
--    * Es usada y mantenida automáticamente por Oracle.
--    * Si una tabla no tiene índice, Oracle hace una lectura completa de la tabla.
--
-- Cómo se crean los índices?
--    * Automáticamente por el servidor de Oracle cuando se crea una Llave Primaria o una llave única (UNIQUE).
--    * Manualmente por el usuario para mejorar el rendimiento de las consultas.
-- CREATE INDEX index
--     ON table (column[, column]...);
CREATE INDEX emp_last_name_idx
    ON employees(last_name);
    
    
select * from employees where last_name = 'King';
    
-- DROP INDEX index;
-- Elimina el índice del diccionario de datos.
-- Se debe ser dueño del índice y tener el privilegio DROP ANY INDEX.
DROP INDEX emp_last_name_idx;

-- Consultando el diccionario de datos para ver información acerca de los índices
SELECT *
  FROM user_indexes -- No me indica cuál columna ha sido indexada
 WHERE lower(index_name) = 'emp_last_name_idx';

SELECT *
  FROM user_ind_columns -- Me indica cuál columna ha sido indexada
 WHERE lower(index_name) = 'emp_last_name_idx';
 
select *
from employees
where rownum < 11;

-- Revisar los lineamientos al crear un índice

-- Objetos de base de datos
-- Sinónimos:
--    * Pueden ser públicos o privados (defecto).
--    * Se usan para darle un nombre alterno a un objeto.
--    * Simplifica hacer referencia a objetos con nombres largos.
-- CREATE [ OR REPLACE ] [ PUBLIC ] SYNONYM
--    [ schema. ]synonym 
--    FOR [ schema. ]object [ @ dblink ] ;
-- OR REPLACE Modifica el sinónimo.
-- PUBLIC	    Crea un sinónimo accedido por todos los usuarios
-- synonym	  Nombre del sinónimo a ser creado.
-- object		  Identifica el objeto para el cual se crea el sinónimo.

DROP SYNONYM emps;

CREATE SYNONYM emps -- Crea sinónimo privado y sólo puede ser usado
   FOR employees;  -- por el usuario HR

SELECT e.*, d.department_name
FROM emps e join departments d on (e.department_id = d.department_id)
where last_name = 'King'
;

CREATE PUBLIC SYNONYM emps -- Crea sinónimo público y puede ser usado por cualquier usuario
   FOR employees;  

SELECT *
  FROM emps
 WHERE employee_id = 198;

SELECT *
  FROM employees;
  
CREATE OR REPLACE PUBLIC SYNONYM empleados -- Crea sinónimo público y puede ser usado
   FOR employees;                          -- por todos los usuarios conectados a la BD

-- Crear nuevo usuario (conectado como SYSTEM)
DROP USER ora1;
CREATE USER ora1 IDENTIFIED BY ora1;
GRANT CONNECT, RESOURCE TO ora1;

-- Conectarse como ORA1
SELECT *          -- ora1 no tiene privilegios para leer la tabla EMPLOYEES
  FROM empleados; -- a la que el sinónimo empleados hace referencia.
  
GRANT CREATE PUBLIC SYNONYM TO hr;

GRANT CREATE SYNONYM TO ora1;

-- Dar privilegio de SELECT al usuario ORA1 (conectado como HR)
GRANT SELECT ON employees TO ora1;

-- Conectarse como ORA1
SELECT *
  FROM empleados; -- Ahora ORA1 puede usar el sinónimo teniendo privilegios para acceder a EMPLOYEES

-- Conectarse como HR
DROP SYNONYM emps;

DROP SYNONYM empleados; -- Error? Interpretar.

DROP PUBLIC SYNONYM empleados; -- Error? Interpretar.

-- Para eliminar un sinónimo privado:
-- (1) Debe estar creado en tu esquema.
-- (2) Debes tener el privilegio DROP ANY SYNONYM
--
-- Para eliminar un sinónimo público:
-- (1) Debes tener el privilegio DROP PUBLIC SYNONYM

-- Dar privilegio para eliminar sinónimos públicos a HR (conectado como SYSTEM)
GRANT DROP PUBLIC SYNONYM TO hr;
GRANT DROP PUBLIC SYNONYM TO ora1;

-- Conectarse como HR
DROP PUBLIC SYNONYM empleados;



-- Consultando el diccionario de datos para ver información acerca de los sinónimos

SELECT *
  FROM all_synonyms
  where LOWER(synonym_name) = 'empleados'
  ;

SELECT *
  FROM all_synonyms;