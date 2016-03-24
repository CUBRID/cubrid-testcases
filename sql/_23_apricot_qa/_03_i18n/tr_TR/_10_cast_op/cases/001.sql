--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select cast('2011-05-01 PAZAR 10:11:12.678' as DATETIME);
--test
select cast('2011-05-01 PAZAR 10:11:12' as TIMESTAMP);
--test
select cast('2011-05-01 PAZAR' as DATE);
set system parameters 'use_locale_date_format = no';
--test
select cast('2011-05-01 PAZAR 10:11:12.678' as DATETIME);
--test
select cast('2011-05-01 PAZAR 10:11:12' as TIMESTAMP);
--test
select cast('2011-05-01 PAZAR' as DATE);
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
