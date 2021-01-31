/*
Funciones de filas simples: Operan sobre filas simples y retornan 
un resultado por fila. [Character-Number-Date-Conversion-General]
  * Conversion [TO_CHAR-TO_NUMBER-TO_DATE]
*/
-- TO_CHAR({ datetime | interval } [, fmt [, 'nlsparam' ] ])
-- Convierte un valor datetime o interval a valor tipo VARCHAR2
-- en el formato especificado en fmt.
-- El argumento 'nlsparam' especifica el idioma en el cual el nombre del
-- mes o del día son retornados. El argumento puede tener el siguiente 
-- formato: 'NLS_DATE_LANGUAGE = language'
SELECT hire_date, TO_CHAR(hire_date,'dd-Month-YYYY')
  FROM employees;

SELECT hire_date, TO_CHAR(hire_date,'fmdd-Month-YYYY')
  FROM employees;
  
SELECT hire_date, 
       TO_CHAR(hire_date,'fmdd-Month-YYYY','NLS_DATE_LANGUAGE = spanish')
  FROM employees;
  
SELECT hire_date, 
       TO_CHAR(hire_date,'fmdd-Month-YYYY','nls_date_language = french')
  FROM employees;

SELECT hire_date, TO_CHAR(hire_date,'fmdd "of" Month, YYYY')
  FROM employees;

SELECT hire_date, TO_CHAR(hire_date,'fmdd-mm-YYYY HH:MI:SS')
  FROM employees;
  
-- TO_CHAR(n [, fmt [, 'nlsparam' ] ])
-- Convierte n a un valor tipo VARCHAR2 usando el formato
-- numérico fmt.
-- El argumento 'nlsparam' especifica los caracteres que son retornados
-- por los elementos de formatos numéricos.
--    Decimal character
--    Group separator
--    Local currency symbol
--    International currency symbol
-- El argumento 'nlsparam' puede tener la forma siguiente:
--    'NLS_NUMERIC_CHARACTERS = ''dg''
--     NLS_CURRENCY = ''text''
--     NLS_ISO_CURRENCY = territory '
SELECT salary, TO_CHAR(salary,'$999,999.00')
  FROM employees;
  
SELECT salary, TO_CHAR(salary,'$99.00')
  FROM employees;

SELECT salary, TO_CHAR(salary,'$9,999.00')
  FROM employees;
  
-- TO_NUMBER(expr [, fmt [, 'nlsparam' ] ])
-- Convierte expr a un valor tipo NUMBER.
SELECT '1,000.50', TO_NUMBER('1,000.50','99,999')
  FROM dual;
  
-- TO_DATE(char [, fmt [, 'nlsparam' ] ])
-- Convierte char a un valor tipo DATE.
-- fmt es un formato de fecha.
-- Si se omite fmt, char debe estar en el formato de fecha defecto.
SELECT TO_DATE('January 15, 1989, 11:00 A.M.','Month dd, YYYY, HH:MI A.M.')
  FROM DUAL;

SELECT TO_DATE('January 15, 1989, 11:00 A.M.') -- Da error porque se omite fmt y la fecha no está en formato defecto
  FROM DUAL;

SELECT TO_DATE('15-JAN-1989') -- No da error aunque se omite fmt; la fecha está en formato defecto
  FROM DUAL;

alter session set nls_date_format = 'dd-MON-RR';

/*
Funciones de filas simples: Operan sobre filas simples y retornan 
un resultado por fila. [Character-Number-Date-Conversion-General]
  * General [NVL-NVL2-NULLIF-COALESCE]
*/
-- NVL(expr1, expr2)
-- Permite reemplazar nulo por una cadena.
-- Si expr1 es null, NVL retorna expr2. 
-- Si expr1 no es null, NVL retorna expr1.
-- Los argumentos expr1 y expr2 pueden tener cualquier tipo de datos.
-- Si los tipos de datos son diferentes, Oracle de manera implícita
-- convierte uno al tipo de dato del otro.
-- Si no se pueden convertir de manera implícita, se produce un error. 
-- La conversión implícita se implementa de la siguiente forma:
--    Si expr1 es character, Oracle convierte expr2 al tipo de expr1 
--    luego de compararlas y retorna VARCHAR2.
--    Si expr1 es numérico, Oracle determina cuál argumento tiene la
--    más alta precedencia numérica, de manera implícita convierte el
--    otro argumento a este tipo de datos, y retorna este tipo.
SELECT 300 + NVL(NULL,0) 
  FROM dual;

SELECT last_name, 
       NVL(commission_pct,'Not Applicable') AS "Commission" -- Error? 
  FROM employees
 WHERE last_name LIKE 'B%'
 ORDER BY last_name;

SELECT last_name, commission_pct,
       NVL(commission_pct,0) AS "Commission"
  FROM employees
 WHERE last_name LIKE 'B%'
 ORDER BY last_name;

SELECT last_name, 
       NVL(commission_pct,'0555') AS "Commission" -- Convierte a numérico
  FROM employees
 WHERE last_name LIKE 'B%'
 ORDER BY last_name;

UPDATE employees
   SET phone_number = null
 WHERE last_name = 'Fay';
 
