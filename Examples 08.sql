create table temp_employees as
select * from employees;

select * from temp_employees;

-- Connect as SYSTEM to create user USER1
CREATE USER user1 IDENTIFIED BY user1 ACCOUNT UNLOCK;
GRANT CONNECT, RESOURCE TO user1;

-- Connect as HR to grant privileges on TEMP_EMPLOYEES table to user USER1
GRANT SELECT,UPDATE ON employees TO user1;

-- Create a new session as USER1
-- Test Example 1 unnamed block after this UPDATE without COMMIT.
-- Test Example 2 unnamed block after this UPDATE without COMMIT.
-- Test Example 2 unnamed block after this UPDATE with COMMIT.
select department_id from employees
where employee_id = 141;

UPDATE hr.temp_employees
   SET department_id = 50
 WHERE employee_id = 141;

SELECT * FROM TEMP_EMPLOYEES
WHERE DEPARTMENT_ID = 90;

-- Example with NOWAIT
DECLARE
empid   temp_employees.employee_id%TYPE;
CURSOR cur_emp IS
SELECT employee_id
  FROM temp_employees
 WHERE department_id = 90
   FOR UPDATE OF department_id NOWAIT;
BEGIN
   OPEN cur_emp;
   LOOP
      FETCH cur_emp INTO empid;
      EXIT WHEN cur_emp%NOTFOUND;
      UPDATE temp_employees
         SET department_id = 50
       WHERE CURRENT OF cur_emp;
   END LOOP;
   CLOSE cur_emp;
END;
/

-- Example with WAIT
DECLARE
empid   temp_employees.employee_id%TYPE;
CURSOR cur_emp IS
SELECT employee_id
  FROM temp_employees
 WHERE department_id = 90
   FOR UPDATE OF department_id WAIT 10;
BEGIN
   OPEN cur_emp;
   LOOP
      FETCH cur_emp INTO empid;
      EXIT WHEN cur_emp%NOTFOUND;
      UPDATE temp_employees
         SET department_id = 50
       WHERE CURRENT OF cur_emp;
      --COMMIT;
   END LOOP;
   CLOSE cur_emp;
END;
/

select * from countries;

SET SERVEROUTPUT ON
DECLARE
  var_cid countries.country_id%TYPE;
  CURSOR cur_paises IS
     SELECT country_id, country_name
       FROM countries;
  CURSOR cur_dept IS
     SELECT department_id, department_name
       FROM departments d JOIN locations l
            ON (d.location_id = l.location_id)
        AND l.country_id = var_cid;
  rec_paises  cur_paises%ROWTYPE;
  rec_dept    cur_dept%ROWTYPE;
BEGIN
  OPEN cur_paises;
  LOOP
     FETCH cur_paises INTO rec_paises;
     EXIT WHEN cur_paises%NOTFOUND;
     var_cid := rec_paises.country_id;
     OPEN cur_dept;
     LOOP
        FETCH cur_dept INTO rec_dept;
        EXIT WHEN cur_dept%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE('Pais: '||rec_paises.country_name||
            ' *** Departamento: '||rec_dept.department_name);
     END LOOP;
     CLOSE cur_dept;
  END LOOP;
  CLOSE cur_paises;
END;
/


