--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- TO_CHAR (DATETIME, day)
select 'TO_CHAR(datetime, day)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-03 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-04 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-05 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-06 10:11:12.678', 'day');
SELECT TO_CHAR(datetime'2011-05-07 10:11:12.678', 'day');

select 'TO_CHAR(datetime, dy)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-03 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-04 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-05 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-06 10:11:12.678', 'dy');
SELECT TO_CHAR(datetime'2011-05-07 10:11:12.678', 'dy');

select 'TO_CHAR(datetime, DAY)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-03 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-04 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-05 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-06 10:11:12.678', 'DAY');
SELECT TO_CHAR(datetime'2011-05-07 10:11:12.678', 'DAY');

select 'TO_CHAR(datetime, DY)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-03 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-04 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-05 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-06 10:11:12.678', 'DY');
SELECT TO_CHAR(datetime'2011-05-07 10:11:12.678', 'DY');

select 'TO_CHAR(datetime, MONTH)';
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-03-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-04-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-06-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-07-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-08-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-09-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-10-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-11-01 10:11:12.678', 'MONTH');
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'MONTH');

select 'TO_CHAR(datetime, month)';
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-03-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-04-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-06-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-07-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-08-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-09-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-10-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-11-01 10:11:12.678', 'month');
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'month');

select 'TO_CHAR(datetime, MON)';
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-03-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-04-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-06-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-07-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-08-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-09-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-10-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-11-01 10:11:12.678', 'MON');
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'MON');

select 'TO_CHAR(datetime, mon)';
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-03-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-04-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-06-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-07-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-08-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-09-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-10-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-11-01 10:11:12.678', 'mon');
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'mon');

select 'TO_CHAR(datetime, AM/PM)';
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS AM');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS PM');

SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS am');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS pm');

SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS Am');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS Pm');


SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS a.m.');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS p.m.');

SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS A.M.');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS A.M.');

SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS A.m.');
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS A.m.');

-- coverage
select TO_CHAR(cast (12 as float));
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
