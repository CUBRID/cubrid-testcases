--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = it_IT';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 DOMENICA', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 LUNEDÌ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 MARTEDÌ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 MERCOLEDÌ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 GIOVEDÌ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 VENERDÌ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 SABATO', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 domenica', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 lunedì', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 martedì', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 mercoledì', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 giovedì', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 venerdì', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 sabato', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 DOM', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 LUN', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 MAR', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 MER', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 gio', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 ven', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 sab', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 dom', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 lun', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 mar', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 mer', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 gio', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 ven', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 sab', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 GENNAIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 FEBBRAIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MARZO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 APRILE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MAGGIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 GIUGNO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 LUGLIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AGOSTO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 SETTEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 OTTOBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 NOVEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 DICEMBRE', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 gennaio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 febbraio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 marzo', 'yyyy-dd month');
SELECT TO_DATE('2010-01 aprile', 'yyyy-dd month');
SELECT TO_DATE('2010-01 maggio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 giugno', 'yyyy-dd month');
SELECT TO_DATE('2010-01 luglio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 agosto', 'yyyy-dd month');
SELECT TO_DATE('2010-01 settembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 ottobre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 novembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 dicembre', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 GEN', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 FEB', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 APR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAG', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 GIU', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 LUG', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AGO', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 SET', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 OTT', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 NOV', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 DIC', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 gen', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 feb', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mar', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 apr', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mag', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 giu', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 lug', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ago', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 set', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ott', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 nov', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 dic', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 Gennaio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Febbraio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Marzo', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Aprile', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Maggio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Giugno', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Luglio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Agosto', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Settembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Ottobre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Novembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 Dicembre', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 Gen', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Feb', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Mar', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Apr', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Mag', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Giu', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Lug', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Ago', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Set', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Ott', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Nov', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 Dic', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teÌt Nov', 'yyyy-dd "teìt" Mon');

SELECT TO_DATE('2010-01 teìt Nov', 'yyyy-dd "teÌt" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;

