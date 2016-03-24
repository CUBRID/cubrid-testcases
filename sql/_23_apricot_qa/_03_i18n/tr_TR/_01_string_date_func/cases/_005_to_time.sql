--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT TO_TIME('10:11:12 PM');
--test
SELECT TO_TIME('10:11:12 AM');
--test
SELECT TO_TIME('10:11:12 P.M.');
--test
SELECT TO_TIME('10:11:12 A.M.');
--test
SELECT TO_TIME(null);
--test
SELECT TO_TIME('10:11:12 A.M.',null);
--test
SELECT TO_TIME(null,'HH:MI:SS A.M.');
--test
SELECT TO_TIME(null,null);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;