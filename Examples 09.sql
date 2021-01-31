-- Manejo de excepciones

/*
El siguiente código PL/SQL generar un error, pero al no tener una excepción
el código aborta sin ser manejado apropiadamente. Se produce el siguiente
error:
  -- ORA-01422: exact fetch returns more than requested number of rows
*/
SET SERVEROUTPUT ON
DECLARE
  v_lname VARCHAR2(15);
BEGIN
  SELECT last_name INTO v_lname 
    FROM employees
   WHERE first_name='&&v_name'; 
  DBMS_OUTPUT.PUT_LINE ('&v_name'||'''s last name is: ' ||v_lname);
END;
/
UNDEFINE v_name

-- Código anterior manejado con excepciones
SET SERVEROUTPUT ON
DECLARE
  v_lname VARCHAR2(15);
BEGIN
  SELECT last_name INTO v_lname 
    FROM employees
   WHERE first_name='&&v_fname';
  DBMS_OUTPUT.PUT_LINE ('&v_fname'||'''s last name is: ' ||v_lname);
EXCEPTION
  WHEN TOO_MANY_ROWS THEN
     DBMS_OUTPUT.PUT_LINE('Se encontró más de un empleado con el nombre '||'&v_fname'||CHR(10)||
                          'Considere usar un cursor...');
  WHEN NO_DATA_FOUND THEN
     DBMS_OUTPUT.PUT_LINE('No existe ningún empleado con el nombre '||'&v_fname');
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('Error inesperado...');
END;
/
UNDEFINE v_fname


UNDEFINE id
SET VERIFY OFF
SET SERVEROUTPUT ON
DECLARE
   var_result NUMBER;
   v_id employees.employee_id%TYPE;
   v_name employees.last_name%TYPE;
BEGIN
   IF &&id = 1 THEN
      SELECT employee_id, last_name INTO v_id, v_name
        FROM employees
       WHERE department_id = 60;
   ELSIF &id = 2 THEN
      SELECT employee_id, last_name INTO v_id, v_name
        FROM employees
       WHERE department_id = 600;
   ELSE
      var_result := 'Jose';
   END IF;
EXCEPTION
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Hay más de un empleado en ese departamento... Use un cursor');
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('El departamento no tiene empleados...');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Se intentó asignar un valor caracter a una variable numérica');
      BEGIN
         INSERT INTO departments VALUES (60,'Temporal',100,1700);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            DBMS_OUTPUT.PUT_LINE('Ese departamento ya existe...');
         BEGIN
            var_result := 100/0;
         EXCEPTION
            WHEN ZERO_DIVIDE THEN
               DBMS_OUTPUT.PUT_LINE('Error - División por cero...');
         END;
      END;
END;
/

-- Non-Predefined Exceptions

SET SERVEROUTPUT ON
DECLARE
  e_insert_excep EXCEPTION;
  PRAGMA EXCEPTION_INIT(e_insert_excep, -01400);
BEGIN
  INSERT INTO departments (department_id, department_name) 
  VALUES (280, NULL);
EXCEPTION
  WHEN e_insert_excep THEN
    DBMS_OUTPUT.PUT_LINE('INSERT OPERATION FAILED ('||SQLCODE||')');
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

set verify off
DECLARE
e_name EXCEPTION;
BEGIN
  DELETE FROM employees
  WHERE  last_name = 'Pepe';
  IF SQL%NOTFOUND THEN 
     RAISE e_name;
  END IF;
  EXCEPTION  
     WHEN e_name THEN
        RAISE_APPLICATION_ERROR (-20999, 'This is not a valid last name');
END;
/

select * from employees where employee_id = 106;