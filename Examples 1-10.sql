-- Objetos de base de datos
-- Table: Unidad básica de almacenamiento; compuesta de filas.
-- Vista: Representa un subgrupo lógico de data de una o varias tablas.
-- Secuencia: Genera valores numéricos.
-- Index: Mejora el rendimiento de algunas consultas.
-- Synonym: Le da un nombre alterno a los objetos.

-- Reglas al nombrar objetos
-- Debe iniciar con una letra.
-- La longitud del nombre debe ser de 1 y no debe exceder 30 caracteres.
-- Caracteres válidos: A-Z, a-z, 0-9, _, $ y #.
-- No duplicar nombres de objetos dentro del mismo esquema.
-- No se debe usar palabras reservadas de Oracle.

-- CREATE TABLE [schema.]table
--    (column datatype [DEFAULT expr][, ...]);
-- datatype: representa el tipo de datos y el tamaño. [Revisar los tipos de datos disponibles en Oracle]
-- DEFAULT: se define el valor por defecto durante el INSERT.
DROP TABLE hire_dates;

CREATE TABLE hire_dates
(
 id NUMBER(6,2),
 hire_date DATE DEFAULT SYSDATE -- Si durante el INSERT no se especifica esta columna
);                              -- Se inserta la fecha del sistema por defecto.

DESC hire_dates

INSERT INTO hire_dates (id)
VALUES (15.9);

SELECT id,to_char(hire_date,'dd-mm-yyyy HH:MI:SS')
  FROM hire_dates;

-- Tipos de datos de fecha
-- TIMESTAMP *** Tipo Date con fracciones de segundos
-- TIMESTAMP WITH TIME ZONE *** Extensión de TIMESTAMP que incluye la zona horaria
-- TIMESTAMP WITH LOCAL TIME ZONE *** Extensión de TIMESTAMP que incluye la zona horaria local
-- INTERVAL YEAR TO MONTH *** Intervalo de año a mes
-- INTERVAL DAY TO SECOND *** Intervalo de día a segundo
DROP TABLE fechas;

CREATE TABLE fechas
(
 fecha DATE,
 fecha_TS TIMESTAMP(7),
 fecha_TSTZ TIMESTAMP WITH TIME ZONE,
 fecha_TSLTZ TIMESTAMP WITH LOCAL TIME ZONE,
 fecha_IYM INTERVAL YEAR (3) TO MONTH,
 fecha_IDS INTERVAL DAY (3) TO SECOND (3)
);

DESC fechas

INSERT INTO fechas
VALUES ('24-MAY-2014',sysdate,sysdate,sysdate,'112-2','20 8:53:10');

SELECT *
  FROM fechas;
  
create table valor_defecto
(ID number(3),
 Defecto date DEFAULT SYSDATE);
 
 desc valor_defecto
 
 
 insert into valor_defecto (id) values (1);
 
 select * from valor_defecto;

SELECT fecha_IYM AS "Intervalo Año-Mes", 
       to_char(SYSDATE,'dd-MON-YYYY') AS "FechaSistema", 
       to_char(SYSDATE+fecha_IYM,'dd-MON-YYYY') AS "FechaSistema+Intervalo"
  FROM fechas;
  
SELECT fecha_IDS AS "Intervalo Día-Segundo", 
       TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS') AS "FechaSistema",
       TO_CHAR(SYSDATE+fecha_IDS,'DD/MM/YYYY HH:MI:SS') AS "FechaSistema+Intervalo"
  FROM fechas;

SELECT fecha_tstz, fecha_tsltz
  FROM fechas;

alter session set time_zone='US/East-Indiana';

alter session set time_zone='-08:00';

SELECT fecha_tstz, fecha_tsltz
  FROM fechas;

alter session set time_zone='AMERICA/LA_PAZ';

SELECT  rowid,last_name from employees;

