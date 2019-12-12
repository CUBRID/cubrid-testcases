--+ holdcas on;
--this case was added for code coverage.


SELECT TO_CHAR(DATE '12/25/1999', 'dd') FROM db_root;
SELECT TO_CHAR(TIME '10:20:30 AM', 'HH24') FROM db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH MON yyyy') FROM db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'D') FROM db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009','ss ff') FROM db_root; 
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH MON DAY DY Month Mon Day Dy month mon day Dy AM Am am A.M. A.m. a.m. PM Pm pm P.M. P.m. p.m.') FROM db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009','MONTH MON DAY DY Month Mon Day Dy month mon day Dy AM Am am A.M. A.m. a.m. PM Pm pm P.M. P.m. p.m.') FROM db_root; 

SELECT TO_CHAR(DATE '12/25/1999', 'dd', 'ko_KR') FROM db_root;
SELECT TO_CHAR(TIME '10:20:30 AM', 'HH24', 'ko_KR') FROM db_root;
--SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH MON yyyy', 'ko_KR') FROM db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'D', 'ko_KR') FROM db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009','ss ff', 'ko_KR') FROM db_root; 
--SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH MON DAY DY Month Mon Day Dy month mon day Dy AM Am am A.M. A.m. a.m. PM Pm pm P.M. P.m. p.m.', 'ko_KR') FROM db_root;
--SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009','MONTH MON DAY DY Month Mon Day Dy month mon day Dy AM Am am A.M. A.m. a.m. PM Pm pm P.M. P.m. p.m.', 'ko_KR') FROM db_root; 

SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999') FROM db_root;
SELECT TO_TIMESTAMP('YEAR: 1999 MONTH: 12 DAY: 25 HOUR: 10 MINUTE: 30 SECOND: 20','"YEAR:" YYYY "MONTH:" MM "DAY:" DD "HOUR:" HH24 "MINUTE:" MI "SECOND:" SS') FROM db_root;

SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'CC') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'YYYY') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'YY') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'Q') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MM') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'DD') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'DAY') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'D') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'd') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'AM') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'PM') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'A.M.') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'P.M.') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'HH') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'HH12') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'HH24') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MI') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'SS') from db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', '-') from db_root;


SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'CC') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'YYYY') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'YY') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'Q') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'MM') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'MONTH') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'DD') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'DAY') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'D') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'd') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'AM') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'PM') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'A.M.') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'P.M.') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'HH') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'HH12') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'HH24') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'MI') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'SS') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', 'FF') from db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009', '-') from db_root;


SELECT TO_CHAR(DATE '12/25/1999', 'dd') FROM db_root;
SELECT TO_CHAR(TIME '10:20:30 AM', 'HH24') FROM db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'MONTH MON yyyy') FROM db_root;
SELECT TO_CHAR(TIMESTAMP '10:20:30 AM 12/25/1999', 'D') FROM db_root;
SELECT TO_CHAR(DATETIME'10:12:13 6/5/2009','ss ff') FROM db_root; 
SELECT TO_CHAR(1234,'S9999') FROM db_root;
SELECT TO_CHAR(1.234E-4) FROM db_root;



SELECT TO_NUMBER('-1234') FROM db_root;
SELECT TO_NUMBER('0.123','0.0000') FROM db_root;
SELECT TO_NUMBER('0.123','0.0000', 'en_US') FROM db_root;
SELECT TO_NUMBER('0.123','0.0000', 'ko_KR') FROM db_root;

SELECT TO_DATE('9/6/1976') FROM db_root; 
SELECT TO_DATE('1999 3 4', 'YYYY MM DD') FROM db_root
SELECT TO_DATE('1999 3 4', 'YYYY MM DD', 'en_US') FROM db_root
SELECT TO_DATE('1999 3 4', 'YYYY MM DD', 'ko_KR') FROM db_root
SELECT TO_DATE('1999-3-4', 'YYYY-MM-DD', 'en_US') FROM db_root
SELECT TO_DATE('1999-3-4', 'YYYY-MM-DD', 'ko_KR') FROM db_root

