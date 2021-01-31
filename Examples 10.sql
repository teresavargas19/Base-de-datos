-- Procedimientos & Funciones
-- * Bloques de programas nombrados
-- * Tambi�n llamados Subprogramas
-- * Se almacenan en la BD con un nombre 
-- * Se compilan una vez o si se realiza alg�n cambio
-- * Pueden ser invocados desde otros programas o aplicaciones
-- * Sintaxis [Procedure]:
--
-- CREATE [OR REPLACE] PROCEDURE procedure_name
-- [(argument1 [mode1] datatype1,
--   argument2 [mode2] datatype2, ...)]
-- IS|AS
-- procedure_body;
--
-- Donde:
--        procedure_name  ==> Nombre del procedimiento
--        argument        ==> Nombre dado al par�metro
--        mode            ==> Modo del argumento [IN (defecto) / OUT / IN OUT]
--        datatype        ==> Tipo de dato asociado al par�metro
--        procedure_body  ==> Bloque PL/SQL donde se construye el c�digo.
--                            Donde se implementa la l�gica del negocio.
DROP TABLE dept2;

CREATE TABLE dept2 AS 
SELECT * 
  FROM departments;
  
select * 
from dept2;

-- Creaci�n o actualizaci�n del procedimiento ADD_DEPT
-- No espera par�metros.
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE add_dept 
  IS
  v_dept_id dept2.department_id%TYPE;
  v_dept_name dept2.department_name%TYPE;
BEGIN
  v_dept_id := 280;
  v_dept_name := 'ST-Curriculum';
  INSERT INTO dept2(department_id,department_name)
  VALUES(v_dept_id,v_dept_name);
  DBMS_OUTPUT.PUT_LINE(' Inserted '|| SQL%ROWCOUNT ||' row ');
END;
/
show error

SELECT object_name,object_type 
  FROM user_objects -- Muestra informaci�n general de los objetos
 WHERE LOWER(object_name) IN ('dept2','add_dept'); 

SELECT * 
  FROM user_source  -- Muestra el c�digo del procedimiento
 WHERE name = 'ADD_DEPT';

select * 
from dept2 -- Revisar si el departamento 280 existe
where department_id = 280;

-- Invocando el procedimiento ADD_DEPT desde un bloque no nombrado
-- No se env�an par�metros porque el procedimiento no los espera.
SET SERVEROUTPUT ON
BEGIN
  add_dept;
END;
/

select department_id, department_name 
from dept2 -- Revisar que el registro se haya creado
where department_id = 280;

delete dept2
where department_id = 280; -- Elimina el departamento 280

-- Creaci�n o actualizaci�n del procedimiento ADD_DEPT
-- Espera dos par�metros de entrada (IN)
CREATE OR REPLACE PROCEDURE add_dept 
  (v_dept_id NUMBER, v_dept_name dept2.department_name%TYPE)
  IS
BEGIN
  INSERT INTO dept2(department_id,department_name)
  VALUES(v_dept_id,v_dept_name);
  DBMS_OUTPUT.PUT_LINE(' Inserted '|| SQL%ROWCOUNT ||' row ');
END;
/

select * 
from dept2 -- Revisar si el departamento 280 existe
where department_id = 280;

-- Invocando el procedimiento ADD_DEPT desde el ambiente
-- Se usan dos variables de sustituci�n como par�metros a
-- ser pasados al procedimiento.
-- Probar con los valores 280 y 'ST-Curriculum'
SET SERVEROUTPUT ON
SET VERIFY OFF
EXECUTE add_dept (&DEPT_ID, '&DEPT_NAME');

SELECT department_id, department_name
  FROM dept2
 WHERE department_id in (280,290); -- Revisar que el registro se haya creado

-- Creaci�n o actualizaci�n del procedimiento FIND_DEPT
-- Espera dos par�metros, el primero de entrada (IN) y
-- el segundo de salida (OUT)
CREATE OR REPLACE PROCEDURE find_dept 
  (v_dept_id NUMBER, v_dept_name OUT dept2.department_name%TYPE)
  IS
BEGIN
  SELECT department_name INTO v_dept_name
    FROM dept2
   WHERE department_id = v_dept_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Departamento no existe...');
    WHEN OTHERS THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Error buscando departamento...');
END;
/
show error

desc departments

