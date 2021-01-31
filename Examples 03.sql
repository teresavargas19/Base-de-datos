/*
-- Las variables son:
-- (1) Declaradas y de manera opcional inicializadas en la sección declarativa.
-- (2) Usadas y se le puede asignar valor en la sección ejecutable.
-- (3) Pasadas como parámetros a un programa PL/SQL.
-- (4) Almacenar la salida de un programa PL/SQL.
-- 
-- Sintaxis:
identifier [CONSTANT] datatype [NOT NULL]   
		[:= | DEFAULT expr];

donde
  identifier  es el nombre de la variable.
  CONSTANT    restringe la variable para que su valor no cambie. 
              La variable debe ser inicializada.
  datatype    es el tipo de dato escalar, compuesto, de referencia o LOB.
  NOT NULL    restringe la variable para que tenga un valor. 
              La variable debe ser inicializada.
  expr        es cualquier expresión PL/SQL [expresión literal, otra variable, 
              o expresión con operadores y funciones]
*/

SET SERVEROUTPUT ON
DECLARE
  v_hiredate		DATE;		
  v_deptno			NUMBER(2) NOT NULL := 10;
  v_location		VARCHAR2(13) := 'Atlanta';
  c_comm				CONSTANT NUMBER := 1400;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Valor de la fecha: '||v_hiredate||CHR(10)||
                       'Valor Variable Numérica: '||v_deptno||CHR(10)||
                       'Valor Variable Caracter: '||v_location||CHR(10)||
                       'Valor Constante: '||c_comm);
END;
/

-- Declarando e inicializando variables PL/SQL
SET SERVEROUTPUT ON
DECLARE
  v_myName VARCHAR2(20);
BEGIN
  DBMS_OUTPUT.PUT_LINE('Mi nombre es: '||v_myName); -- No hay valor asignado
  v_myName := 'John'; -- Inicialización en la sección ejecutable
  DBMS_OUTPUT.PUT_LINE('Mi nombre es: '||v_myName); -- Tiene un valor asignado
END;
/

-- Declarando e inicializando variables PL/SQL
SET SERVEROUTPUT ON
DECLARE
 v_myName VARCHAR2(20):= 'John'; -- Inicialización en la sección declarativa
BEGIN
 v_myName := 'Steven'; -- Asignación de otro valor
 DBMS_OUTPUT.PUT_LINE('Mi nombre es: '|| v_myName); -- Muestra último valor asignado
END; 
/

-- Delimitadores en literales cadena
SET SERVEROUTPUT ON
DECLARE
  v_event VARCHAR2(50);
BEGIN
  v_event  := q'!Father's day!'; -- Usando como delimitador el !
  DBMS_OUTPUT.PUT_LINE('Last Sunday in July is: '||v_event);
  v_event  := q'[Mother's day]'; -- Usando como delimitador el [
  DBMS_OUTPUT.PUT_LINE('Last Sunday in May is: '||v_event);
  v_event := 'Otra manera de mostrar el '' dentro del texto';
  DBMS_OUTPUT.PUT_LINE(v_event);  
END;
/

-- Tipos de variables:
-- Scalar     = Soportan un valor simple.
-- Reference  = Guarda valores, llamados punteros, que apuntan a 
--              un lugar de almacenamiento
-- Large Object (LOB) = Guarda valores, llamados localizadores, 
--                      que especifican el lugar de un objeto grande
--                      almacenado fuera de la tabla.
-- Composite  = Están disponibles usando variables PL/SQL del tipo
--              colección y registro.
-- No-PL/SQL  = Variables de ambiente (Host)
--
-- Scalar:
--  + Boolean --> TRUE, FALSE, NULL
--  + BLOB --> Binary Large Object [Imágenes]
--  + CLOB --> Character Large Object [Textos Largos]
--  + BFILE -> Binary File [Vídeo]
--  + etc.

-- Lineamientos al declarar variables PL/SQL
-- Evite usar nombres de columnas como identificadores
SET SERVEROUTPUT ON
DECLARE
  employee_id	NUMBER(6);
