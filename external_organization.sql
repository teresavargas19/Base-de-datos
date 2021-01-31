--- CREATE EMP_DIR DIRECTORY IN YOUR OS
-- ===================================
c:\emp_dir

-- CONNECTED AS SYSTEM
-- ===================

CREATE OR REPLACE DIRECTORY emp_dir -- create the directory
AS 'c:\emp_dir'; 

select * from dba_directories;

GRANT READ, WRITE ON DIRECTORY emp_dir TO hr; -- grant READ and WRITE privileges to HR

-- CONNECTED AS HR
-- ===============

drop table students; -- drop students table

CREATE TABLE students -- create students table as an organization external
       (
        name   varchar2(30),
        ident     number(8),
        email  varchar2(30)
       )
ORGANIZATION EXTERNAL
(
 TYPE ORACLE_LOADER  
 DEFAULT DIRECTORY emp_dir
 ACCESS PARAMETERS
 (
  RECORDS DELIMITED BY NEWLINE
  SKIP 1
  BADFILE 'students.bad'
  LOGFILE 'students.log'  
  FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
  MISSING FIELD VALUES ARE NULL
  REJECT ROWS WITH ALL NULL FIELDS
  (name, ident, email)
 )
  LOCATION ('students.csv')
)
REJECT LIMIT unlimited
;

desc students

select * 
from students; -- view the external data

create table students_temp AS -- Se puede crear una tabla con datos permantentes
select *					  -- A partir de una tabla con organziación externa.
from students;

select * from students_temp;

select *
from students
where name like '%R%';

insert into students values (20142025,'Lola','lola@gmail.com'); -- Da error

drop table emp_ext;
CREATE TABLE emp_ext
  (employee_id, first_name, last_name)
   ORGANIZATION EXTERNAL
    (
     TYPE ORACLE_DATAPUMP
     DEFAULT DIRECTORY emp_dir
     LOCATION
      ('emp1.exp','emp2.exp')
    )
   PARALLEL
AS
SELECT employee_id, first_name, last_name
FROM   employees;


select * from emp_ext;