--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
--test
select SECOND('2010-10-04');
--test
SELECT SECOND('2010-10-04 12:34:56');
--test
SELECT SECOND('2010-10-04 12:34:56.7890');
--test
SELECT SECOND('13:34:56');
--test
SELECT SECOND('13:34:56.1234');
--test
SELECT SECOND('10:34:56 AM');
--test
SELECT SECOND('10:34:56 PM');
--test
SELECT SECOND('2011-05-01 PAZAR');
--test
SELECT SECOND('2011-05-01 PAZAR 10:11:12 PM');
--test
SELECT SECOND('2011-05-07 CUMARTESİ 10:11:12.678');
--test
SELECT SECOND('2011-05-02 pazartesi');
--test
SELECT SECOND('2011-05-03 SA');
--test
SELECT SECOND('2011-05-03 你好');
--test
SELECT SECOND('2011-05-04 ça');
--test
SELECT SECOND('2010-01 OCAK');
--test
SELECT SECOND('2010-01');
--test
SELECT SECOND('2010');
--test
SELECT SECOND('hello');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;