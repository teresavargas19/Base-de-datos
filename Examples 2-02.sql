-- ALTER TABLE
-- 1) Permite adicionar una columna
-- 2) Modificar una columna existente
-- 3) Definirle un valor defecto a una columna nueva
-- 4) Eliminar una columna o ponerla en un estatus de no uso
-- 5) Añadir una restricción
-- Sintaxis para añadir una columna a una tabla
-- ALTER TABLE table
--   ADD	   (column datatype [DEFAULT expr]
--  		   [, column datatype]...);

-- Crea la tabla MYTABLE
CREATE TABLE PRUEBA2
(
 Columna1 VARCHAR2(5)
);
insert into prueba2 values('Supercalifragi');

DROP TABLE mytable;

CREATE TABLE mytable
(
  id  NUMBER(10),
  id2 NUMBER(10),
  id3 NUMBER(10),
  id4 NUMBER(10),
  id5 NUMBER(10),
  id6 NUMBER(10),
  id7 NUMBER(10)
);

desc mytable

-- Altera la tabla para añadirle dos columnas
ALTER TABLE mytable ADD 
  (name      VARCHAR2(30), 
   address   VARCHAR2(50) DEFAULT 'No Address',
   birthdate DATE
  );

INSERT INTO mytable (id,name,birthdate)
VALUES (100,'Leandro','25-OCT-67');

SELECT *
  FROM mytable;

-- Sintaxis para modificar el tamaño y el valor defect a una columna
-- ALTER TABLE table
-- MODIFY	   (column datatype [DEFAULT expr]
--  		   [, column datatype]...);

-- Modifica la columna NAME ampliando su tamaño
ALTER TABLE mytable
MODIFY name VARCHAR2(5);

ALTER TABLE mytable
MODIFY name VARCHAR2(20);

-- Sintaxis para eliminar una columna (una a la vez)
-- ALTER TABLE table
--  DROP COLUMN column;
ALTER TABLE mytable
 DROP COLUMN (id2,id3);

ALTER TABLE mytable
 DROP COLUMN (id2);

ALTER TABLE mytable
 DROP COLUMN id2;
 
DESC mytable;

-- Sintaxis para eliminar una o varias columnas
-- ALTER TABLE table
--  DROP (column1,...);
ALTER TABLE mytable
 DROP (id3,id4);

-- Sintaxis para poner una columna con estatus de no uso
-- Las columnas no se muestran en la estructura de la tabla,
-- sin embargo los datos y la columna ocupan espacio en la BD.
-- Formato (1) - Una o más columnas
-- ALTER TABLE	 <table_name>
--   SET UNUSED(<column_name>);
--
-- Formato (2) - Una columna a la vez
-- ALTER TABLE  <table_name>
--   SET UNUSED COLUMN <column_name>;

-- Altera la tabla MYTABLE y coloca la columna BIRTHDATE
-- en estado de no uso
ALTER TABLE mytable
  SET UNUSED COLUMN (id5, id6);

ALTER TABLE mytable
  SET UNUSED COLUMN (id5);

ALTER TABLE mytable
  SET UNUSED COLUMN id5;

ALTER TABLE mytable
  SET UNUSED (id6, id7);
  
DESC mytable

SELECT *
  FROM mytable;

-- Sintaxis para eliminar todas las columnas en estado de no uso
-- Las columnas y los datos son eliminados de la BD.
-- ALTER TABLE <table_name>
--  DROP UNUSED COLUMNS;

-- Elimina todas las columnas en estado de no uso de la tabla MYTABLE
ALTER TABLE mytable
 DROP UNUSED COLUMNS;

-- Sintaxis para añadir un CONSTRAINT a una tabla
-- ALTER TABLE <table_name>
--   ADD [CONSTRAINT <constraint_name>] 
--  type (<column_name>);
-- Donde:
--        table_name	    Nombre de la tabla
--        constraint_name	Nombre del constraint [opcional]
--        type		        Tipo de constraint (PK, FK, CK, UNIQUE)
--        column_name		  Es el nombre de la columna afectado por el constraint

-- Añade una restricción de llave foránea a la tabla MYTABLE
ALTER TABLE mytable
ADD CONSTRAINT myt_id_fk 
FOREIGN KEY(id) 
REFERENCES employees (employee_id);


