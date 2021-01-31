!=   <>  ^=

/*
Funciones de filas simples: Operan sobre filas simples y retornan 
un resultado por fila. [Character-Number-Date-Conversion-General]
  *** Character
    - Manipulan el CASE [LOWER * UPPER * INITCAP]
    - Manipulan el caracter [CONCAT*SUBSTR*LENGTH*INSTR*LPAD|RPAD*TRIM*REPLACE]
*/
-- Manipulan el CASE [LOWER*UPPER*INITCAP]
SELECT LOWER('Todo Este Texto Sale En Minúscula') 
  FROM dual;
  
SELECT last_name, LOWER(last_name)
  FROM employees;
  
SELECT UPPER('Todo este texto sale en mayúscula')
  FROM dual;

SELECT last_name, UPPER(last_name)
  FROM employees;
  
SELECT INITCAP('El texto sale con la primera letra de cada palabra en mayúscula')
  FROM dual;
  
SELECT region_name,INITCAP(region_name)
  FROM regions;
  
SELECT last_name
  FROM employees
 WHERE last_name = 'pataballa';
 -- Los valores almacenados en las tablas son 
 -- sensibles al caso
                                
SELECT last_name
  FROM employees
 WHERE upper(last_name) = 'PATABALLA';
 -- Convierte el valor de la columna a
-- minúscula.
                                       
-- Manipulan el caracter [CONCAT*SUBSTR*LENGTH*INSTR*LPAD|RPAD*TRIM*REPLACE]
-- CONCAT(char1, char2) 
-- Concatenar char1 con char2.
SELECT last_name, first_name, 
       CONCAT(last_name,first_name)
  FROM employees;
  
SELECT last_name, first_name, 
       CONCAT(last_name||', ',first_name)
  FROM employees;

SELECT CONCAT(last_name,first_name,employee_id) -- Da error porque se suministró
  FROM employees;                               -- más argumentos del aceptado

SELECT CONCAT(last_name||first_name,job_id) AS APELLIDO_NOMBRE_JOB 
  FROM employees; -- Da error porque se suministró más argumentos del aceptado

-- SUBSTR(char, position [, substring_length])
-- Retorna una porción de char.
-- El argumento char representa la cadena que deseo manipular.
-- Si position es 0, se trata como 1.
-- Si position es positivo, Oracle cuenta desde el inicio para encontrar el 
-- primer caracter.
-- Si position es negativo, Oracle cuenta hacia atrás desde el final de la 
-- cadena.
-- El argumento substring_length es opcional e indica la cantidad de caracteres 
-- a retornar.
-- Si substring_length se omite, Oracle retorna todos los caracteres hasta el 
-- final de la cadena.
-- Si substring_length es menor o igual que 0, Oracle retorna nulo.
SELECT last_name, SUBSTR(last_name,0) -- La posición 0 se trata como 1
  FROM employees;
  
SELECT last_name, SUBSTR(last_name,1) -- Muestra la información desde la
  FROM employees;                     -- posición 1 hasta el final
  
SELECT last_name, SUBSTR(last_name,2) -- Muestra la información desde la 
  FROM employees;                     -- posición 2 hasta el final
  
SELECT last_name, SUBSTR(last_name,-2) -- Muestra la información iniciando 
  FROM employees;                      -- por el final, desde la posición -2 
                                       -- hasta el final
                                       
SELECT last_name, SUBSTR(last_name,1,3) -- Muestra los primeros tres caracteres.
  FROM employees;
  
SELECT last_name, SUBSTR(last_name,3,3) -- Muestra desde la posición 3, tres 
  FROM employees;                       -- caracteres
  
SELECT last_name, SUBSTR(last_name,-5,2) -- Cuenta cuatro caracteres iniciando 
  FROM employees;                        -- desde el final y muestra dos 
                                         -- caracteres.
                                         
SELECT last_name, SUBSTR(last_name,1,0) -- Muestra nulo
  FROM employees;
  
SELECT last_name, SUBSTR(last_name,3,-1) -- Muestra nulo
  FROM employees;
  
-- LENGTH(char)
SELECT last_name, LENGTH(last_name) -- Muestra la cantidad de caracteres de una 
  FROM employees;                   -- cadena.
  
SELECT salary/3, LENGTH(salary/3) -- Convierte el valor numérico a caracter y cuenta 
  FROM employees;             -- la cantidad de dígitos incluyendo el punto.

alter session set nls_date_format='dd/mm/yyyy';

