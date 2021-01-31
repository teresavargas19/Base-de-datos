DROP TABLE retired_emps;

CREATE TABLE retired_emps
AS SELECT employee_id, last_name, job_id, manager_id, 
 hire_date, hire_date AS leave_date, salary, commission_pct,
 department_id FROM employees where
 rownum < 1;
 
desc retired_emps

SELECT *
  FROM retired_emps;

SET SERVEROUTPUT ON
DECLARE
  v_employee_number number:= 124;
  v_emp_rec retired_emps%ROWTYPE; -- Variable record
BEGIN
 SELECT employee_id, last_name, job_id, manager_id, 
 hire_date, hire_date, salary, commission_pct,
 department_id INTO v_emp_rec FROM employees
 WHERE  employee_id = v_employee_number;
 INSERT INTO retired_emps VALUES v_emp_rec;
 DBMS_OUTPUT.PUT_LINE('Registros insertado: '||SQL%ROWCOUNT);
 UPDATE retired_emps
    SET leave_date = sysdate
  WHERE employee_id = v_employee_number;
  DBMS_OUTPUT.PUT_LINE('Registros actualizados: '||SQL%ROWCOUNT);
END;
/
SELECT * 
  FROM retired_emps;


SET SERVEROUTPUT ON
DECLARE
   TYPE t_city IS RECORD (v_country countries%ROWTYPE); -- Creación de un tipo de dato RECORD
   v_mycountry t_city; -- Le asigna el tipo de dato RECORD a una variable
   CURSOR cur_country IS
   SELECT * FROM countries;
BEGIN
   FOR v_mycountry IN cur_country LOOP
      IF REGEXP_INSTR(v_mycountry.country_name,'^[AEIOU]') = 1 THEN -- Busca ciudades que inicien con una vocal
         DBMS_OUTPUT.PUT_LINE('Esta ciudad inicia con vocal: '||v_mycountry.country_name);
      ELSE
         DBMS_OUTPUT.PUT_LINE('Esta ciudad inicia con consonante: '||v_mycountry.country_name);
      END IF;
      IF REGEXP_INSTR(UPPER(v_mycountry.country_name),'[IU]') >= 1 THEN -- Busca ciudades con vocales débiles
         DBMS_OUTPUT.PUT_LINE('Esta ciudad tiene vocales débiles: '||v_mycountry.country_name||chr(10));
      ELSE
         DBMS_OUTPUT.PUT_LINE('Esta ciudad no tiene vocales débiles: '||v_mycountry.country_name||chr(10));
      END IF;      
   END LOOP;
END;
/

SET SERVEROUTPUT ON
DECLARE
   TYPE emp_table_type IS TABLE OF -- Creacion de un tipo de dato asociativo [INDEX BY]
      employees.last_name%TYPE INDEX BY PLS_INTEGER;
   my_emp_table emp_table_type; -- Le asigna el tipo de dato asociativo a una variable
BEGIN
   FOR i IN 100..104 LOOP
      SELECT last_name INTO my_emp_table(i) -- Llena la variable asociativa con apellido del empleado
        FROM employees
       WHERE employee_id = i;
   END LOOP;

   FOR i IN 100..104 LOOP
      DBMS_OUTPUT.PUT_LINE('Empleado '||i||': '||my_emp_table(i)); -- Muestra contenido de la variable asociativa
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('--------------');
   
   FOR i IN my_emp_table.FIRST..my_emp_table.LAST LOOP
      IF REGEXP_LIKE(my_emp_table(i),'([aeiou])\1','i') THEN -- Busca apellidos que tenga dos vocales juntas
         my_emp_table.DELETE(i); -- Elimina un registro de la variable asociativa
      END IF;
   END LOOP;
   FOR i IN my_emp_table.FIRST..my_emp_table.LAST LOOP -- Ciclo para leer la variable asociativa desde el primer (FIRST) elemento activo hasta el ultimo (LAST)
      IF my_emp_table.EXISTS(i) THEN -- Valida que el elemento exista en la variable asociativa
         DBMS_OUTPUT.PUT_LINE('Empleado '||i||': '||my_emp_table(i));
      ELSE
         DBMS_OUTPUT.PUT_LINE('Empleado '||i||' no existe');
      END IF;
   END LOOP;
   DBMS_OUTPUT.PUT_LINE('Empleado 102: '||my_emp_table(102));
END; 
/

SET SERVEROUTPUT ON
DECLARE
   TYPE dept_type IS VARRAY(10) OF VARCHAR2(25); -- Declaración de un tipo de dato VARRAY de tamaño 45
   v_deptemp dept_type; -- Asigna el tipo de datos VARRAY a una variable
   v_dept departments.department_name%TYPE;
BEGIN
   SELECT department_name 
     INTO v_dept
     FROM departments
    WHERE department_id = 60;
    
   SELECT last_name BULK COLLECT INTO v_deptemp -- Llena todos los elementos que vienen en el SELECT dentro de la variable VARRAY
     FROM employees
    WHERE department_id = 60;
   DBMS_OUTPUT.PUT_LINE('Departamento: '||v_dept);
   FOR i IN 1..v_deptemp.LAST LOOP -- Ciclo FOR para mostrar todos los elementos del arreglo.
      DBMS_OUTPUT.PUT_LINE('*** Empleado: '||v_deptemp(i)); -- Se necesita un sub-índice para referenciar un elemento dentro del arreglo
   END LOOP;
END;
/