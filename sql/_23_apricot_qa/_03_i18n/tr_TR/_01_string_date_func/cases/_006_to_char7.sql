--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- TO_CHAR (DATE, day)
--test
select 'TO_CHAR(DATE, day)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'day', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'day', 'ko_KR' );

select 'TO_CHAR(DATE, dy)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'dy', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'dy', 'ko_KR' );

--test
select 'TO_CHAR(DATE, DAY)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DAY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DAY', 'ko_KR' );

select 'TO_CHAR(DATE, DY)';
SELECT TO_CHAR(DATE'2011-05-01', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DY', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DY', 'ko_KR' );

select 'TO_CHAR(DATE, MONTH)';
SELECT TO_CHAR(DATE'2011-01-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MONTH', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MONTH', 'ko_KR' );

select 'TO_CHAR(DATE, month)';
SELECT TO_CHAR(DATE'2011-01-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'month', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'month', 'ko_KR' );


select 'TO_CHAR(DATE, MON)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MON', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MON', 'ko_KR' );

select 'TO_CHAR(DATE, mon)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'mon', 'ko_KR' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'mon', 'ko_KR' );
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;