SELECT hire_date, LENGTH(hire_date) -- Convierte el valor fecha a caracter y 
  FROM employees;                   -- cuenta la cantidad de caracteres.
  
SELECT LENGTH(NULL) -- La longitud de nulo es nulo.
  FROM dual;

SELECT LENGTH(commission_pct) -- La longitud de nulo es nulo.
  FROM employees;
  
-- INSTR(string , substring [, position [, occurrence ] ])
-- Retorna un entero indicando la posición de un caracter dentro de la cadena.
-- string     -> Representa la cadena de caracter.
-- substring  -> Representa la porción que quiero buscar dentro de la cadena.
-- position   -> Es un entero diferente de cero, indicando la posición a partir 
--               de la cual se inicia la búsqueda.
--               Si es negativo, cuenta hacia atrás desde el final de la cadena 
--               y busca hacia atrás desde la posición resultante.
--               Es opcional.
-- occurrence -> Es un valor entero indicando cuál ocurrencia queremos buscar.
--               Debe ser positivo.
--               Es opcional.
SELECT last_name, INSTR(LOWER(last_name),'au') -- Devuelve la posición donde se 
  FROM employees;                       -- encuentre la primera ocurrencia de 
                                        -- "au" iniciando por la primera 
                                        -- posición.
                                        
SELECT last_name, INSTR(last_name,'au') -- Devuelve la posición donde se 
  FROM employees                        -- encuentre la primera ocurrencia de 
 WHERE INSTR(last_name,'au') > 0;       -- "au" iniciando por la primera 
                                        -- posición.
 
SELECT last_name, INSTR(last_name,'a',3) -- Devuelve la posición donde se 
  FROM employees                         -- encuentre la primera ocurrencia de 
 WHERE INSTR(last_name,'a',3) > 0;       -- "a" iniciando en la posición tres.

SELECT last_name, INSTR(last_name,'a',3,2) -- Devuelve la posición donde se 
  FROM employees                           -- encuentre la segunda ocurrencia de
 WHERE INSTR(last_name,'a',3,2) > 0;       -- "a" iniciando en la posición tres.
 
SELECT last_name, INSTR(last_name,'a',0) -- No retorna ningún registro.
  FROM employees
 WHERE INSTR(last_name,'a',0) > 0;

SELECT last_name, INSTR(last_name,'a',-3) -- Devuelve la posición donde se 
  FROM employees                          -- encuentre la primera ocurrencia de 
 WHERE INSTR(last_name,'a',-3) > 0;       -- "a" contando desde el final de la
                                          -- candena tres posiciones atrás y 
                                          -- buscando hacia atrás.
                                          
SELECT last_name, INSTR(last_name,'a',-3,3) -- Devuelve la posición donde se 
  FROM employees                            -- encuentre la segunda ocurrencia 
 WHERE INSTR(last_name,'a',-3,3) > 0;       -- de "a" contando desde el final de
                                            -- la candena tres posiciones atrás
                                            -- y buscando hacia atrás.
 
SELECT last_name, INSTR(last_name,'a',3,0) -- Da error, la ocurrencia debe ser 
  FROM employees                           -- positivo.
 WHERE INSTR(last_name,'a',3,0) > 0;

SELECT last_name, INSTR(last_name,'a',3,-1) -- Da error, la ocurrencia debe ser 
  FROM employees                            -- positivo.
 WHERE INSTR(last_name,'a',3,-1) > 0;

-- LPAD|RPAD(expr1, n [, expr2 ])
-- Retorna expr1, rellenada a la izquierda a la cantidad de n caracteres
-- con la secuencia de caracteres en expr2.
-- Es útil para formatear la salida de una consulta.
-- expr1 no puede ser nulo.
-- Tanto expr1 y expr2 pueden ser de caulquier tipo de dato CHAR, VARCHAR2, 
-- NCHAR, NVARCHAR2, CLOB, or NCLOB. 
-- La cadena retornada será del mismo character set de expr1. 
-- El argumento n debe ser entero NUMBER o un valor que pueda ser implícitamente 
-- convertido a entero NUMBER.
-- Si no se especifica expr2, el defecto es blanco. 
-- Si expr1 es más grande que n, la función retorna la porción de expr1 que 
-- llena n.
SELECT last_name,LPAD(last_name,10) -- Rellena a la izquierda de espacios en 
  FROM employees;                   -- blanco hasta 10
  
SELECT last_name,LPAD(last_name,5,'*') -- Rellena a la izquierda de asteriscos
  FROM employees;                      -- hasta 5