-- DEFERRABLE or NOT DEFERRABLE 
-- INITIALLY DEFERRED or INITIALLY IMMEDIATE
SELECT *
  FROM departments
 WHERE department_id IN (40,45);
 
SELECT COUNT(*)
  FROM employees
 WHERE department_id = 40;
 
DROP TABLE dept2;
CREATE TABLE dept2 AS
SELECT * 
  FROM departments;
  
DROP TABLE emp2;
CREATE TABLE emp2 AS
SELECT *
  FROM employees;
  
SELECT *
  FROM dept2;
  
SELECT *
  FROM emp2;

ALTER TABLE dept2
  ADD CONSTRAINT dept2_id_pk 
PRIMARY KEY (department_id)
DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE emp2
  ADD CONSTRAINT emp2_did_fk 
FOREIGN KEY (department_id)
REFERENCES dept2 (department_id)
DEFERRABLE INITIALLY DEFERRED;

UPDATE dept2
   SET department_id = 45
 WHERE department_id = 40;
 
SET CONSTRAINTS dept2_id_pk IMMEDIATE;

SET CONSTRAINTS emp2_did_fk IMMEDIATE;

UPDATE emp2
   SET department_id = 45
 WHERE department_id = 40;
 
SET CONSTRAINTS emp2_did_fk IMMEDIATE;


-- Dropping a Constraint
SELECT *
  FROM user_constraints
 WHERE table_name IN ('DEPT2', 'EMP2');

ALTER TABLE dept2
DROP PRIMARY KEY CASCADE;

SELECT *
  FROM user_constraints
 WHERE table_name IN ('DEPT2', 'EMP2');
 
SELECT *
  FROM dept2;

SELECT *
  FROM emp2;

-- Cascading Constraints
DROP TABLE test1;
CREATE TABLE test1 
(
 pk NUMBER PRIMARY KEY,
 fk NUMBER,
 col1 NUMBER,
 col2 NUMBER,
 CONSTRAINT fk_constraint FOREIGN KEY (fk) REFERENCES test1,
 CONSTRAINT ck1 CHECK (pk > 0 and col1 > 0),
 CONSTRAINT ck2 CHECK (col2 > 0));

-- An error is returned for the following statements:
ALTER TABLE test1 DROP (pk);    -- pk is a parent key.
ALTER TABLE test1 DROP (col1);  -- col1 is referenced by the multicolumn 
						                    -- constraint, ck1.

ALTER TABLE test1 DROP COLUMN pk CASCADE CONSTRAINTS;

SELECT *
  FROM user_constraints
 WHERE table_name = 'TEST1';
 
-- Crea la tabla EMP2 a partir de la tabla EMPLOYEES
-- Copia la estructura de la tabla EMPLOYEES
-- Copia los datos de la tabla EMPLOYEES
-- Copia el constraint NOT NULL
DROP TABLE  emp2;

CREATE TABLE emp2 AS
SELECT *
  FROM employees;

SELECT COUNT(*) 
  FROM emp2;
  
select * from recyclebin;

-- Elimina la tabla EMP2 (estructura y datos)
DROP TABLE emp2;
DROP TABLE JOB_GRADES;

-- Describe la estructura de la tabla
DESC emp2

-- Revisa el diccionario de datos para mostrar la papelera de Oracle
-- Todo objeto borrado aparece en esta tabla del diccionario
SELECT original_name, operation, droptime 
  FROM recyclebin
 WHERE original_name in ('EMP2','JOB_GRADES');

DESC recyclebin


-- Recupera la tabla más reciente borrada (estructura y datos)  
FLASHBACK TABLE emp2 TO BEFORE DROP;
FLASHBACK TABLE job_grades TO BEFORE DROP;

select * from job_grades;

SELECT COUNT(*) 
  FROM emp2;

-- Al volver a consultar el RECYCLEBIN la tabla recuperada no se muestra
SELECT original_name, operation, droptime 
  FROM recyclebin
 WHERE original_name = 'EMP2';

PURGE recyclebin;

-- Borrar tabla de manera definitiva
DROP TABLE emp2 PURGE;

SELECT original_name, operation, droptime 
  FROM recyclebin;
