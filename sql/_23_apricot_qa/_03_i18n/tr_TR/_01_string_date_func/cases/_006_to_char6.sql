--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- TO_CHAR (DATE, day)
--test
select 'TO_CHAR(DATE, day)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'day', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'day', 'en_US' );

select 'TO_CHAR(DATE, dy)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'dy', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'dy', 'en_US' );

--test
select 'TO_CHAR(DATE, DAY)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DAY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DAY', 'en_US' );

select 'TO_CHAR(DATE, DY)';
SELECT TO_CHAR(DATE'2011-05-01', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DY', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DY', 'en_US' );

select 'TO_CHAR(DATE, MONTH)';
SELECT TO_CHAR(DATE'2011-01-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MONTH', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MONTH', 'en_US' );

select 'TO_CHAR(DATE, month)';
SELECT TO_CHAR(DATE'2011-01-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'month', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'month', 'en_US' );


select 'TO_CHAR(DATE, MON)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MON', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MON', 'en_US' );

select 'TO_CHAR(DATE, mon)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-02-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-03-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-04-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-05-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-06-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-07-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-08-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-09-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-10-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-11-01', 'mon', 'en_US' );
--test
SELECT TO_CHAR(DATE'2011-12-01', 'mon', 'en_US' );
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