SELECT last_name,LPAD(last_name,20,'$') -- Rellena a la izquierda de signo de 
  FROM employees;                       -- dólar hasta 20
  

SELECT last_name,LPAD(last_name,0,'$') -- Retorna nulo.
  FROM employees;

SELECT last_name,LPAD(last_name,-1,'$') -- Retorna nulo.
  FROM employees;

SELECT last_name,RPAD(last_name,10) -- Rellena a la derecha de espacios en 
  FROM employees;                   -- blanco hasta 10
  
SELECT last_name,RPAD(last_name,5,'*') -- Rellena a la derecha de asteriscos 
  FROM employees;                      -- hasta 5

SELECT last_name,RPAD(last_name,20,'$') -- Rellena a la derecha de signo de
  FROM employees;                       -- dólar hasta 20

SELECT last_name,RPAD(last_name,0,'$') -- Retorna nulo.
  FROM employees;

SELECT last_name,RPAD(last_name,-1,'$') -- Retorna nulo.
  FROM employees;

-- TRIM([ { { LEADING | TRAILING | BOTH } [ trim_character ] | trim_character } 
--      FROM ] trim_source)
-- Permite recortar al inicio, final o ambos lados de una 
-- cadena de caracteres.
-- Si trim_character o trim_source es un literal, éste debe 
-- ser encerrado entre comillas simples.
-- Si se especifica LEADING, se remueve cualquier caracter
-- igual a trim_character que inicie la cadena.
-- Si se especifica TRAILING, se remueve cualquier caracter
-- igual a trim_character que finalice la cadena.
-- Si se especifica BOTH o ninguno, se remueve cualquier caracter
-- igual a trim_character que inicie o finalice la cadena.
-- Si no se especifica trim_character, el defecto es espacio en blanco.
-- Si sólo se especifica trim_source, se remueve espacios en blanco 
-- al inicio y al final.
-- Si trim_source o trim_character es nulo, la función retorna nulo.
-- La cadena retornada es del mismo character set de trim_source.
SELECT 'acaudalada', 
       TRIM('a' FROM 'acaudalada') -- Recorta la 'a' a ambos lados de la cadena.
  FROM dual;

SELECT last_name, 
       TRIM(LEADING 'A' FROM last_name) -- Recorta la 'A' al inicio de la 
  FROM employees;                       -- cadena.
  
SELECT last_name, 
       TRIM(TRAILING 'e' FROM last_name) -- Recorta la 'e' al final de la
  FROM employees;                        -- cadena.
  
SELECT last_name, 
       TRIM(TRAILING 'e' FROM last_name) -- Recorta la 'e' al final de la
  FROM employees                         -- cadena.
 WHERE last_name like '%e';
 
SELECT 'acaudalada', 
       TRIM(BOTH 'a' FROM 'acaudalada') -- Recorta la 'a' a ambos lados de la
  FROM dual;                            -- cadena.

SELECT TRIM('u' FROM substr('acaudalada',4)), 
       TRIM(BOTH 'a' FROM 'acaudalada') -- Recorta la 'a' a ambos lados de la
  FROM dual;                            -- cadena.

SELECT '    acaudalada    ', 
       TRIM('    acaudalada    ') -- Recorta los espacios en blanco a ambos
  FROM dual;                      -- lados de la cadena.
  
SELECT employee_id,manager_id, TRIM(manager_id) -- Retorna nulo.
  FROM employees
 WHERE employee_id = 100;

-- RTRIM(char [, set ])
SELECT last_name, 
       RTRIM(last_name,'e') -- Recorta la 'e' al final de la cadena.
  FROM employees
 WHERE last_name like '%e';
 
-- REPLACE(char, search_string [, replacement_string ] )
-- Retorna char para cada ocurrencia de search_string remplazada con 
-- replacement_string. 
-- Si replacement_string se omite o es null, se remueven todas las ocurrencias 
-- de search_string. 
-- Si search_string is null, char es retornada.
SELECT last_name, REPLACE(last_name,'ee','oo') -- Substituye "ee" por "oo"
  FROM employees
 WHERE last_name like '%ee%';
 
SELECT last_name, REPLACE(last_name,'ee') -- Substituye "ee" por nada al 
  FROM employees                          -- omitirse replacement_string.
 WHERE last_name like '%ee%';

SELECT last_name, REPLACE(last_name,null) -- Se retorna char.
  FROM employees
 WHERE last_name like '%ee%';
 
