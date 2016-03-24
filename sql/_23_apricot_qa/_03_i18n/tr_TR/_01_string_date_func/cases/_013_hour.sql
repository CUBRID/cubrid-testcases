--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select HOUR('2010-10-04');
--test
SELECT HOUR('2010-10-04 12:34:56');
--test
SELECT HOUR('2010-10-04 12:34:56.7890');
--test
SELECT HOUR('13:34:56');
--test
SELECT HOUR('13:34:56.1234');
--test
SELECT HOUR('10:34:56 AM');
--test
SELECT HOUR('10:34:56 PM');
--test
SELECT HOUR('2011-05-01 PAZAR');
--test
SELECT HOUR('2011-05-01 PAZAR 10:11:12 PM');
--test
SELECT HOUR('2011-05-07 CUMARTESİ 10:11:12.678');
--test
SELECT HOUR('2011-05-02 pazartesi');
--test
SELECT HOUR('2011-05-03 SA');
--test
SELECT HOUR('2011-05-03 你好');
--test
SELECT HOUR('2011-05-04 ça');
--test
SELECT HOUR('2010-01 OCAK');
--test
SELECT HOUR('2010-01');
--test
SELECT HOUR('2010');
--test
SELECT HOUR('hello');

set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;