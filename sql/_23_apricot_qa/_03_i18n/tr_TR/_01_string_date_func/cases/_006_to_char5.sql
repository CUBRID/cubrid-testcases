--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- TO_CHAR (DATETIME, day)
select 'TO_CHAR(datetime, day)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'day','en_US');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'day','ko_KR');

select 'TO_CHAR(datetime, dy)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'dy','en_US');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'dy','ko_KR');


select 'TO_CHAR(datetime, DAY)';
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'DAY','en_US');
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'DAY','ko_KR');


select 'TO_CHAR(datetime, DY)';
--test
SELECT TO_CHAR(datetime'2011-05-01 10:11:12.678', 'DY','en_US');
--test
SELECT TO_CHAR(datetime'2011-05-02 10:11:12.678', 'DY','ko_KR');


select 'TO_CHAR(datetime, MONTH)';
--test
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'MONTH','en_US');
--test
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'MONTH','ko_KR');


select 'TO_CHAR(datetime, month)';
--test
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'month','en_US');
--test
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'month','ko_KR');


select 'TO_CHAR(datetime, MON)';
--test
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'MON','en_US');
--test
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'MON','ko_KR');


select 'TO_CHAR(datetime, mon)';
--test
SELECT TO_CHAR(datetime'2011-01-01 10:11:12.678', 'mon','en_US');
--test
SELECT TO_CHAR(datetime'2011-02-01 10:11:12.678', 'mon','ko_KR');


select 'TO_CHAR(datetime, AM/PM)';
--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS AM','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS PM','ko_KR');
--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS am','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS pm','ko_KR');
--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS Am','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS Pm','ko_KR');

--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS a.m.','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS p.m.','ko_KR');
--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS A.M.','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS A.M.','ko_KR');
--test
SELECT TO_CHAR(datetime'2011-12-01 10:11:12.678', 'HH:MI:SS A.m.','en_US');
--test
SELECT TO_CHAR(datetime'2011-12-01 20:11:12.678', 'HH:MI:SS A.m.','ko_KR');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