-- TRANSLATE(expr, from_string, to_string)
SELECT 'SQL*Plus User''s Guide', 
       TRANSLATE('SQL*Plus User''s Guide', ' *''','$!-') 
  FROM dual;

/*
Funciones de filas simples: Operan sobre filas simples y retornan 
un resultado por fila. [Character-Number-Date-Conversion-General]
  *** Number [ROUND * TRUNC * MOD]
*/
-- ROUND(n [, integer ])
-- Devuelve n redondeado a integer lugares a la derecha del punto decimal.
-- Si se omite integer, n es redondeado a cero lugares.
-- El argumento integer puede ser negativo para redondear dígitos a la 
-- izquierda del punto decimal.
-- En valores NUMBER, el valor n es redondeado fuera de cero
-- (Por ejemplo, x+1 cuando x.5 se da y x-1 cuando x.5 no se da).
SELECT salary,ROUND(salary,2) -- Redondea a 1 punto decimal.
  FROM employees;

SELECT salary,salary/7 -- Redondea a 0 punto decimal [Unidad].
  FROM employees;

SELECT salary,salary/7,ROUND(salary/7,2) -- Redondea a 2 puntos decimal 
  FROM employees;                        -- [Unidad].

SELECT salary,salary/7,ROUND(salary/7) -- Redondea a 0 punto decimal [Unidad].
  FROM employees;
  
SELECT salary,salary/7,ROUND(salary/7,-1) -- Redondea una posición antes del 
  FROM employees;                         -- punto decimal [Decenas].

SELECT salary,salary/7,ROUND(salary/7,-2) -- Redondea dos posiciones antes del
  FROM employees;                         -- punto decimal [Centenas].

SELECT salary,salary/7,ROUND(salary/7,-3) -- Redondea tres posiciones antes del
  FROM employees;                         -- punto decimal [Milésimas].

-- TRUNC(n1 [, n2 ])
-- Devuelve n1 truncado a n2 lugares decimales.
-- Si n2 se omite, n1 es truncado a cero lugares.
-- n2 puede ser negativo para truncar n2 dígitos a la izquierda del punto
-- decimal.
SELECT salary,salary/7,TRUNC(salary/7,1) -- Trunca a 1 punto decimal.
  FROM employees;

SELECT salary,salary/7,TRUNC(salary/7) -- Trunca a 0 punto decimal [Unidad].
  FROM employees;

SELECT salary,salary/7,TRUNC(salary/7,0) -- Trunca a 0 punto decimal [Unidad].
  FROM employees;
  
SELECT salary,salary/7,TRUNC(salary/7,-1) -- Trunca a una posición antes del
  FROM employees;                         -- punto decimal [Decenas].

SELECT salary,salary/7,TRUNC(salary/7,-2) -- Trunca a dos posiciones antes del
  FROM employees;                         -- punto decimal [Centenas].

SELECT salary,salary/7,TRUNC(salary/7,-3) -- Trunca a tres posiciones antes del
  FROM employees;                         -- punto decimal [Centenas].

-- MOD(n2, n1)
-- Devuelve el residuo de n2 dividido por n1.
-- Devuelve n2 si n1 es 0.
SELECT MOD(100,4) -- Residuo de 100 luego de ser dividido entre 4
  FROM dual;
  
SELECT MOD(100,3) -- Residuo de 100 luego de ser dividido entre 3
  FROM dual;
  
SELECT MOD(100,0) -- Devuelve 100
  FROM dual;

/*
Funciones de filas simples: Operan sobre filas simples y retornan 
un resultado por fila. [Character-Number-Date-Conversion-General]
*** Date [DD-MON-RR*sysdate*MONTHS_BETWEEN*ADD_MONTHS*NEXT_DAY*LAST_DAY*ROUND*
          TRUNC]
*/
-- Formato de fecha por defecto: DD-MON-RR
-- Permite almacenar fechas del siglo 21 estando en el siglo 20 especificando
-- sólo los dos dígitos del año.
-- Permite almacenar fechas del siglo 20 estando en el siglo 21 de la misma
-- manera.
-- *** Cambiar fecha del sistema ubicándonos en el siglo 20.
-- *** Crear una tabla de prueba que contenga una columna tipo fecha.
-- *** Insertar una fecha del siglo 21 usando el formato defecto.
-- *** Cambiar fecha del sistema a la fecha actual.
-- *** Insertar una fecha del siglo 20 usando el formato defecto.

