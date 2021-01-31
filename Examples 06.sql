SET SERVEROUTPUT ON
DECLARE
   v_grade  CHAR(1) := UPPER('&grade');
   v_appraisal VARCHAR2(20);
BEGIN
    v_appraisal := CASE 
         WHEN v_grade  = 'A' THEN 'Excellent'
         WHEN v_grade  IN (SELECT 'B' FROM DUAL;) THEN 'Good'          
         ELSE 'No such grade'   
     END;
   DBMS_OUTPUT.PUT_LINE ('Grade: '|| v_grade  ||                  ‘ Appraisal ' || v_appraisal);
END;
/


select CASE
         WHEN grade_level  = 'A' THEN 'Excellent'
         WHEN grade_level  IN (SELECT 'B' FROM DUAL) THEN 'Good'          
         ELSE 'No such grade'   
     END "Grado"
FROM job_grades;



DECLARE
   v_deptid NUMBER;
   v_deptname VARCHAR2(20);
   v_emps NUMBER;
   v_mngid NUMBER := 108;   
BEGIN
  CASE  v_mngid
   WHEN  108 THEN 
    SELECT department_id, department_name      
           INTO v_deptid, v_deptname 
           FROM departments
           WHERE manager_id=108;
    SELECT count(*) INTO v_emps FROM employees      
      WHERE department_id=v_deptid;
 END CASE;
DBMS_OUTPUT.PUT_LINE('You are working in the '|| v_deptname||' department. There are '||v_emps ||' employees in this department');
END;
/


DECLARE
  v_countryid    locations.country_id%TYPE := 'CA';
  v_loc_id       locations.location_id%TYPE;
  v_counter		  NUMBER(2) := 1;
  v_new_city     locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id) INTO v_loc_id FROM locations
  WHERE country_id = v_countryid;
  LOOP
    INSERT INTO locations(location_id, city, country_id)   
    VALUES((v_loc_id + v_counter), v_new_city, v_countryid);
    v_counter := v_counter + 1;
    EXIT;
  END LOOP;
END;
/


DECLARE
  v_countryid   locations.country_id%TYPE := 'CA';
  v_loc_id      locations.location_id%TYPE;
  v_new_city    locations.city%TYPE := 'Montreal';
BEGIN
  SELECT MAX(location_id) INTO v_loc_id 
    FROM locations
    WHERE country_id = v_countryid;
  FOR i IN REVERSE 1..3 LOOP
    INSERT INTO locations(location_id, city, country_id)   
    VALUES((v_loc_id + i), v_new_city, v_countryid );
  END LOOP;
END;
/