-- Invocando el procedimiento FIND_DEPT desde un bloque no nombrado
-- El primer par�metros enviado es de entrada y en el segundo par�metro
-- se guardar� el valor que viene del segundo argumento del procedimiento.
-- Probar el procedimiento con los departamentos 20 y 400
SET SERVEROUTPUT ON
SET VERIFY OFF
DECLARE
  v_name dept2.department_name%TYPE;
BEGIN
  find_dept (&&ID, v_name);
  IF v_name = '-1' THEN 
     DBMS_OUTPUT.PUT_LINE('El subprograma report� una excepci�n');
  ELSE
     DBMS_OUTPUT.PUT_LINE('El departamento '||&ID||' es '||v_name);
  END IF;
END;
/
UNDEFINE ID

SET SERVEROUTPUT ON
variable v_name varchar2
EXECUTE find_dept (&&ID, :v_name);
UNDEFINE ID

-- Creaci�n o actualizaci�n del procedimiento FIND_DEPT
-- Espera dos par�metros, el primero de entrada y salida (IN OUT) y
-- el segundo de salida (OUT)
-- SE PRODUCE UN ERROR? POR QU�? ANALICE LA CAUSA
CREATE OR REPLACE PROCEDURE find_dept 
  (v_dept_id IN OUT NUMBER, v_dept_name OUT VARCHAR2(50))
  IS
BEGIN
  SELECT department_name INTO v_dept_name
    FROM dept2
   WHERE department_id = v_dept_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Departamento no existe...');
    WHEN OTHERS THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Error buscando departamento...');
END;
/
show error
desc user_source
select * from user_source
where name = 'FIND_DEPT';

-- Creaci�n o actualizaci�n del procedimiento FIND_DEPT
-- Espera dos par�metros, el primero de entrada y salida (IN OUT) y
-- el segundo de salida (OUT)
-- PROCEDURE ANTERIOR MEJORADO. ANALICE LA DIFERENCIA
CREATE OR REPLACE PROCEDURE find_dept 
  (v_dept_id IN OUT NUMBER, v_dept_name OUT VARCHAR2)
  IS
BEGIN
  SELECT department_name INTO v_dept_name
    FROM dept2
   WHERE department_id = v_dept_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Departamento no existe...');
    WHEN OTHERS THEN
      v_dept_name := '-1';
      DBMS_OUTPUT.PUT_LINE('Error buscando departamento...');
END;
/
show error

-- Eliminando el procedimiento de la BD
DROP PROCEDURE add_dept;
DROP PROCEDURE find_dept;

-- * Sintaxis [Function]:
--
-- CREATE [OR REPLACE] FUNCTION function_name
--  [(argument1 [mode1] datatype1,
--    argument2 [mode2] datatype2, ...)]
-- RETURN datatype
-- IS|AS
-- function_body;
-- 
-- Donde:
--        function_name   ==> Nombre de la funci�n
--        argument        ==> Nombre dado al par�metro
--        mode            ==> Modo del argumento (S�lo IN es permitido)
--        datatype        ==> Tipo de dato asociado al par�metro
--        RETURN datatype ==> Tipo de dato del valor retornado por la funci�n
--        function_body   ==> Bloque PL/SQL donde se construye el c�digo de la funci�n.

-- Creaci�n de la funci�n CHECK_SAL que retorna un valor BOOLEAN
CREATE OR REPLACE FUNCTION check_sal 
  (v_empno NUMBER) 
  RETURN BOOLEAN IS
  v_dept_id employees.department_id%TYPE;
  v_sal     employees.salary%TYPE;
  v_avg_sal employees.salary%TYPE;
BEGIN
  SELECT e.salary,e.department_id,b.salavg
    INTO v_sal,v_dept_id,v_avg_sal
    FROM employees e 
    JOIN (SELECT department_id, ROUND(AVG(salary)) salavg 
            FROM employees
           GROUP BY department_id) b
      ON (e.department_id = b.department_id)
   WHERE e.employee_id = v_empno;
  
  IF v_sal > v_avg_sal THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;  
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

SELECT object_name,object_type 
  FROM user_objects -- Muestra informaci�n general de los objetos
 WHERE LOWER(object_name) = 'check_sal'; 

SELECT * 
  FROM user_source  -- Muestra el c�digo de la funci�n
 WHERE LOWER(name) = 'check_sal';