-- SYSDATE
-- Devuelve la fecha del sistema operativo donde reside la BD.
-- Devuelve un valor tipo DATE, en el formato definido por el parámetro 
-- NLS_DATE_FORMAT.
-- La función no requiere de argumentos.

alter session set nls_date_format='dd-MON-RR';

SELECT SYSDATE
  FROM dual;

alter session set NLS_DATE_FORMAT = 'Month dd, YYYY';

select last_name, hire_date
  from employees;
  
alter session set NLS_DATE_FORMAT = 'fmMonth dd, YYYY';

alter session set NLS_DATE_FORMAT = 'dd-MON-RR';

-- MONTHS_BETWEEN(date1, date2)
-- Devuelve el número de meses entre las fechas date1 y date2.
-- Si date1 is mayor que date2, el resultado es positivo.
-- Si date1 es menor que date2, el resultado es negativo.
-- Si date1 y date2 son o bien los mismos días del mes o los últimos días del
-- mes, el resultado es siempre un número entero. De lo contrario, Oracle
-- calcula la porción fraccionaria del resultado basado en un mes de 31 días, 
-- y considera la diferencia en los componentes del tiempo de date1 y date2.
SELECT hire_date,MONTHS_BETWEEN(SYSDATE,hire_date)
  FROM employees;

SELECT hire_date,
       ROUND(MONTHS_BETWEEN(SYSDATE,hire_date))
  FROM employees;
  
SELECT MONTHS_BETWEEN(hire_date,SYSDATE)
  FROM employees;

SELECT MONTHS_BETWEEN('22-MAY-2014','22-APR-2014')
  FROM dual;
  
SELECT MONTHS_BETWEEN('31-MAY-2014','30-APR-2014')
  FROM dual;

SELECT MONTHS_BETWEEN('31-MAY-2014','15-APR-2014')
  FROM dual;

SELECT ROUND(MONTHS_BETWEEN('31-MAY-2014','15-APR-2014'))
  FROM dual;
  
-- ADD_MONTHS(date, integer)
-- Devuelve la fecha date más integer meses.
-- Si date es el último día del mes o si el mes resultante tiene
-- menos días que el componente de día de date, el resultado es
-- el último día de el mes resultante. De lo contrario, el resultado
-- tiene el mismo componente día de date.
SELECT hire_date, 
       ADD_MONTHS(hire_date,1) AS "Next month"
  FROM employees;

-- NEXT_DAY(date, char)
-- Devuelve la fecha del primer día de la semana nombrado por char
-- luego de la fecha especificada en date.
-- El argumento char debe ser un día de la semana en el idioma de la sesión.
SELECT hire_date,NEXT_DAY(hire_date,'FRI') AS "Next Weekday"
  FROM employees;

-- LAST_DAY(date)
-- Devuelve la fecha del último día del mes que contiene date.
SELECT hire_date, LAST_DAY(hire_date) "Last Day"
  FROM employees;

-- ROUND(date [, fmt ])
-- Devuelve date redondeada a la unidad especificada en el formato fmt.
-- Si se omite fmt, date se redondea al día más cercano.
SELECT hire_date, ROUND(hire_date,'YEAR') -- Redondea al año más cercano.
  FROM employees;
  
SELECT hire_date, ROUND(hire_date,'MONTH') -- Redondea al mes más cercano.
  FROM employees;
  
SELECT to_char(hire_date,'dd-MON-RR HH:MI:SS'), 
       ROUND(hire_date) -- Redondea al día más cercano.
  FROM employees;

-- TRUNC(date [, fmt ])
-- Retorna date con la porción del tiempo del día truncado a la unidad
-- especificada en fmt.
-- Si fmt se omite, date es truncada al día más cercano.
SELECT hire_date, TRUNC(hire_date,'YEAR') -- Redondea al año más cercano.
  FROM employees;
  
SELECT hire_date, TRUNC(hire_date,'MONTH') -- Redondea al mes más cercano.
  FROM employees;
  
SELECT to_char(hire_date,'dd-MON-RR HH:MI:SS'), 
       TRUNC(hire_date) -- Redondea al día más cercano.
  FROM employees;

-- Ejercicio Práctico
-- Necesito que dado una cadena de caracteres con el formato siguiente
-- 'valor_valor_valor' se devuelva el valor que está entre las dos
-- rayas abajo, sin incluir las rayas.
select substr('&&id',1,length('&id'))
from dual;
UNDEFINE ID

SELECT SUBSTR('&VALOR',4,2)
FROM DUAL;
UNDEFINE valor

section='12_PB1_1CC'

