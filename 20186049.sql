CONNECT SYSTEM/oracle;
DROP USER AMORTIZ CASCADE;
CREATE USER AMORTIZ IDENTIFIED BY oracle;
GRANT ALL PRIVILEGES TO AMORTIZ;
CONNECT AMORTIZ/oracle;



CREATE TABLE param_amortizacion
(
ID_p NUMBER constraint v_num_pk Primary key,
Monto NUMBER,
Tasa NUMBER,
Cantidad_Años NUMBER,
Fecha_Inicio DATE,
Pago_Ex NUMBER,
Cuota NUMBER
);
CREATE TABLE amortizacion
(
id NUMBER,
PmtNo NUMBER(30,2),
Fecha_pago DATE,
Balance_I NUMBER(30,2),
Cuota NUMBER(30,2),
Pago_extra NUMBER DEFAULT 0,
Total_pago NUMBER(30,2),
Capital NUMBER(30,2),
Intereses NUMBER(30,2),
Balance_F NUMBER(30,2),
id_a NUMBER(6),
CONSTRAINT id_fk Foreign Key (id_a) references param_amortizacion(id_p)
);

CREATE OR REPLACE FUNCTION calc_cuota_prog(monto NUMBER, tasa NUMBER, plazo NUMBER)
RETURN NUMBER AS
v_monto NUMBER := monto;
v_tasa NUMBER := (tasa/100)/12;
v_plazo NUMBER :=plazo*12;
v_cuotaprog NUMBER;
BEGIN
v_cuotaprog :=v_monto*(v_tasa*((1+v_tasa)**v_plazo)/(((1+v_tasa)**v_plazo)-1));
RETURN v_cuotaprog;
END;
/


create sequence amortiz_seq
            NOCACHE
            NOCYCLE
            MINVALUE 1
            START WITH 1;
          
create sequence amortiz_seq2
            NOCACHE
            NOCYCLE
            MINVALUE 1
            START WITH 1;



CREATE OR REPLACE PROCEDURE amortizacion_proc (monto NUMBER,
tasa NUMBER, plazo NUMBER,fecha_inicio DATE,pago_ex NUMBER :=0 ) is
v_monto NUMBER :=monto;
v_t NUMBER :=tasa/100;
v_tasa NUMBER := v_t/12;
v_plazo NUMBER :=plazo*12;
v_fi DATE := fecha_inicio;
v_pex NUMBER := pago_ex;
v_num NUMBER;
BEGIN
insert into param_amortizacion
(id_p,Monto,Tasa,Cantidad_Años,Fecha_Inicio,Pago_Ex,Cuota)
values 
(amortiz_seq.nextval,monto,tasa,plazo,Fecha_inicio,pago_ex,calc_cuota_prog(monto,tasa,plazo));
v_num := amortiz_seq.currval;
DBMS_OUTPUT.PUT_LINE('ID Préstamo: '||v_num||chr(10)||
                     'Monto: '||TO_CHAR(monto,'$99,999,999.00')||chr(10)||
                     'Tasa: '||tasa||chr(10)||
                     'Plazo: '||plazo||chr(10)||
                     'Fecha Préstamo: '||TO_CHAR(fecha_inicio,'dd-MON-RR')||chr(10)||
                     'Fecha Saldo: '||ADD_MONTHS(fecha_inicio,plazo*12)||chr(10)||
                     'Pago Extra: '||TO_CHAR(pago_ex,'$999,999.00')||chr(10)||
                     'Cuota Mensual: '||TO_CHAR(calc_cuota_prog(monto,tasa,plazo),'$999,999.00'));
                     
FOR i IN 1..v_plazo LOOP
insert into amortizacion values
(amortiz_seq2.nextval,
 i,
 ADD_MONTHS(v_fi,i),
 v_monto,
 calc_cuota_prog(monto,tasa,plazo),
 v_pex,
 v_pex + calc_cuota_prog(monto,tasa,plazo),
 calc_cuota_prog(monto,tasa,plazo)-(v_monto*(v_tasa)),
 v_monto * (v_tasa),
 v_monto -(calc_cuota_prog(monto,tasa,plazo)-(v_monto*(v_tasa))),
 v_num
 );
 v_monto :=v_monto - (calc_cuota_prog(monto,tasa,plazo) - (v_monto * (v_tasa)));

END LOOP;
END;
/


alter session set nls_date_format = 'DD-Mon-YY'; 

execute amortizacion_proc(&monto,&tasa,&plazo,'&fecha_inicio',&pago_ex);
SELECT pmtno AS "PmtNo." ,
TO_CHAR(fecha_pago,'DD-MON-YY') as "Fecha de Pago",
TO_CHAR(ROUND(balance_i,2),'99,999,999.00') as "Balance Inicial",
TO_CHAR(ROUND(cuota,2),'99,999,999.00') as "Cuota a Pagar",
TO_CHAR(ROUND(pago_extra,2),'99,999,999.00') as "Pago Extra",
TO_CHAR(ROUND(total_pago,2),'$99,999,999.00') as "Total Pago",
TO_CHAR(ROUND(capital,2),'99,999,999.00') as "Capital",
TO_CHAR(ROUND(intereses,2),'99,999,999.00') as "Intereses",
TO_CHAR(ROUND(balance_f,2),'99,999,999.00') as "Balance Final"
FROM AMORTIZACION;
SELECT *FROM param_amortizacion;

--delete from amortizacion;
--delete from param_amortizacion;



