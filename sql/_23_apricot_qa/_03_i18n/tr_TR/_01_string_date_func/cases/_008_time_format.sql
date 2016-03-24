--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT TIME_FORMAT('22:23:24', '%H %h %i %s %f');
--test
SELECT TIME_FORMAT('10:23:24', '%H %i %s');
--test
SELECT TIME_FORMAT('10:23:24 PM', '%T');
--test
SELECT TIME_FORMAT('10:23:24 PM', null);
--test
SELECT TIME_FORMAT(null, '%T');
--test
SELECT TIME_FORMAT(null, null);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;