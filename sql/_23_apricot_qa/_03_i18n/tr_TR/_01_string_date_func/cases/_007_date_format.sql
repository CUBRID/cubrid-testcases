--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
SELECT DATE_FORMAT('2011-12-1 22:23:24', '%H:%i:%s');
--test
SELECT DATE_FORMAT('2011-1-1 22:23:24', '%X %V');
--test
SELECT DATE_FORMAT('2011-1-1 22:23:24', null);
--test
SELECT DATE_FORMAT(null, '%X %V');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;