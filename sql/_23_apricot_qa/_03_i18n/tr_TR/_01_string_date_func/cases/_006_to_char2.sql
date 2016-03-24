--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- TO_CHAR (DATE, day)
--test
select 'TO_CHAR(DATE, day)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-02', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-03', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-04', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-05', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-06', 'day');
--test
SELECT TO_CHAR(DATE'2011-05-07', 'day');

select 'TO_CHAR(DATE, dy)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-02', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-03', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-04', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-05', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-06', 'dy');
--test
SELECT TO_CHAR(DATE'2011-05-07', 'dy');

--test
select 'TO_CHAR(DATE, DAY)';
--test
SELECT TO_CHAR(DATE'2011-05-01', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DAY');
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DAY');

select 'TO_CHAR(DATE, DY)';
SELECT TO_CHAR(DATE'2011-05-01', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-02', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-03', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-04', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-05', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-06', 'DY');
--test
SELECT TO_CHAR(DATE'2011-05-07', 'DY');

select 'TO_CHAR(DATE, MONTH)';
SELECT TO_CHAR(DATE'2011-01-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MONTH');
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MONTH');

select 'TO_CHAR(DATE, month)';
SELECT TO_CHAR(DATE'2011-01-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-02-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-03-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-04-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-05-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-06-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-07-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-08-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-09-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-10-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-11-01', 'month');
--test
SELECT TO_CHAR(DATE'2011-12-01', 'month');


select 'TO_CHAR(DATE, MON)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-02-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-03-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-04-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-05-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-06-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-07-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-08-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-09-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-10-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-11-01', 'MON');
--test
SELECT TO_CHAR(DATE'2011-12-01', 'MON');

select 'TO_CHAR(DATE, mon)';
--test
SELECT TO_CHAR(DATE'2011-01-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-02-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-03-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-04-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-05-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-06-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-07-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-08-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-09-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-10-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-11-01', 'mon');
--test
SELECT TO_CHAR(DATE'2011-12-01', 'mon');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;