-- CONSTRAINTS: 
--    * Prevee que se inserten datos inválidos en las tablas.
--    * Prevee que se cree inconsistencia de datos.
-- Tipos de CONSTRAINTS:
--    * NOT NULL -> La columna no puede contener valores nulos.
--    * UNIQUE -> La columna debe contener valores únicos entre todas las filas.
--    * PRIMARY KEY -> Identifica de manera única cada fila de la tabla.
--    * FOREIGN KEY -> Establece una relación de referencia entre la columna y una columna de la tabla referenciada.
--    * CHECK -> Especifica una condición que debe ser conocida.
-- Lineamientos:
--    * Es conveniente darle un nombre al CONSTRAINT, de lo contrario Oracle le pondrá uno por defecto (SYS_Cn).
--    * Se puede crear un CONSTRAINT tanto al momento de crear la tabla como después de creada.
--    * Se puede crear un CONSTRAINT tanto a nivel de columna como a nivel de tabla.
--    * Los CONSTRAINTs pueden ser visualizados en el diccionario de datos.
-- Sintaxis:
-- CREATE TABLE [schema.]table
--      (column datatype [DEFAULT expr]
--      [column_constraint],       /* CONSTRAINT a nivel de columna*/
--      ...,
--      [table_constraint][,...]); /* CONSTRAINT a nivel de tabla*/
--
-- Creación a nivel de columna [column_constraint]
--    column [CONSTRAINT constraint_name] constraint_type,
--
-- Creación a nivel de tabla [table_constraint]
--    column,...
--      [CONSTRAINT constraint_name] constraint_type
--      (column, ...),
DROP TABLE temp_employees;

CREATE TABLE temp_employees
(
  employee_id    NUMBER(6) 
        CONSTRAINT temp_id_pk PRIMARY KEY -- Creación Llave Primaria (UNIQUE y NOT NULL implícito)
 ,first_name     VARCHAR2(20)
 ,last_name      VARCHAR2(25) 
        CONSTRAINT temp_last_name_nn NOT NULL -- Valores nulos no permitidos
 ,email          VARCHAR2(25)
        CONSTRAINT temp_email_nn NOT NULL -- Valores nulos no permitidos
        CONSTRAINT temp_email_uk UNIQUE -- Valores duplicados no permitidos (permite valores nulos)
 ,phone_number   VARCHAR2(20)
 ,hire_date      DATE         
        CONSTRAINT temp_hire_date_nn NOT NULL -- Valores nulos no permitidos
 ,job_id         VARCHAR2(10) 
        CONSTRAINT temp_job_nn NOT NULL -- Valores nulos no permitidos
 ,salary         NUMBER(8,2)
        CONSTRAINT temp_salary_ck CHECK (salary > 0) -- Salarios menores o igual a cero no permitidos
 ,commission_pct NUMBER(2,2)
 ,manager_id     NUMBER(6)
 ,department_id  NUMBER(4) -- Esta columna es relacionada con la misma columna 
                           -- de DEPARTMENTS para crear una integridad referencial
        --CONSTRAINT temp_dept_fk REFERENCES departments (department_id) -- Llave foránea.
-- , CONSTRAINT temp_job_fk FOREIGN KEY (job_id)
--   REFERENCES jobs (job_id)
-- , CONSTRAINT temp_mgr_fk FOREIGN KEY (manager_id)
--   REFERENCES temp_employees (employee_id)
   ,CONSTRAINT temp_dept_fk FOREIGN KEY (department_id)
   REFERENCES departments (department_id)
);

DESC temp_employees


INSERT INTO temp_employees
SELECT * FROM employees;
COMMIT;

UPDATE temp_employees       -- Se intentó violar restricción de integridad referencial.
   SET department_id = 55   -- Se intentó mover a todos los empleados del 
 WHERE department_id = 110; -- departamento 110 a un departamento inexistente.

SELECT *
  FROM departments
 WHERE department_id IN (55,110);
 
DELETE FROM departments    -- Se intentó violar restricción de integridad referencial.
 WHERE department_id = 60; -- Se intentó eliminar un departamento que tiene empleados.

SELECT *
  FROM employees
 WHERE department_id = 60; -- Lista los empleados que trabajan en el departamento 60.
 
-- Creando tablas usando subqueries
-- CREATE TABLE table
--	  [(column, column...)]
-- AS subquery;
DROP TABLE temp_departments;

CREATE TABLE temp_departments
  AS SELECT * FROM departments;
  
SELECT *
  FROM temp_departments;
  
DESC temp_departments

DROP TABLE dept80;

CREATE TABLE dept80
  AS SELECT employee_id, last_name, 
            salary*12 ANNSAL, 
            hire_date  
       FROM employees
      WHERE department_id = 80;