-- Invocando la funci�n desde un bloque no nombrado
-- Probar la funci�n entrando los valores 100, 200 y 600
SET SERVEROUTPUT ON 
BEGIN
  IF (check_sal(&&valor) IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('The function returned NULL due to exception');
  ELSIF (check_sal(&valor)) THEN  
    DBMS_OUTPUT.PUT_LINE('Salary > average');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary <= average');
  END IF;
END;
/
UNDEFINE valor

-- Creando una funci�n pas�ndole un par�metro
CREATE OR REPLACE FUNCTION check_sal
  (p_empno employees.employee_id%TYPE) 
  RETURN BOOLEAN IS
  v_dept_id employees.department_id%TYPE;
  v_sal     employees.salary%TYPE;
  v_avg_sal employees.salary%TYPE;
BEGIN
  SELECT e.salary,e.department_id,b.salavg
    INTO v_sal,v_dept_id,v_avg_sal
    FROM employees e 
    JOIN (SELECT department_id, ROUND(AVG(salary)) salavg 
            FROM employees
           GROUP BY department_id) b
      ON (e.department_id = b.department_id)
   WHERE e.employee_id = p_empno;
  
  IF v_sal > v_avg_sal THEN
    RETURN TRUE;
  ELSE
    RETURN FALSE;  
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN NULL;
END;
/

-- Invocando la funci�n pas�ndole par�metro
SET SERVEROUTPUT ON
BEGIN
  DBMS_OUTPUT.PUT_LINE('Checking for employee with id 205');
  IF (check_sal(205) IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('The function returned NULL due to exception');
  ELSIF (check_sal(205)) THEN  
    DBMS_OUTPUT.PUT_LINE('Salary > average');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary <= average');
  END IF;

  DBMS_OUTPUT.PUT_LINE('Checking for employee with id 70');
  IF (check_sal(70) IS NULL) THEN
    DBMS_OUTPUT.PUT_LINE('The function returned NULL due to exception');
  ELSIF (check_sal(70)) THEN  
    DBMS_OUTPUT.PUT_LINE('Salary > average');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Salary <= average');
  END IF;
END;
/

-- Funci�n que permite identificar el nivel salarial de un empleado dado un salario
CREATE OR REPLACE FUNCTION find_grade
   (v_salary NUMBER) 
   RETURN CHAR IS
   v_grade job_grades.grade_level%TYPE; -- Variable que se retornar� con el nivel salarial
BEGIN
   SELECT grade_level INTO v_grade -- Selecciono el nivel salarial de la tabla
     FROM job_grades               -- JOB_GRADES y lo almaceno en la variable V_GRADE
    WHERE v_salary BETWEEN lowest_sal AND highest_sal;
   RETURN v_grade; -- Retorno al entorno que llam� la funci�n el valor guardado en V_GRADE
END;
/
show error

-- Instrucci�n de SQL que consulta datos del empleado y su nivel salarial
-- Para conseguir el nivel salarial invoca la funci�n FIND_GRADE
select employee_id, last_name, job_id, salary, find_grade(salary) AS grade 
  from employees 
 order by grade;
 
select * from job_grades;

desc employees

insert into employees values (998,'Joseph','Puig','jpuig',null,sysdate,'IT_PROG',
100,null,100,90);

-- Busca los empleados que est�n en una posici�n dada.
-- La posici�n se recibe como par�metro.
set serveroutput on;
create or replace procedure busca_valor
   (job_id_in IN employees.job_id%TYPE) IS
  CURSOR find_emp_cur IS 
  select * from employees
   where job_id like job_id_in;
  find_emp_rec find_emp_cur%ROWTYPE;
BEGIN
   dbms_output.enable(100000);
   OPEN find_emp_cur;
   LOOP
      FETCH find_emp_cur INTO find_emp_rec;
      EXIT WHEN find_emp_cur%NOTFOUND;
      dbms_output.put_line('Nombre del Empleado: '||find_emp_rec.last_name||
                           ' *** T�tulo del puesto: '||find_emp_rec.job_id);
   END LOOP;
   CLOSE find_emp_cur;
END busca_valor;
/

-- Se ejecuta el procedimiento BUSCA_VALOR pasando un valor como
-- par�metro.
undefine id
SET SERVEROUTPUT ON
execute busca_valor('%&id%');

-- Eliminando una funci�n de la BD
DROP FUNCTION check_sal;
DROP FUNCTION find_grade;