SELECT last_name,
       NVL(phone_number,'Missing') AS "Phone Number"
  FROM employees;
  
SELECT last_name,
       NVL(phone_number,999) AS "Phone Number" -- Convierte a VARCHAR2
  FROM employees;

SELECT last_name,
       NVL(hire_date,'01-Jan-2001') AS "Hire Date"
  FROM employees;
  
-- NVL2(expr1, expr2, expr3)
-- Permite determinar el valor retornado por una consulta basada en
-- que la expresión tenga un valor nulo o no.
-- Si expr1 no es null, NVL2 retorna expr2.
-- Si expr1 es null, NVL2 retorna expr3.
-- El argumento expr1 puede ser de cualquier tipo de datos.
-- El argumento expr2 y expr3 pueden ser de cualquier tipo excepto LONG.
-- Si el tipo de datos de expr2 y expr3 son diferentes:
--    Si expr2 es character, Oracle convierte expr3 al tipo de datos de expr2 
--    a menos que expr3 sea null.
-- Si expr2 es numérico, Oracle determina cual argumento tiene la más alta
-- precedencia, de manera implícita convierte el otro argumento a este tipo de datos
-- y retorna este tipo de datos.
SELECT last_name, salary, commission_pct, 
       NVL2(commission_pct,salary + (salary * commission_pct), salary) AS "Income"
  FROM employees 
 WHERE last_name like 'B%'
 ORDER BY last_name;

-- NULLIF(expr1, expr2)
-- Compara expr1 y expr2.
-- Si son iguales la función retorna null.
-- Si no son iguales la función retorna expr1. 
-- expr1 no puede ser NULL.
-- Si los argumentos no son numéricos, deben ser del mismo tipo de datos.
-- La función NULLIF es equivalente lógicamente al siguiente CASE:
--     CASE WHEN expr1 = expr2 THEN NULL ELSE expr1 END
SELECT last_name, first_name, length(last_name), length(first_name),
       NULLIF (length(last_name),length(first_name))
  FROM employees;
       
SELECT e.employee_id,e.last_name, 
       e.job_id "Current Job", j.job_id "Old Job",
       NULLIF(e.job_id, j.job_id) "Old Job ID"
  FROM employees e 
  JOIN job_history j ON (e.employee_id = j.employee_id)
 ORDER BY last_name;

select *
from job_history
where employee_id = 200;

select job_id
from employees
where employee_id = 200;

-- COALESCE(expr [, expr ]...)
-- Retorna el primer valor no-null en la lista de expresiones.
-- Como mínimo deben especificarse dos expresiones.
-- Si todas las ocurrencias de expr son null, la función retorna null.
-- Oracle evalúa cada valor expr y determina si es NULL.
SELECT product_id, list_price, min_price,
       COALESCE(0.9*list_price, min_price, null) "Sale"
  FROM product_information -- Esta tabla pertenece al esquema OE
 WHERE supplier_id = 102050
 ORDER BY product_id, list_price, min_price, "Sale";
 
SELECT product_id, list_price, min_price,
       COALESCE(0.9*list_price, min_price, NULL) "Sale"
  FROM product_information -- Esta tabla pertenece al esquema OE
 WHERE supplier_id = 102050
 ORDER BY product_id, list_price, min_price, "Sale";

-- La expresión CASE permite usar la lógica IF ... THEN ... ELSE 
-- en una instrucción SQL sin tener que invocar un procedimiento.
-- CASE { simple_case_expression | searched_case_expression }
--      [ else_clause ]
-- END
-- simple_case_expression::=
--     expr WHEN comparison_expr THEN return_expr
--        [ WHEN comparison_expr THEN return_expr ]...
-- searched_case_expression::=
--     WHEN condition THEN return_expr
--   [ WHEN condition THEN return_expr ]...
-- else_clause::=
--     ELSE else_expr
SELECT cust_last_name, credit_limit,
       CASE  
          WHEN  credit_limit BETWEEN 100 THEN 'Low'
          WHEN 5000 THEN 'High'
          ELSE 'Medium' 
       END AS "Credit Type"
  FROM customers
 ORDER BY credit_limit; -- Esta tabla pertenece al esquema OE


-- DECODE(expr, search, result [, search, result ]... [, default ] )
-- Compara expr con cada valor de búsqueda una a una.
-- Si expr es igual al valor de búsqueda, Oracle retorna el resultado correspondiente.
-- Si no hay coincidencias, Oracle retorna default.
-- Si se omite default, Oracle retorna null.

SELECT cust_last_name, credit_limit,
       DECODE(credit_limit,100,'Low',
                           5000,'High',
                                'Medium') AS "Credit Type"
FROM customers
 ORDER BY credit_limit; -- Esta tabla pertenece al esquema OE       


SELECT product_id, warehouse_id,
       DECODE(warehouse_id, 1, 'Southlake', 
                            2, 'San Francisco', 
                            3, 'New Jersey', 
                            4, 'Seattle',
                               'Non domestic') AS "Location of inventory" 
  FROM inventories -- Esta tabla pertenece al esquema OE
 WHERE product_id < 1775
 ORDER BY 2;