BEGIN
  SELECT employee_id
	  INTO employee_id
	  FROM employees
   WHERE last_name = 'Kochhar';
   DBMS_OUTPUT.PUT_LINE('El ID del empleado Kochhar es: '||employee_id);
END;
/

-- En el WHERE el servidor de Oracle trata el identificador como
-- una columna de la tabla y si no coincide, entonces trata el 
-- identificador como una variable de la sección declarativa 
SET SERVEROUTPUT ON
DECLARE
  employee_id	NUMBER(6) := 101;
  v_lname VARCHAR2(25);
BEGIN
  SELECT last_name
	  INTO v_lname
	  FROM employees
   WHERE employee_id = employee_id; -- Esto es equivalente a decir 1 = 1
   DBMS_OUTPUT.PUT_LINE('El apellido del empleado 101 es: '||v_lname);
END;
/

SET SERVEROUTPUT ON
DECLARE
  v_id	NUMBER(6) := 101;
  v_lname VARCHAR2(25);
BEGIN
  SELECT last_name
	  INTO v_lname
	  FROM employees
   WHERE employee_id = v_id; -- Esto es equivalente a decir 1 = 1
   DBMS_OUTPUT.PUT_LINE('El apellido del empleado 101 es: '||v_lname);
END;
/

-- Declarando variables escalares
-- Las variables tipo Boolean no se imprimen
SET SERVEROUTPUT ON
DECLARE
  v_emp_job				  VARCHAR2(9);
  v_count_loop	   	BINARY_INTEGER := 0;
  v_dept_total_sal	NUMBER(9,2) := 0;
  v_orderdate		    DATE := SYSDATE + 7;
  c_tax_rate			  CONSTANT NUMBER(3,2) := 8.25;
  v_valid			      BOOLEAN NOT NULL := TRUE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(v_emp_job);
  DBMS_OUTPUT.PUT_LINE(v_count_loop);
  DBMS_OUTPUT.PUT_LINE(v_dept_total_sal);
  DBMS_OUTPUT.PUT_LINE(v_orderdate);
  DBMS_OUTPUT.PUT_LINE(c_tax_rate);
--  DBMS_OUTPUT.PUT_LINE(v_valid);
END;
/

-- Atributo %TYPE
-- Es usado para declarar una variable de acuerdo a:
--  + La definición de una columna de una tabla
--  + Otra variable declarada
-- 
-- Es prefijada con:
--  + El nombre de la tabla y la columna
--  + El nombre de la variable declarada
--
-- Sintaxis:
--    identifier		table.column_name%TYPE;
--    identifier    variable_name%TYPE;

SET SERVEROUTPUT ON
DECLARE
  v_id  employees.employee_id%TYPE; -- De acuerdo a una columna de una tabla
  v_code  v_id%TYPE; -- De acuerdo a una variable declarada
BEGIN
  SELECT employee_id INTO v_id
    FROM employees
   WHERE last_name = 'King' 
     AND first_name = 'Steven';
  v_code := v_id;
  DBMS_OUTPUT.PUT_LINE('Id del empleado Steven King: '||v_code);
END;
/

-- Variables de enlace [Bind Variables]
-- * Son creadas en el ambiente
-- * Se les llama también variables del lenguaje [Host Variables]
-- * Se crean con VARIABLE
-- * Se usan en instrucciones SQL y bloques PL/SQL
-- * Se acceden aún después de haber ejecutado el bloque PL/SQL
-- * Son referenciadas colocando dos puntos delante de la variable
-- * Su valor se muestra usando el comando PRINT

VARIABLE b_emp_salary NUMBER
BEGIN
  SELECT salary 
    INTO :b_emp_salary 
    FROM employees 
   WHERE employee_id = 178;  
END;
/
PRINT b_emp_salary
SELECT first_name, last_name
  FROM employees 
 WHERE salary = :b_emp_salary;

-- Uso del comando AUTOPRINT
VARIABLE b_emp_salary NUMBER
SET AUTOPRINT ON -- Auto imprime el valor de la variable de enlace
BEGIN
  SELECT salary 
    INTO :b_emp_salary 
    FROM employees 
   WHERE employee_id = 178;  
END;
/
PRINT b_emp_salary

SET DEFINE OFF
