--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select from_days('2000-01-01');
--test
SELECT from_days('2010-10-04 12:34:56');
--test
SELECT from_days('2010-10-04 12:34:56.7890');
--test
SELECT from_days('12:34:56');
--test
SELECT from_days(82800);
--test
SELECT from_days(82800.3);
--test
SELECT from_days('3652424');
--test
SELECT from_days(3652425);
--test
SELECT from_days(365);
--test
SELECT from_days(-1);
--test
SELECT from_days(null);
--test
SELECT from_days('2011-05-01 PAZAR');
--test
SELECT from_days('2011-05-01 PAZAR 10:11:12 PM');
--test
SELECT from_days('2011-05-07 CUMARTESİ 10:11:12.678');
--test
SELECT from_days('2011-05-02 pazartesi');
--test
SELECT from_days('2011-05-03 SA');
--test
SELECT from_days('2011-05-04 ça');
--test
SELECT from_days('2011-05-03 你好');
--test
SELECT from_days('2010-01 OCAK');
--test
SELECT from_days('2010-01');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;