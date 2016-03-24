--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT TO_DATE('2010-01 JAN', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01 月', 'yyyy-dd Mon');
--test
SELECT TO_DATE('2010-01', 'yyyy-dd Mon');
--test
SELECT TO_DATE('12/25/2008');
--test
SELECT TO_DATE('2008-12-25');
--test
SELECT TO_DATE('25/12/2008', 'DD/MM/YYYY');
--test
SELECT TO_DATE('081225', 'YYMMDD');
--test
SELECT TO_DATE('2008-12-25', 'YYYY-MM-DD');
--test
SELECT TO_DATE('2008-12-25', null);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;