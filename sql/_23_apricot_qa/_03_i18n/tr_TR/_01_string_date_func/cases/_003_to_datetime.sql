--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT TO_DATETIME('13:10:30 12/25/2008');
--test
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12.678');
--test
SELECT TO_DATETIME('2011-05-01 PAZAR 10:11:12.678',null);
--test
SELECT TO_DATETIME(null);
--test
SELECT TO_DATETIME(null,'yyyy-MM-DD DAY HH:MI:SS.FF');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
