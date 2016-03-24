--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT STR_TO_DATE('Monday 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期一 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('Jan 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE(' ','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE(null,'%b %d,%Y') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;