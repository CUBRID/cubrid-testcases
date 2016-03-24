--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = de_DE';
set system parameters 'intl_date_lang = de_DE';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 SONNTAG', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 MONTAG', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 DIENSTAG', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 MITTWOCH', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 DONNERSTAG', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 FREITAG', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 SAMSTAG', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 sonntag', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 montag', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 Dienstag', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 mittwoch', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 donnerstag', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 freitag', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 samstag', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 SO.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 MO.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 DI.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 MI.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 Do.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 Fr.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 Sa.', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 so.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 mo.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 di.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 mi.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 do.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 fr.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 sa.', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 JANUAR', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 FEBRUAR', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MÄRZ', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 APRIL', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JUNI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JULI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AUGUST', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 SEPTEMBER', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 OKTOBER', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 NOVEMBER', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 DEZEMBER', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 januar', 'yyyy-dd month');
SELECT TO_DATE('2010-01 februar', 'yyyy-dd month');
SELECT TO_DATE('2010-01 märz', 'yyyy-dd month');
SELECT TO_DATE('2010-01 april', 'yyyy-dd month');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd month');
SELECT TO_DATE('2010-01 juni', 'yyyy-dd month');
SELECT TO_DATE('2010-01 juli', 'yyyy-dd month');
SELECT TO_DATE('2010-01 august', 'yyyy-dd month');
SELECT TO_DATE('2010-01 september', 'yyyy-dd month');
SELECT TO_DATE('2010-01 oktober', 'yyyy-dd month');
SELECT TO_DATE('2010-01 november', 'yyyy-dd month');
SELECT TO_DATE('2010-01 dezember', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 JAN', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 FEB', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MÄR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 APR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUN', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUL', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AUG', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 SEP', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 OKT', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 NOV', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 DEZ', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 jan', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 feb', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mär', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 apr', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 jun', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 jul', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 aug', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 sep', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 okt', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 nov', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 dez', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 Januar', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Februar', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 März', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 April', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Mai', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Juni', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Juli', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 August', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 September', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Oktober', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 November', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Dezember', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 Jan', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Feb', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Mär', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Apr', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Mai', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Jun', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Jul', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Aug', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Sep', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Okt', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Nov', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Dez', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teÄt Nov', 'yyyy-dd "teät" Mon');

SELECT TO_DATE('2010-01 teät Nov', 'yyyy-dd "teÄt" Mon');
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