SELECT TO_TIME('10:30:20 AM') FROM db_root;
SELECT TO_TIME('HOUR: 10 MINUTE: 30 SECOND: 20', '"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS') FROM db_root;
SELECT TO_TIME('HOUR: 10 MINUTE: 30 SECOND: 20', '"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'en_US') FROM db_root;
SELECT TO_TIME('HOUR: 10 MINUTE: 30 SECOND: 20', '"HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'ko_KR') FROM db_root;
SELECT TO_TIME('10:30:20 AM', 'HH:MI:SS AM') FROM db_root;
SELECT TO_TIME('10:30:20 AM', 'HH:MI:SS AM', 'en_US') FROM db_root;
SELECT TO_TIME('10:30:20', 'HH:MI:SS', 'ko_KR') FROM db_root;


SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999') FROM db_root;
SELECT TO_TIMESTAMP('YEAR: 1999 MONTH: 12 DAY: 25 HOUR: 10 MINUTE: 30 SECOND: 20','"YEAR:" YYYY "MONTH:" MM "DAY:" DD "HOUR:" HH24 "MINUTE:" MI "SECOND:" SS') FROM db_root;
SELECT TO_TIMESTAMP('YEAR: 1999 MONTH: 12 DAY: 25 HOUR: 10 MINUTE: 30 SECOND: 20','"YEAR:" YYYY "MONTH:" MM "DAY:" DD "HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'en_US') FROM db_root;
SELECT TO_TIMESTAMP('YEAR: 1999 MONTH: 12 DAY: 25 HOUR: 10 MINUTE: 30 SECOND: 20','"YEAR:" YYYY "MONTH:" MM "DAY:" DD "HOUR:" HH24 "MINUTE:" MI "SECOND:" SS', 'ko_KR') FROM db_root;

SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999') FROM db_root;
SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999', 'HH:MI:SS AM MM/DD/YYYY') FROM db_root;
SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999', 'HH:MI:SS AM MM/DD/YYYY', 'en_US') FROM db_root;
SELECT TO_TIMESTAMP('10:30:20 AM 12/25/1999', 'HH:MI:SS AM MM/DD/YYYY', 'ko_KR') FROM db_root;
SELECT TO_TIMESTAMP('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD') FROM db_root;
SELECT TO_TIMESTAMP('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD', 'en_US') FROM db_root;
SELECT TO_TIMESTAMP('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD', 'ko_KR') FROM db_root;

SELECT TO_DATETIME('6/5/2009 10:12:13') FROM db_root;
SELECT TO_DATETIME('10:12:13 AM 6/5/2009') FROM db_root;
SELECT TO_DATETIME('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD') FROM db_root;
SELECT TO_DATETIME('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD', 'en_US') FROM db_root;
SELECT TO_DATETIME('10:12:13 2009/6/5', 'HH:MI:SS YYYY/MM/DD', 'ko_KR') FROM db_root;







-----------------------------------



create table test4 (
col_short short,
col_int int,
col_bigint bigint,
col_float float,
col_double double,
col_numeric numeric,
col_monetary monetary,
col_time time,
col_date date,
col_timestamp timestamp,
col_datetime datetime,
col_char char(20)
);
insert into test4 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009', '1');


select col_short + col_short  into :val_short from test4;
select col_short + col_int  into :val_short from test4;
select col_short + col_bigint  into :val_short from test4;
select col_short + col_float  into :val_short from test4;
select col_short + col_double  into :val_short from test4;
select col_short + col_numeric  into :val_short from test4;
select col_short + col_monetary  into :val_short from test4;

select col_int + col_short  into :val_short from test4;
select col_int + col_int  into :val_short from test4;
select col_int + col_bigint  into :val_short from test4;
select col_int + col_float  into :val_short from test4;
select col_int + col_double  into :val_short from test4;
select col_int + col_numeric  into :val_short from test4;
select col_int + col_monetary  into :val_short from test4;

select col_bigint + col_short  into :val_short from test4;
select col_bigint + col_int  into :val_short from test4;
select col_bigint + col_bigint  into :val_short from test4;
select col_bigint + col_float  into :val_short from test4;
select col_bigint + col_double  into :val_short from test4;
select col_bigint + col_numeric  into :val_short from test4;
select col_bigint + col_monetary  into :val_short from test4;

select col_float + col_short  into :val_short from test4;
select col_float + col_int  into :val_short from test4;
select col_float + col_bigint  into :val_short from test4;
select col_float + col_float  into :val_short from test4;
select col_float + col_double  into :val_short from test4;
select col_float + col_numeric  into :val_short from test4;
select col_float + col_monetary  into :val_short from test4;

select col_double + col_short  into :val_short from test4;
select col_double + col_int  into :val_short from test4;
select col_double + col_bigint  into :val_short from test4;
select col_double + col_float  into :val_short from test4;
select col_double + col_double  into :val_short from test4;
select col_double + col_numeric  into :val_short from test4;
select col_double + col_monetary  into :val_short from test4;

select col_numeric + col_short  into :val_short from test4;
select col_numeric + col_int  into :val_short from test4;
select col_numeric + col_bigint  into :val_short from test4;
select col_numeric + col_float  into :val_short from test4;
select col_numeric + col_double  into :val_short from test4;
select col_numeric + col_numeric  into :val_short from test4;
select col_numeric + col_monetary  into :val_short from test4;

select col_monetary + col_short  into :val_short from test4;
select col_monetary + col_int  into :val_short from test4;
select col_monetary + col_bigint  into :val_short from test4;
select col_monetary + col_float  into :val_short from test4;
select col_monetary + col_double  into :val_short from test4;
select col_monetary + col_numeric  into :val_short from test4;
select col_monetary + col_monetary  into :val_short from test4;


select col_short - col_short  into :val_short from test4;
select col_short - col_int  into :val_short from test4;
select col_short - col_bigint  into :val_short from test4;
select col_short - col_float  into :val_short from test4;
select col_short - col_double  into :val_short from test4;
select col_short - col_numeric  into :val_short from test4;
select col_short - col_monetary  into :val_short from test4;

select col_int - col_short  into :val_short from test4;
select col_int - col_int  into :val_short from test4;
select col_int - col_bigint  into :val_short from test4;
select col_int - col_float  into :val_short from test4;
select col_int - col_double  into :val_short from test4;
select col_int - col_numeric  into :val_short from test4;
select col_int - col_monetary  into :val_short from test4;

select col_bigint - col_short  into :val_short from test4;
select col_bigint - col_int  into :val_short from test4;
select col_bigint - col_bigint  into :val_short from test4;
select col_bigint - col_float  into :val_short from test4;
select col_bigint - col_double  into :val_short from test4;
select col_bigint - col_numeric  into :val_short from test4;
select col_bigint - col_monetary  into :val_short from test4;

select col_float - col_short  into :val_short from test4;
select col_float - col_int  into :val_short from test4;
select col_float - col_bigint  into :val_short from test4;
select col_float - col_float  into :val_short from test4;
select col_float - col_double  into :val_short from test4;
select col_float - col_numeric  into :val_short from test4;
select col_float - col_monetary  into :val_short from test4;

select col_double - col_short  into :val_short from test4;
select col_double - col_int  into :val_short from test4;
select col_double - col_bigint  into :val_short from test4;
select col_double - col_float  into :val_short from test4;
select col_double - col_double  into :val_short from test4;
select col_double - col_numeric  into :val_short from test4;
select col_double - col_monetary  into :val_short from test4;

select col_numeric - col_short  into :val_short from test4;
select col_numeric - col_int  into :val_short from test4;
select col_numeric - col_bigint  into :val_short from test4;
select col_numeric - col_float  into :val_short from test4;
select col_numeric - col_double  into :val_short from test4;
select col_numeric - col_numeric  into :val_short from test4;
select col_numeric - col_monetary  into :val_short from test4;

select col_monetary - col_short  into :val_short from test4;
select col_monetary - col_int  into :val_short from test4;
select col_monetary - col_bigint  into :val_short from test4;
select col_monetary - col_float  into :val_short from test4;
select col_monetary - col_double  into :val_short from test4;
select col_monetary - col_numeric  into :val_short from test4;
select col_monetary - col_monetary  into :val_short from test4;



select col_short / col_short  into :val_short from test4;
select col_short / col_int  into :val_short from test4;
select col_short / col_bigint  into :val_short from test4;
select col_short / col_float  into :val_short from test4;
select col_short / col_double  into :val_short from test4;
select col_short / col_numeric  into :val_short from test4;
select col_short / col_monetary  into :val_short from test4;

select col_int / col_short  into :val_short from test4;
select col_int / col_int  into :val_short from test4;
select col_int / col_bigint  into :val_short from test4;
select col_int / col_float  into :val_short from test4;
select col_int / col_double  into :val_short from test4;
select col_int / col_numeric  into :val_short from test4;
select col_int / col_monetary  into :val_short from test4;

select col_bigint / col_short  into :val_short from test4;
select col_bigint / col_int  into :val_short from test4;
select col_bigint / col_bigint  into :val_short from test4;
select col_bigint / col_float  into :val_short from test4;
select col_bigint / col_double  into :val_short from test4;
select col_bigint / col_numeric  into :val_short from test4;
select col_bigint / col_monetary  into :val_short from test4;

select col_float / col_short  into :val_short from test4;
select col_float / col_int  into :val_short from test4;
select col_float / col_bigint  into :val_short from test4;
select col_float / col_float  into :val_short from test4;
select col_float / col_double  into :val_short from test4;
select col_float / col_numeric  into :val_short from test4;
select col_float / col_monetary  into :val_short from test4;

select col_double / col_short  into :val_short from test4;
select col_double / col_int  into :val_short from test4;
select col_double / col_bigint  into :val_short from test4;
select col_double / col_float  into :val_short from test4;
select col_double / col_double  into :val_short from test4;
select col_double / col_numeric  into :val_short from test4;
select col_double / col_monetary  into :val_short from test4;

select col_numeric / col_short  into :val_short from test4;
select col_numeric / col_int  into :val_short from test4;
select col_numeric / col_bigint  into :val_short from test4;
select col_numeric / col_float  into :val_short from test4;
select col_numeric / col_double  into :val_short from test4;
select col_numeric / col_numeric  into :val_short from test4;
select col_numeric / col_monetary  into :val_short from test4;

select col_monetary / col_short  into :val_short from test4;
select col_monetary / col_int  into :val_short from test4;
select col_monetary / col_bigint  into :val_short from test4;
select col_monetary / col_float  into :val_short from test4;
select col_monetary / col_double  into :val_short from test4;
select col_monetary / col_numeric  into :val_short from test4;
select col_monetary / col_monetary  into :val_short from test4;


select col_short * col_short  into :val_short from test4;
select col_short * col_int  into :val_short from test4;
select col_short * col_bigint  into :val_short from test4;
select col_short * col_float  into :val_short from test4;
select col_short * col_double  into :val_short from test4;
select col_short * col_numeric  into :val_short from test4;
select col_short * col_monetary  into :val_short from test4;

select col_int * col_short  into :val_short from test4;
select col_int * col_int  into :val_short from test4;
select col_int * col_bigint  into :val_short from test4;
select col_int * col_float  into :val_short from test4;
select col_int * col_double  into :val_short from test4;
select col_int * col_numeric  into :val_short from test4;
select col_int * col_monetary  into :val_short from test4;

select col_bigint * col_short  into :val_short from test4;
select col_bigint * col_int  into :val_short from test4;
select col_bigint * col_bigint  into :val_short from test4;
select col_bigint * col_float  into :val_short from test4;
select col_bigint * col_double  into :val_short from test4;
select col_bigint * col_numeric  into :val_short from test4;
select col_bigint * col_monetary  into :val_short from test4;

select col_float * col_short  into :val_short from test4;
select col_float * col_int  into :val_short from test4;
select col_float * col_bigint  into :val_short from test4;
select col_float * col_float  into :val_short from test4;
select col_float * col_double  into :val_short from test4;
select col_float * col_numeric  into :val_short from test4;
select col_float * col_monetary  into :val_short from test4;

select col_double * col_short  into :val_short from test4;
select col_double * col_int  into :val_short from test4;
select col_double * col_bigint  into :val_short from test4;
select col_double * col_float  into :val_short from test4;
select col_double * col_double  into :val_short from test4;
select col_double * col_numeric  into :val_short from test4;
select col_double * col_monetary  into :val_short from test4;

select col_numeric * col_short  into :val_short from test4;
select col_numeric * col_int  into :val_short from test4;
select col_numeric * col_bigint  into :val_short from test4;
select col_numeric * col_float  into :val_short from test4;
select col_numeric * col_double  into :val_short from test4;
select col_numeric * col_numeric  into :val_short from test4;
select col_numeric * col_monetary  into :val_short from test4;

select col_monetary * col_short  into :val_short from test4;
select col_monetary * col_int  into :val_short from test4;
select col_monetary * col_bigint  into :val_short from test4;
select col_monetary * col_float  into :val_short from test4;
select col_monetary * col_double  into :val_short from test4;
select col_monetary * col_numeric  into :val_short from test4;
select col_monetary * col_monetary  into :val_short from test4;


select col_short into :val_short from test4;
select col_int into :val_int from test4;
select col_bigint into :val_bigint from test4;
select col_double into :val_double from test4;
select col_numeric into :val_numeric from test4;
select col_monetary into :val_monetary from test4;
select col_time into :val_time from test4;
select col_date into :val_date from test4;
select col_timestamp into :val_timestamp from test4;
select col_datetime into :val_datetime from test4;
select col_char into :val_char from test4;



select col_time + :val_short, col_time + :val_int, col_time + :val_bigint from test4;
select col_date + :val_short, col_date + :val_int, col_date + :val_bigint from test4;
select col_timestamp + :val_short, col_timestamp + :val_int, col_timestamp + :val_bigint from test4;
select col_datetime + :val_short, col_datetime + :val_int, col_datetime + :val_bigint from test4;



select col_time - :val_short, col_time - :val_int, col_time - :val_bigint from test4;
select col_date - :val_short, col_date - :val_int, col_date - :val_bigint from test4;
select col_timestamp - :val_short, col_timestamp - :val_int, col_timestamp - :val_bigint from test4;
select col_datetime - :val_short, col_datetime - :val_int, col_datetime - :val_bigint from test4;

select col_short + :val_short, col_short + :val_int, col_short + :val_bigint, col_short + :val_double, col_short + :val_numeric, col_short + :val_monetary from test4;
select col_int + :val_short, col_int + :val_int, col_int + :val_bigint, col_int + :val_double, col_int + :val_numeric, col_int + :val_monetary from test4;
select col_bigint + :val_short, col_bigint + :val_int, col_bigint + :val_bigint, col_bigint + :val_double, col_bigint + :val_numeric, col_bigint + :val_monetary from test4;
select col_double + :val_short, col_double + :val_int, col_double + :val_bigint, col_double + :val_double, col_double + :val_numeric, col_double + :val_monetary from test4;
select col_numeric + :val_short, col_numeric + :val_int, col_numeric + :val_bigint, col_numeric + :val_double, col_numeric + :val_numeric, col_numeric + :val_monetary from test4;
select col_monetary + :val_short, col_monetary + :val_int, col_monetary + :val_bigint, col_monetary + :val_double, col_monetary + :val_numeric, col_monetary + :val_monetary from test4;


select col_short - :val_short, col_short - :val_int, col_short - :val_bigint, col_short - :val_double, col_short - :val_numeric, col_short - :val_monetary from test4;
select col_int - :val_short, col_int - :val_int, col_int - :val_bigint, col_int - :val_double, col_int - :val_numeric, col_int - :val_monetary from test4;
select col_bigint - :val_short, col_bigint - :val_int, col_bigint - :val_bigint, col_bigint - :val_double, col_bigint - :val_numeric, col_bigint - :val_monetary from test4;
select col_double - :val_short, col_double - :val_int, col_double - :val_bigint, col_double - :val_double, col_double - :val_numeric, col_double - :val_monetary from test4;
select col_numeric - :val_short, col_numeric - :val_int, col_numeric - :val_bigint, col_numeric - :val_double, col_numeric - :val_numeric, col_numeric - :val_monetary from test4;
select col_monetary - :val_short, col_monetary - :val_int, col_monetary - :val_bigint, col_monetary - :val_double, col_monetary - :val_numeric, col_monetary - :val_monetary from test4;


select col_short / :val_short, col_short / :val_int, col_short / :val_bigint, col_short / :val_double, col_short / :val_numeric, col_short / :val_monetary from test4;
select col_int / :val_short, col_int / :val_int, col_int / :val_bigint, col_int / :val_double, col_int / :val_numeric, col_int / :val_monetary from test4;
select col_bigint / :val_short, col_bigint / :val_int, col_bigint / :val_bigint, col_bigint / :val_double, col_bigint / :val_numeric, col_bigint / :val_monetary from test4;
select col_double / :val_short, col_double / :val_int, col_double / :val_bigint, col_double / :val_double, col_double / :val_numeric, col_double / :val_monetary from test4;
select col_numeric / :val_short, col_numeric / :val_int, col_numeric / :val_bigint, col_numeric / :val_double, col_numeric / :val_numeric, col_numeric / :val_monetary from test4;
select col_monetary / :val_short, col_monetary / :val_int, col_monetary / :val_bigint, col_monetary / :val_double, col_monetary / :val_numeric, col_monetary / :val_monetary from test4;


select col_short * :val_short, col_short * :val_int, col_short * :val_bigint, col_short * :val_double, col_short * :val_numeric, col_short * :val_monetary from test4;
select col_int * :val_short, col_int * :val_int, col_int * :val_bigint, col_int * :val_double, col_int * :val_numeric, col_int * :val_monetary from test4;
select col_bigint * :val_short, col_bigint * :val_int, col_bigint * :val_bigint, col_bigint * :val_double, col_bigint * :val_numeric, col_bigint * :val_monetary from test4;
select col_double * :val_short, col_double * :val_int, col_double * :val_bigint, col_double * :val_double, col_double * :val_numeric, col_double * :val_monetary from test4;
select col_numeric * :val_short, col_numeric * :val_int, col_numeric * :val_bigint, col_numeric * :val_double, col_numeric * :val_numeric, col_numeric * :val_monetary from test4;
select col_monetary * :val_short, col_monetary * :val_int, col_monetary * :val_bigint, col_monetary * :val_double, col_monetary * :val_numeric, col_monetary * :val_monetary from test4;


select :val_time + :val_short, :val_time + :val_int, :val_time + :val_bigint from test4;
select :val_date + :val_short, :val_date + :val_int, :val_date + :val_bigint from test4;
select :val_timestamp + :val_short, :val_timestamp + :val_int, :val_timestamp + :val_bigint from test4;
select :val_datetime + :val_short, :val_datetime + :val_int, :val_datetime + :val_bigint from test4;



select :val_time - :val_short, :val_time - :val_int, :val_time - :val_bigint from test4;
select :val_date - :val_short, :val_date - :val_int, :val_date - :val_bigint from test4;
select :val_timestamp - :val_short, :val_timestamp - :val_int, :val_timestamp - :val_bigint from test4;
select :val_datetime - :val_short, :val_datetime - :val_int, :val_datetime - :val_bigint from test4;

select :val_short + :val_short, :val_short + :val_int, :val_short + :val_bigint, :val_short + :val_double, :val_short + :val_numeric, :val_short + :val_monetary from test4;
select :val_int + :val_short, :val_int + :val_int, :val_int + :val_bigint, :val_int + :val_double, :val_int + :val_numeric, :val_int + :val_monetary from test4;
select :val_bigint + :val_short, :val_bigint + :val_int, :val_bigint + :val_bigint, :val_bigint + :val_double, :val_bigint + :val_numeric, :val_bigint + :val_monetary from test4;
select :val_double + :val_short, :val_double + :val_int, :val_double + :val_bigint, :val_double + :val_double, :val_double + :val_numeric, :val_double + :val_monetary from test4;
select :val_numeric + :val_short, :val_numeric + :val_int, :val_numeric + :val_bigint, :val_numeric + :val_double, :val_numeric + :val_numeric, :val_numeric + :val_monetary from test4;
select :val_monetary + :val_short, :val_monetary + :val_int, :val_monetary + :val_bigint, :val_monetary + :val_double, :val_monetary + :val_numeric, :val_monetary + :val_monetary from test4;


select :val_short - :val_short, :val_short - :val_int, :val_short - :val_bigint, :val_short - :val_double, :val_short - :val_numeric, :val_short - :val_monetary from test4;
select :val_int - :val_short, :val_int - :val_int, :val_int - :val_bigint, :val_int - :val_double, :val_int - :val_numeric, :val_int - :val_monetary from test4;
select :val_bigint - :val_short, :val_bigint - :val_int, :val_bigint - :val_bigint, :val_bigint - :val_double, :val_bigint - :val_numeric, :val_bigint - :val_monetary from test4;
select :val_double - :val_short, :val_double - :val_int, :val_double - :val_bigint, :val_double - :val_double, :val_double - :val_numeric, :val_double - :val_monetary from test4;
select :val_numeric - :val_short, :val_numeric - :val_int, :val_numeric - :val_bigint, :val_numeric - :val_double, :val_numeric - :val_numeric, :val_numeric - :val_monetary from test4;
select :val_monetary - :val_short, :val_monetary - :val_int, :val_monetary - :val_bigint, :val_monetary - :val_double, :val_monetary - :val_numeric, :val_monetary - :val_monetary from test4;


select :val_short / :val_short, :val_short / :val_int, :val_short / :val_bigint, :val_short / :val_double, :val_short / :val_numeric, :val_short / :val_monetary from test4;
select :val_int / :val_short, :val_int / :val_int, :val_int / :val_bigint, :val_int / :val_double, :val_int / :val_numeric, :val_int / :val_monetary from test4;
select :val_bigint / :val_short, :val_bigint / :val_int, :val_bigint / :val_bigint, :val_bigint / :val_double, :val_bigint / :val_numeric, :val_bigint / :val_monetary from test4;
select :val_double / :val_short, :val_double / :val_int, :val_double / :val_bigint, :val_double / :val_double, :val_double / :val_numeric, :val_double / :val_monetary from test4;
select :val_numeric / :val_short, :val_numeric / :val_int, :val_numeric / :val_bigint, :val_numeric / :val_double, :val_numeric / :val_numeric, :val_numeric / :val_monetary from test4;
select :val_monetary / :val_short, :val_monetary / :val_int, :val_monetary / :val_bigint, :val_monetary / :val_double, :val_monetary / :val_numeric, :val_monetary / :val_monetary from test4;


select :val_short * :val_short, :val_short * :val_int, :val_short * :val_bigint, :val_short * :val_double, :val_short * :val_numeric, :val_short * :val_monetary from test4;
select :val_int * :val_short, :val_int * :val_int, :val_int * :val_bigint, :val_int * :val_double, :val_int * :val_numeric, :val_int * :val_monetary from test4;
select :val_bigint * :val_short, :val_bigint * :val_int, :val_bigint * :val_bigint, :val_bigint * :val_double, :val_bigint * :val_numeric, :val_bigint * :val_monetary from test4;
select :val_double * :val_short, :val_double * :val_int, :val_double * :val_bigint, :val_double * :val_double, :val_double * :val_numeric, :val_double * :val_monetary from test4;
select :val_numeric * :val_short, :val_numeric * :val_int, :val_numeric * :val_bigint, :val_numeric * :val_double, :val_numeric * :val_numeric, :val_numeric * :val_monetary from test4;
select :val_monetary * :val_short, :val_monetary * :val_int, :val_monetary * :val_bigint, :val_monetary * :val_double, :val_monetary * :val_numeric, :val_monetary * :val_monetary from test4;









drop table test1;
drop table test2;
drop table test3;

create table test1 (
col_short short,
col_int int,
col_bigint bigint,
col_float float,
col_double double,
col_numeric numeric,
col_monetary monetary,
col_char char(20)
);

create table test2 (
col_short short,
col_int int,
col_bigint bigint,
col_float float,
col_double double,
col_numeric numeric,
col_monetary monetary,
col_char char(20)
);

create table test3 (
col_short short,
col_int int,
col_bigint bigint,
col_float float,
col_double double,
col_numeric numeric,
col_monetary monetary,
col_time time,
col_date date,
col_timestamp timestamp,
col_datetime datetime
);

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

insert into test1 values(2, 2, 2, 2, 3, 2, 2, 'a');
insert into test2 values(-1, -2, -2, -2, -3, -2, -2, 'a');
insert into test2 values(0, 0, 0, 0, 0, 0, 0, 'a');
insert into test2 values(1, 2, 2, 2, 3, 2, 2, 'a');

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

update test3 set col_short = col_short + col_short;
update test3 set col_short = col_int + col_short;
update test3 set col_short = col_bigint + col_short;
update test3 set col_short = col_float + col_short;
update test3 set col_short = col_double + col_short;
update test3 set col_short = col_numeric + col_short;
update test3 set col_short = col_monetary + col_short;

update test3 set col_int = col_short + col_short;
update test3 set col_int = col_int + col_short;
update test3 set col_int = col_bigint + col_short;
update test3 set col_int = col_float + col_short;
update test3 set col_int = col_double + col_short;
update test3 set col_int = col_numeric + col_short;
update test3 set col_int = col_monetary + col_short;

update test3 set col_bigint = col_short + col_short;
update test3 set col_bigint = col_int + col_short;
update test3 set col_bigint = col_bigint + col_short;
update test3 set col_bigint = col_float + col_short;
update test3 set col_bigint = col_double + col_short;
update test3 set col_bigint = col_numeric + col_short;
update test3 set col_bigint = col_monetary + col_short;

update test3 set col_float = col_short + col_short;
update test3 set col_float = col_int + col_short;
update test3 set col_float = col_bigint + col_short;
update test3 set col_float = col_float + col_short;
update test3 set col_float = col_double + col_short;
update test3 set col_float = col_numeric + col_short;
update test3 set col_float = col_monetary + col_short;

update test3 set col_double = col_short + col_short;
update test3 set col_double = col_int + col_short;
update test3 set col_double = col_bigint + col_short;
update test3 set col_double = col_float + col_short;
update test3 set col_double = col_double + col_short;
update test3 set col_double = col_numeric + col_short;
update test3 set col_double = col_monetary + col_short;

update test3 set col_numeric = col_short + col_short;
update test3 set col_numeric = col_int + col_short;
update test3 set col_numeric = col_bigint + col_short;
update test3 set col_numeric = col_float + col_short;
update test3 set col_numeric = col_double + col_short;
update test3 set col_numeric = col_numeric + col_short;
update test3 set col_numeric = col_monetary + col_short;

update test3 set col_monetary = col_short + col_short;
update test3 set col_monetary = col_int + col_short;
update test3 set col_monetary = col_bigint + col_short;
update test3 set col_monetary = col_float + col_short;
update test3 set col_monetary = col_double + col_short;
update test3 set col_monetary = col_numeric + col_short;
update test3 set col_monetary = col_monetary + col_short;

update test3 set col_short = col_short - col_short;
update test3 set col_short = col_int - col_short;
update test3 set col_short = col_bigint - col_short;
update test3 set col_short = col_float - col_short;
update test3 set col_short = col_double - col_short;
update test3 set col_short = col_numeric - col_short;
update test3 set col_short = col_monetary - col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

update test3 set col_int = col_short - col_short;
update test3 set col_int = col_int - col_short;
update test3 set col_int = col_bigint - col_short;
update test3 set col_int = col_float - col_short;
update test3 set col_int = col_double - col_short;
update test3 set col_int = col_numeric - col_short;
update test3 set col_int = col_monetary - col_short;

update test3 set col_bigint = col_short - col_short;
update test3 set col_bigint = col_int - col_short;
update test3 set col_bigint = col_bigint - col_short;
update test3 set col_bigint = col_float - col_short;
update test3 set col_bigint = col_double - col_short;
update test3 set col_bigint = col_numeric - col_short;
update test3 set col_bigint = col_monetary - col_short;

update test3 set col_float = col_short - col_short;
update test3 set col_float = col_int - col_short;
update test3 set col_float = col_bigint - col_short;
update test3 set col_float = col_float - col_short;
update test3 set col_float = col_double - col_short;
update test3 set col_float = col_numeric - col_short;
update test3 set col_float = col_monetary - col_short;

update test3 set col_double = col_short - col_short;
update test3 set col_double = col_int - col_short;
update test3 set col_double = col_bigint - col_short;
update test3 set col_double = col_float - col_short;
update test3 set col_double = col_double - col_short;
update test3 set col_double = col_numeric - col_short;
update test3 set col_double = col_monetary - col_short;

update test3 set col_numeric = col_short - col_short;
update test3 set col_numeric = col_int - col_short;
update test3 set col_numeric = col_bigint - col_short;
update test3 set col_numeric = col_float - col_short;
update test3 set col_numeric = col_double - col_short;
update test3 set col_numeric = col_numeric - col_short;
update test3 set col_numeric = col_monetary - col_short;

update test3 set col_monetary = col_short - col_short;
update test3 set col_monetary = col_int - col_short;
update test3 set col_monetary = col_bigint - col_short;
update test3 set col_monetary = col_float - col_short;
update test3 set col_monetary = col_double - col_short;
update test3 set col_monetary = col_numeric - col_short;
update test3 set col_monetary = col_monetary - col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

update test3 set col_short = col_short / col_short;
update test3 set col_short = col_int / col_short;
update test3 set col_short = col_bigint / col_short;
update test3 set col_short = col_float / col_short;
update test3 set col_short = col_double / col_short;
update test3 set col_short = col_numeric / col_short;
update test3 set col_short = col_monetary / col_short;

update test3 set col_int = col_short / col_short;
update test3 set col_int = col_int / col_short;
update test3 set col_int = col_bigint / col_short;
update test3 set col_int = col_float / col_short;
update test3 set col_int = col_double / col_short;
update test3 set col_int = col_numeric / col_short;
update test3 set col_int = col_monetary / col_short;

update test3 set col_bigint = col_short / col_short;
update test3 set col_bigint = col_int / col_short;
update test3 set col_bigint = col_bigint / col_short;
update test3 set col_bigint = col_float / col_short;
update test3 set col_bigint = col_double / col_short;
update test3 set col_bigint = col_numeric / col_short;
update test3 set col_bigint = col_monetary / col_short;

update test3 set col_float = col_short / col_short;
update test3 set col_float = col_int / col_short;
update test3 set col_float = col_bigint / col_short;
update test3 set col_float = col_float / col_short;
update test3 set col_float = col_double / col_short;
update test3 set col_float = col_numeric / col_short;
update test3 set col_float = col_monetary / col_short;

update test3 set col_double = col_short / col_short;
update test3 set col_double = col_int / col_short;
update test3 set col_double = col_bigint / col_short;
update test3 set col_double = col_float / col_short;
update test3 set col_double = col_double / col_short;
update test3 set col_double = col_numeric / col_short;
update test3 set col_double = col_monetary / col_short;

update test3 set col_numeric = col_short / col_short;
update test3 set col_numeric = col_int / col_short;
update test3 set col_numeric = col_bigint / col_short;
update test3 set col_numeric = col_float / col_short;
update test3 set col_numeric = col_double / col_short;
update test3 set col_numeric = col_numeric / col_short;
update test3 set col_numeric = col_monetary / col_short;

update test3 set col_monetary = col_short / col_short;
update test3 set col_monetary = col_int / col_short;
update test3 set col_monetary = col_bigint / col_short;
update test3 set col_monetary = col_float / col_short;
update test3 set col_monetary = col_double / col_short;
update test3 set col_monetary = col_numeric / col_short;
update test3 set col_monetary = col_monetary / col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

update test3 set col_short = col_short * col_short;
update test3 set col_short = col_int * col_short;
update test3 set col_short = col_bigint * col_short;
update test3 set col_short = col_float * col_short;
update test3 set col_short = col_double * col_short;
update test3 set col_short = col_numeric * col_short;
update test3 set col_short = col_monetary * col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');
update test3 set col_int = col_short * col_short;
update test3 set col_int = col_int * col_short;
update test3 set col_int = col_bigint * col_short;
update test3 set col_int = col_float * col_short;
update test3 set col_int = col_double * col_short;
update test3 set col_int = col_numeric * col_short;
update test3 set col_int = col_monetary * col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');
update test3 set col_bigint = col_short * col_short;
update test3 set col_bigint = col_int * col_short;
update test3 set col_bigint = col_bigint * col_short;
update test3 set col_bigint = col_float * col_short;
update test3 set col_bigint = col_double * col_short;
update test3 set col_bigint = col_numeric * col_short;
update test3 set col_bigint = col_monetary * col_short;

update test3 set col_float = col_short * col_short;
update test3 set col_float = col_int * col_short;
update test3 set col_float = col_bigint * col_short;
update test3 set col_float = col_float * col_short;
update test3 set col_float = col_double * col_short;
update test3 set col_float = col_numeric * col_short;
update test3 set col_float = col_monetary * col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');
update test3 set col_double = col_short * col_short;
update test3 set col_double = col_int * col_short;
update test3 set col_double = col_bigint * col_short;
update test3 set col_double = col_float * col_short;
update test3 set col_double = col_double * col_short;
update test3 set col_double = col_numeric * col_short;
update test3 set col_double = col_monetary * col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');
update test3 set col_numeric = col_short * col_short;
update test3 set col_numeric = col_int * col_short;
update test3 set col_numeric = col_bigint * col_short;
update test3 set col_numeric = col_float * col_short;
update test3 set col_numeric = col_double * col_short;
update test3 set col_numeric = col_numeric * col_short;
update test3 set col_numeric = col_monetary * col_short;

delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');
update test3 set col_monetary = col_short * col_short;
update test3 set col_monetary = col_int * col_short;
update test3 set col_monetary = col_bigint * col_short;
update test3 set col_monetary = col_float * col_short;
update test3 set col_monetary = col_double * col_short;
update test3 set col_monetary = col_numeric * col_short;
update test3 set col_monetary = col_monetary * col_short;


delete from test3;
insert into test3 values(2, 2, 2, 2, 3, 2, 2, TIME '10:20:30 AM', DATE '12/25/1999', TIMESTAMP '10:20:30 AM 12/25/1999', DATETIME'10:12:13 6/5/2009');

update test3 set col_short = col_time - col_time;
update test3 set col_short = col_date - col_date;
update test3 set col_short = col_timestamp - col_timestamp;
update test3 set col_short = col_datetime - col_datetime;

update test3 set col_int = col_time - col_time;
update test3 set col_int = col_date - col_date;
update test3 set col_int = col_timestamp - col_timestamp;
update test3 set col_int = col_datetime - col_datetime;

update test3 set col_bigint = col_time - col_time;
update test3 set col_bigint = col_date - col_date;
update test3 set col_bigint = col_timestamp - col_timestamp;
update test3 set col_bigint = col_datetime - col_datetime;

update test3 set col_float = col_time - col_time;
update test3 set col_float = col_date - col_date;
update test3 set col_float = col_timestamp - col_timestamp;
update test3 set col_float = col_datetime - col_datetime;

update test3 set col_double = col_time - col_time;
update test3 set col_double = col_date - col_date;
update test3 set col_double = col_timestamp - col_timestamp;
update test3 set col_double = col_datetime - col_datetime;

update test3 set col_numeric = col_time - col_time;
update test3 set col_numeric = col_date - col_date;
update test3 set col_numeric = col_timestamp - col_timestamp;
update test3 set col_numeric = col_datetime - col_datetime;

update test3 set col_monetary = col_time - col_time;
update test3 set col_monetary = col_date - col_date;
update test3 set col_monetary = col_timestamp - col_timestamp;
update test3 set col_monetary = col_datetime - col_datetime;


update test3 set col_time = col_time + col_int;
update test3 set col_time = col_time + col_bigint;
update test3 set col_time = col_time - col_int;
update test3 set col_time = col_time - col_bigint;

update test3 set col_date = col_date + col_int;
update test3 set col_date = col_date + col_bigint;
update test3 set col_date = col_date - col_int;
update test3 set col_date = col_date - col_bigint;

update test3 set col_timestamp = col_timestamp + col_int;
update test3 set col_timestamp = col_timestamp + col_bigint;
update test3 set col_timestamp = col_timestamp - col_int;
update test3 set col_timestamp = col_timestamp - col_bigint;

update test3 set col_datetime = col_datetime + col_int;
update test3 set col_datetime = col_datetime + col_bigint;
update test3 set col_datetime = col_datetime - col_int;
update test3 set col_datetime = col_datetime - col_bigint;


select col_time + NULL, col_time + col_short, col_time + col_int, col_time + col_bigint from test3;
select col_date + NULL, col_date + col_short, col_date + col_int, col_date + col_bigint from test3;
select col_timestamp + NULL, col_timestamp + col_short, col_timestamp + col_int, col_timestamp + col_bigint from test3;
select col_datetime + NULL, col_datetime + col_short, col_datetime + col_int, col_datetime + col_bigint from test3;

select col_time - NULL, col_time - col_short, col_time - col_int, col_time - col_bigint from test3;
select col_date - NULL, col_date - col_short, col_date - col_int, col_date - col_bigint from test3;
select col_timestamp - NULL, col_timestamp - col_short, col_timestamp - col_int, col_timestamp - col_bigint from test3;
select col_datetime - NULL, col_datetime - col_short, col_datetime - col_int, col_datetime - col_bigint from test3;


select TIME '10:20:30 AM' + NULL, TIME '10:20:30 AM' + col_short, TIME '10:20:30 AM' + col_int, TIME '10:20:30 AM' + col_bigint from test2;
select TIMESTAMP '10:20:30 AM 12/25/1999' + NULL, TIMESTAMP '10:20:30 AM 12/25/1999' + col_short, TIMESTAMP '10:20:30 AM 12/25/1999' + col_int, TIMESTAMP '10:20:30 AM 12/25/1999' + col_bigint from test2;
select DATETIME'10:12:13 6/5/2009' + NULL, DATETIME'10:12:13 6/5/2009' + col_short, DATETIME'10:12:13 6/5/2009' + col_int, DATETIME'10:12:13 6/5/2009' + col_bigint from test2;
select DATE '12/25/1999' - NULL, DATE '12/25/1999' - col_short, DATE '12/25/1999' - col_int, DATE '12/25/1999' - col_bigint from test2;
select TIME '10:20:30 AM' - NULL, TIME '10:20:30 AM' - col_short, TIME '10:20:30 AM' - col_int, TIME '10:20:30 AM' - col_bigint from test2;
select TIMESTAMP '10:20:30 AM 12/25/1999' - NULL, TIMESTAMP '10:20:30 AM 12/25/1999' - col_short, TIMESTAMP '10:20:30 AM 12/25/1999' - col_int, TIMESTAMP '10:20:30 AM 12/25/1999' - col_bigint from test2;
select DATETIME'10:12:13 6/5/2009' - NULL, DATETIME'10:12:13 6/5/2009' - col_short, DATETIME'10:12:13 6/5/2009' - col_int, DATETIME'10:12:13 6/5/2009' - col_bigint from test2;




select GREATEST(col_short, col_int, col_bigint, col_float, col_double, col_numeric, col_monetary) from test2;
select LEAST(col_short, col_int, col_bigint, col_float, col_double, col_numeric, col_monetary) from test2;

select NULL + col_short, col_short + col_short, col_int + col_short, col_bigint + col_short, col_float + col_short, col_double + col_short, col_numeric + col_short, col_monetary + col_short from test2;
select NULL + col_int, col_short + col_int, col_int + col_int, col_bigint + col_int, col_float + col_int, col_double + col_int, col_numeric + col_int, col_monetary + col_int from test2;
select NULL + col_int, col_short + col_int, col_int + col_int, col_bigint + col_int, col_float + col_int, col_double + col_int, col_numeric + col_int, col_monetary + col_int from test2;
select NULL + col_bigint, col_short + col_bigint, col_int + col_bigint, col_bigint + col_bigint, col_float + col_bigint, col_double + col_bigint, col_numeric + col_bigint, col_monetary + col_bigint from test2;
select NULL + col_float, col_short + col_float, col_int + col_float, col_bigint + col_float, col_float + col_float, col_double + col_float, col_numeric + col_float, col_monetary + col_float from test2;
select NULL + col_double, col_short + col_double, col_int + col_double, col_bigint + col_double, col_float + col_double, col_double + col_double, col_numeric + col_double, col_monetary + col_double from test2;
select NULL + col_numeric, col_short + col_numeric, col_int + col_numeric, col_bigint + col_numeric, col_float + col_numeric, col_double + col_numeric, col_numeric + col_numeric, col_monetary + col_numeric from test2;
select NULL + col_monetary, col_short + col_monetary, col_int + col_monetary, col_bigint + col_monetary, col_float + col_monetary, col_double + col_monetary, col_numeric + col_monetary, col_monetary + col_monetary from test2;
select NULL + NULL, col_short + NULL, col_int + NULL, col_bigint + NULL, col_float + NULL, col_double + NULL, col_numeric + NULL, col_monetary + NULL from test2;
select NULL - col_short, col_short - col_short, col_int - col_short, col_bigint - col_short, col_float - col_short, col_double - col_short, col_numeric - col_short, col_monetary - col_short from test2;
select NULL - col_int, col_short - col_int, col_int - col_int, col_bigint - col_int, col_float - col_int, col_double - col_int, col_numeric - col_int, col_monetary - col_int from test2;
select NULL - col_int, col_short - col_int, col_int - col_int, col_bigint - col_int, col_float - col_int, col_double - col_int, col_numeric - col_int, col_monetary - col_int from test2;
select NULL - col_bigint, col_short - col_bigint, col_int - col_bigint, col_bigint - col_bigint, col_float - col_bigint, col_double - col_bigint, col_numeric - col_bigint, col_monetary - col_bigint from test2;
select NULL - col_float, col_short - col_float, col_int - col_float, col_bigint - col_float, col_float - col_float, col_double - col_float, col_numeric - col_float, col_monetary - col_float from test2;
select NULL - col_double, col_short - col_double, col_int - col_double, col_bigint - col_double, col_float - col_double, col_double - col_double, col_numeric - col_double, col_monetary - col_double from test2;
select NULL - col_numeric, col_short - col_numeric, col_int - col_numeric, col_bigint - col_numeric, col_float - col_numeric, col_double - col_numeric, col_numeric - col_numeric, col_monetary - col_numeric from test2;
select NULL - col_monetary, col_short - col_monetary, col_int - col_monetary, col_bigint - col_monetary, col_float - col_monetary, col_double - col_monetary, col_numeric - col_monetary, col_monetary - col_monetary from test2;
select NULL - NULL, col_short - NULL, col_int - NULL, col_bigint - NULL, col_float - NULL, col_double - NULL, col_numeric - NULL, col_monetary - NULL from test2;
select NULL * col_short, col_short * col_short, col_int * col_short, col_bigint * col_short, col_float * col_short, col_double * col_short, col_numeric * col_short, col_monetary * col_short from test2;
select NULL * col_int, col_short * col_int, col_int * col_int, col_bigint * col_int, col_float * col_int, col_double * col_int, col_numeric * col_int, col_monetary * col_int from test2;
select NULL * col_int, col_short * col_int, col_int * col_int, col_bigint * col_int, col_float * col_int, col_double * col_int, col_numeric * col_int, col_monetary * col_int from test2;
select NULL * col_bigint, col_short * col_bigint, col_int * col_bigint, col_bigint * col_bigint, col_float * col_bigint, col_double * col_bigint, col_numeric * col_bigint, col_monetary * col_bigint from test2;
select NULL * col_float, col_short * col_float, col_int * col_float, col_bigint * col_float, col_float * col_float, col_double * col_float, col_numeric * col_float, col_monetary * col_float from test2;
select NULL * col_double, col_short * col_double, col_int * col_double, col_bigint * col_double, col_float * col_double, col_double * col_double, col_numeric * col_double, col_monetary * col_double from test2;
select NULL * col_numeric, col_short * col_numeric, col_int * col_numeric, col_bigint * col_numeric, col_float * col_numeric, col_double * col_numeric, col_numeric * col_numeric, col_monetary * col_numeric from test2;
select NULL * col_monetary, col_short * col_monetary, col_int * col_monetary, col_bigint * col_monetary, col_float * col_monetary, col_double * col_monetary, col_numeric * col_monetary, col_monetary * col_monetary from test2;
select NULL * NULL, col_short * NULL, col_int * NULL, col_bigint * NULL, col_float * NULL, col_double * NULL, col_numeric * NULL, col_monetary * NULL from test2;
select NULL / col_short, col_short / col_short, col_int / col_short, col_bigint / col_short, col_float / col_short, col_double / col_short, col_numeric / col_short, col_monetary / col_short from test2;
select NULL / col_int, col_short / col_int, col_int / col_int, col_bigint / col_int, col_float / col_int, col_double / col_int, col_numeric / col_int, col_monetary / col_int from test2;
select NULL / col_int, col_short / col_int, col_int / col_int, col_bigint / col_int, col_float / col_int, col_double / col_int, col_numeric / col_int, col_monetary / col_int from test2;
select NULL / col_bigint, col_short / col_bigint, col_int / col_bigint, col_bigint / col_bigint, col_float / col_bigint, col_double / col_bigint, col_numeric / col_bigint, col_monetary / col_bigint from test2;
select NULL / col_float, col_short / col_float, col_int / col_float, col_bigint / col_float, col_float / col_float, col_double / col_float, col_numeric / col_float, col_monetary / col_float from test2;
select NULL / col_double, col_short / col_double, col_int / col_double, col_bigint / col_double, col_float / col_double, col_double / col_double, col_numeric / col_double, col_monetary / col_double from test2;
select NULL / col_numeric, col_short / col_numeric, col_int / col_numeric, col_bigint / col_numeric, col_float / col_numeric, col_double / col_numeric, col_numeric / col_numeric, col_monetary / col_numeric from test2;
select NULL / col_monetary, col_short / col_monetary, col_int / col_monetary, col_bigint / col_monetary, col_float / col_monetary, col_double / col_monetary, col_numeric / col_monetary, col_monetary / col_monetary from test2;
select NULL / NULL, col_short / NULL, col_int / NULL, col_bigint / NULL, col_float / NULL, col_double / NULL, col_numeric / NULL, col_monetary / NULL from test2;


select DATE '12/25/1999' + NULL, DATE '12/25/1999' + col_short, DATE '12/25/1999' + col_int, DATE '12/25/1999' + col_bigint from test2;
select TIME '10:20:30 AM' + NULL, TIME '10:20:30 AM' + col_short, TIME '10:20:30 AM' + col_int, TIME '10:20:30 AM' + col_bigint from test2;
select TIMESTAMP '10:20:30 AM 12/25/1999' + NULL, TIMESTAMP '10:20:30 AM 12/25/1999' + col_short, TIMESTAMP '10:20:30 AM 12/25/1999' + col_int, TIMESTAMP '10:20:30 AM 12/25/1999' + col_bigint from test2;
select DATETIME'10:12:13 6/5/2009' + NULL, DATETIME'10:12:13 6/5/2009' + col_short, DATETIME'10:12:13 6/5/2009' + col_int, DATETIME'10:12:13 6/5/2009' + col_bigint from test2;
select DATE '12/25/1999' - NULL, DATE '12/25/1999' - col_short, DATE '12/25/1999' - col_int, DATE '12/25/1999' - col_bigint from test2;
select TIME '10:20:30 AM' - NULL, TIME '10:20:30 AM' - col_short, TIME '10:20:30 AM' - col_int, TIME '10:20:30 AM' - col_bigint from test2;
select TIMESTAMP '10:20:30 AM 12/25/1999' - NULL, TIMESTAMP '10:20:30 AM 12/25/1999' - col_short, TIMESTAMP '10:20:30 AM 12/25/1999' - col_int, TIMESTAMP '10:20:30 AM 12/25/1999' - col_bigint from test2;
select DATETIME'10:12:13 6/5/2009' - NULL, DATETIME'10:12:13 6/5/2009' - col_short, DATETIME'10:12:13 6/5/2009' - col_int, DATETIME'10:12:13 6/5/2009' - col_bigint from test2;


select stddev(NULL), stddev(col_short), stddev(col_int), stddev(col_bigint), stddev(col_float), stddev(col_double), stddev(col_numeric),  stddev(col_monetary) from test2;
select stddev(ALL NULL), stddev(ALL col_short), stddev(ALL col_int), stddev(ALL col_bigint), stddev(ALL col_float), stddev(ALL col_double), stddev(ALL col_numeric),  stddev(ALL col_monetary) from test2;
select stddev(UNIQUE col_short), stddev(UNIQUE col_int), stddev(UNIQUE col_bigint), stddev(UNIQUE col_float), stddev(UNIQUE col_double), stddev(UNIQUE col_numeric),  stddev(UNIQUE col_monetary) from test2;
select stddev(DISTINCT col_short), stddev(DISTINCT col_int), stddev(DISTINCT col_bigint), stddev(DISTINCT col_float), stddev(DISTINCT col_double), stddev(DISTINCT col_numeric),  stddev(DISTINCT col_monetary) from test2;

select VARIANCE(NULL), VARIANCE(col_short), VARIANCE(col_int), VARIANCE(col_bigint), VARIANCE(col_float), VARIANCE(col_double), VARIANCE(col_numeric),  VARIANCE(col_monetary) from test2;
select VARIANCE(ALL NULL), VARIANCE(ALL col_short), VARIANCE(ALL col_int), VARIANCE(ALL col_bigint), VARIANCE(ALL col_float), VARIANCE(ALL col_double), VARIANCE(ALL col_numeric),  VARIANCE(ALL col_monetary) from test2;
select VARIANCE(UNIQUE col_short), VARIANCE(UNIQUE col_int), VARIANCE(UNIQUE col_bigint), VARIANCE(UNIQUE col_float), VARIANCE(UNIQUE col_double), VARIANCE(UNIQUE col_numeric),  VARIANCE(UNIQUE col_monetary) from test2;
select VARIANCE(DISTINCT col_short), VARIANCE(DISTINCT col_int), VARIANCE(DISTINCT col_bigint), VARIANCE(DISTINCT col_float), VARIANCE(DISTINCT col_double), VARIANCE(DISTINCT col_numeric),  VARIANCE(DISTINCT col_monetary) from test2;


select floor(NULL), floor(col_short), floor(col_int), floor(col_bigint), floor(col_float), floor(col_double), floor(col_numeric), floor(col_monetary) from test2;
select ceil(NULL), ceil(col_short), ceil(col_int), ceil(col_bigint), ceil(col_float), ceil(col_double), ceil(col_numeric), ceil(col_monetary) from test2;
select sign(NULL), sign(col_short), sign(col_int), sign(col_bigint), sign(col_float), sign(col_double), sign(col_numeric), sign(col_monetary) from test2;
select abs(NULL), abs(col_short), abs(col_int), abs(col_bigint), abs(col_float), abs(col_double), abs(col_numeric), abs(col_monetary) from test2;
select exp(NULL), exp(col_short), exp(col_int), exp(col_bigint), exp(col_float), to_char(exp(col_double),'9.99999999EEEE'), exp(col_numeric), exp(col_monetary) from test2;
select sqrt(NULL), sqrt(abs(col_short)), sqrt(abs(col_int)), sqrt(abs(col_bigint)), sqrt(abs(col_float)), sqrt(abs(col_double)), sqrt(abs(col_numeric)), sqrt(abs(col_monetary)) from test2;

select power(NULL, col_int), power(col_short, col_int), power(col_int, col_int), power(col_bigint, col_int), to_char(power(col_float, col_int),'9.9999999EEEE'), power(col_double, col_int), power(col_numeric, col_int), power(col_monetary, col_int) from test2;
select power(NULL, col_short), power(col_short, col_short), power(col_int, col_short), power(col_bigint, col_short), to_char(power(col_float, col_short),'9.9999999EEEE'), power(col_double, col_short), power(col_numeric, col_short), power(col_monetary, col_short) from test2;
select power(NULL, col_bigint), power(col_short, col_bigint), power(col_int, col_bigint), power(col_bigint, col_bigint), to_char(power(col_float, col_bigint),'9.9999999EEEE'), power(col_double, col_bigint), power(col_numeric, col_bigint), power(col_monetary, col_bigint) from test2;
select power(NULL, col_float), power(col_short, col_float), power(col_int, col_float), power(col_bigint, col_float), power(col_float, col_float), power(col_double, col_float), power(col_numeric, col_float), power(col_monetary, col_float) from test2;
select power(NULL, col_double), power(col_short, col_double), power(col_int, col_double), power(col_bigint, col_double), power(col_float, col_double), power(col_double, col_double), power(col_numeric, col_double), power(col_monetary, col_double) from test2;
select power(NULL, col_numeric), power(col_short, col_numeric), power(col_int, col_numeric), power(col_bigint, col_numeric), to_char(power(col_float, col_numeric),'9.9999999EEEE'), power(col_double, col_numeric), power(col_numeric, col_numeric), power(col_monetary, col_numeric) from test2;
select power(NULL, col_monetary), power(col_short, col_monetary), power(col_int, col_monetary), power(col_bigint, col_monetary), power(col_float, col_monetary), power(col_double, col_monetary), power(col_numeric, col_monetary), power(col_monetary, col_monetary) from test2;
select power(NULL, NULL), power(col_short, NULL), power(col_int, NULL), power(col_bigint, NULL), power(col_float, NULL), power(col_double, NULL), power(col_numeric, NULL), power(col_monetary, NULL) from test2;



select mod(NULL, col_int), mod(col_short, col_int), mod(col_int, col_int), mod(col_bigint, col_int), mod(col_float, col_int), mod(col_double, col_int), mod(col_numeric, col_int), mod(col_monetary, col_int) from test2;
select mod(NULL, col_short), mod(col_short, col_short), mod(col_int, col_short), mod(col_bigint, col_short), mod(col_float, col_short), mod(col_double, col_short), mod(col_numeric, col_short), mod(col_monetary, col_short) from test2;
select mod(NULL, col_bigint), mod(col_short, col_bigint), mod(col_int, col_bigint), mod(col_bigint, col_bigint), mod(col_float, col_bigint), mod(col_double, col_bigint), mod(col_numeric, col_bigint), mod(col_monetary, col_bigint) from test2;
select mod(NULL, col_float), mod(col_short, col_float), mod(col_int, col_float), mod(col_bigint, col_float), mod(col_float, col_float), mod(col_double, col_float), mod(col_numeric, col_float), mod(col_monetary, col_float) from test2;
select mod(NULL, col_double), mod(col_short, col_double), mod(col_int, col_double), mod(col_bigint, col_double), mod(col_float, col_double), mod(col_double, col_double), mod(col_numeric, col_double), mod(col_monetary, col_double) from test2;
select mod(NULL, col_numeric), mod(col_short, col_numeric), mod(col_int, col_numeric), mod(col_bigint, col_numeric), mod(col_float, col_numeric), mod(col_double, col_numeric), mod(col_numeric, col_numeric), mod(col_monetary, col_numeric) from test2;
select mod(NULL, col_monetary), mod(col_short, col_monetary), mod(col_int, col_monetary), mod(col_bigint, col_monetary), mod(col_float, col_monetary), mod(col_double, col_monetary), mod(col_numeric, col_monetary), mod(col_monetary, col_monetary) from test2;

select round(0.45) from test2;
select round(0.2) from test2;

select round(NULL), round(col_short), round(col_int), round(col_bigint), round(col_float), round(col_double), round(col_numeric), round(col_monetary) from test2;

select trunc(0.45) from test2;
select trunc(0.2) from test2;

select trunc(NULL), trunc(col_short), trunc(col_int), trunc(col_bigint), trunc(col_float), trunc(col_double), trunc(col_numeric), trunc(col_monetary) from test2;

SELECT 1 from test2 where DRAND(1)= DRANDOM(1);
SELECT 1 FROM test2 where RAND(1)= RANDOM(1) ;


select log(NULL, col_int), log(col_short, col_int), log(col_int, col_int), log(col_bigint, col_int), log(col_float, col_int), log(col_double, col_int), log(col_numeric, col_int), log(col_monetary, col_int) from test1;
select log(col_short, NULL), log(col_short, col_short), log(col_short, col_int), log(col_short, col_bigint), log(col_short, col_float), log(col_short, col_double), log(col_short, col_numeric), log(col_short, col_monetary) from test1;
select log(NULL, col_short), log(col_short, col_short), log(col_int, col_short), log(col_bigint, col_short), log(col_float, col_short), log(col_double, col_short), log(col_numeric, col_short), log(col_monetary, col_short) from test1;
select log(NULL, col_bigint), log(col_short, col_bigint), log(col_int, col_bigint), log(col_bigint, col_bigint), log(col_float, col_bigint), log(col_double, col_bigint), log(col_numeric, col_bigint), log(col_monetary, col_bigint) from test1;
select log(NULL, col_float), log(col_short, col_float), log(col_int, col_float), log(col_bigint, col_float), log(col_float, col_float), log(col_double, col_float), log(col_numeric, col_float), log(col_monetary, col_float) from test1;
select log(NULL, col_double), log(col_short, col_double), log(col_int, col_double), log(col_bigint, col_double), log(col_float, col_double), log(col_double, col_double), log(col_numeric, col_double), log(col_monetary, col_double) from test1;
select log(NULL, col_numeric), log(col_short, col_numeric), log(col_int, col_numeric), log(col_bigint, col_numeric), log(col_float, col_numeric), log(col_double, col_numeric), log(col_numeric, col_numeric), log(col_monetary, col_numeric) from test1;
select log(NULL, col_monetary), log(col_short, col_monetary), log(col_int, col_monetary), log(col_bigint, col_monetary), log(col_float, col_monetary), log(col_double, col_monetary), log(col_numeric, col_monetary), log(col_monetary, col_monetary) from test1;


drop table test1;
drop table test2;
drop table test3;
drop table test4; 

--+ holdcas off;
