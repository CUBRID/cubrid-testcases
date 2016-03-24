--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select makedate('2000-01-01',1);
--test
SELECT makedate('2010-10-04 12:34:56',1);
--test
SELECT makedate('2010-10-04 12:34:56.7890',1);
--test
SELECT makedate('12:34:56',null);
--test
SELECT makedate('2011-05-01 PAZAR',1);
--test
SELECT makedate(null,1);
--test
SELECT makedate(null,null);
--test
SELECT MAKEDATE(2010,277);
--test
SELECT MAKEDATE(10,277);
--test
SELECT MAKEDATE(70,277);
--test
SELECT MAKEDATE(100,3615902);
--test
SELECT MAKEDATE('9999','365');
--test
SELECT MAKEDATE(9999,366);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;