DESC dept80

SELECT *
  FROM dept80;

-- ALTER TABLE
--    * Añadir una columna
--    * Modificar una columna existente
--    * Definir valor defecto nueva columna
--    * Elimnar columna
-- Se ve en detalle en la unidad 2 del libro 2

-- DROP TABLE table_name;
-- Elimina los datos y la estructura de la tabla.
-- Se eliminan los índices.
-- Se eliminan los CONSTRAINTS.
-- No se le hace ROLLBACK.
DROP TABLE dept80;

DESC dept80;

-- Palabras claves con el CONSTRAINT FOREIGN KEY
-- FOREIGN KEY -> Define la columna en la tabla hijo a nivel de tabla.
-- REFERENCES -> Identifica la tabla y la columna en la tabla padre.
-- ON DELETE CASCADE -> Elimina las filas dependientes en la tabla hijo
--                      cuando una fila de la tabla padre es eliminada.
-- ON DELETE SET NULL -> Convierte los valores de la llave foránea a nulo.
select * from user_constraints where table_name = 'DEPT';

DROP TABLE dept;
CREATE TABLE dept
(
 id NUMBER(10) PRIMARY KEY
);

INSERT INTO dept
SELECT department_id
  FROM departments;

DROP TABLE emp;
CREATE TABLE emp
(
 id VARCHAR2(10),
 fid NUMBER(10),
     FOREIGN KEY (fid)
     REFERENCES dept(id)
     ON DELETE CASCADE
);

INSERT INTO emp
SELECT employee_id,department_id
  FROM employees;

select * from dept;
select * from emp
where fid = 50;

DELETE dept    -- Al eliminar el departamento 50, todos los empleados
WHERE id = 50; -- que pertenecen al mismo también son eliminados.

select * from dept 
WHERE id = 50;
select * from emp
 ORDER BY 2;

DROP TABLE emp; 
CREATE TABLE emp
(
 id VARCHAR2(10),
 fid NUMBER(10),
     FOREIGN KEY (fid)
     REFERENCES dept(id)
     ON DELETE SET NULL
);

DELETE dept;

INSERT INTO dept
SELECT department_id
  FROM departments;
  
INSERT INTO emp
SELECT employee_id,department_id
  FROM employees;

select * 
from dept
where id = 50;
select * 
from emp
where fid = 50;

DELETE dept     -- Al eliminar el departamento 50, todos los empleados
WHERE id = 50;  -- que pertenecen al mismo, la columna FK se le asigna NULO.

select * 
from dept
where id = 50;
select * 
from emp
where fid = 50;

select * 
from emp
where fid is null;


-- Consultando el diccionario de datos para conocer información acerca de las tablas
SELECT *
  FROM user_tables -- Muestra información de las tablas
 WHERE lower(table_name) IN ('employees');

SELECT *
  FROM user_tab_columns -- Muestra la estructura de las tablas
 WHERE lower(table_name) IN ('employees');

SELECT *
  FROM user_objects -- Muestra datos generales del objeto
 WHERE object_name = 'EMPLOYEES';
 
SELECT * 
  FROM user_tab_columns
 WHERE column_name = 'FIRST_NAME';
 
 
SELECT *
  FROM user_constraints -- Información general de las restricciones
 WHERE table_name = 'EMPLOYEES';

SELECT *
  FROM user_cons_columns -- Incluye las columnas afectadas por las restricciones
 WHERE table_name = 'EMPLOYEES';

SELECT uc.constraint_type, -- Consigo información sobre las restricciones referenciadas
       uc.constraint_name,
       uc.table_name,
       uc.r_constraint_name,
       ucc1.table_name ref_table_name,
       ucc.position,
       ucc.column_name,
       ucc1.column_name ref_column_name
  FROM user_constraints uc
  JOIN user_cons_columns ucc
    ON uc.table_name = ucc.table_name
   AND uc.constraint_name = ucc.constraint_name
  JOIN user_cons_columns ucc1
    ON uc.r_constraint_name = ucc1.constraint_name
   AND ucc.position = ucc1.position
 WHERE uc.constraint_type = 'R'
   AND uc.table_name = 'EMPLOYEES'
 ORDER BY uc.constraint_name, ucc.table_name, ucc.position;