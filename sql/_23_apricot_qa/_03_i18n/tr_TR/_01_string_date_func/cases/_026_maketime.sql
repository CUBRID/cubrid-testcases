--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select MAKETIME('2000-01-01',1,1);
--test
SELECT MAKETIME('2010-10-04 12:34:56',1,1);
--test
SELECT MAKETIME('2010-10-04 12:34:56.7890',1,null);
--test
SELECT MAKETIME('12:34:56',null,null);
--test
SELECT MAKETIME('2011-05-01 PAZAR',1,0);
--test
SELECT MAKETIME(null,1,null);
--test
SELECT MAKETIME(null,null,null);
--test
SELECT MAKETIME(13,34,4);
--test
SELECT MAKETIME('1','34','4');
--test
SELECT MAKETIME(24,0,0);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;