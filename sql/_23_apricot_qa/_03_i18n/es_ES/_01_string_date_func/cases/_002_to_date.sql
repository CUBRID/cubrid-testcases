--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = es_ES';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 DOMINGO', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 LUNES', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 MARTES', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 MIÉRCOLES', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 JUEVES', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 VIERNES', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 SÁBADO', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 domingo', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 lunes', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 martes', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 miércoles', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 jueves', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 viernes', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 sábado', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 DOM', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 LUN', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 MAR', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 MIÉ', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 jue', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 vie', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 sáb', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 dom', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 lun', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 mar', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 mié', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 jue', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 vie', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 sáb', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 ENERO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 FEBRERO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MARZO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 ABRIL', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MAYO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JUNIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JULIO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AGOSTO', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 SEPTIEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 OCTUBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 NOVIEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 DICIEMBRE', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 enero', 'yyyy-dd month');
SELECT TO_DATE('2010-01 febrero', 'yyyy-dd month');
SELECT TO_DATE('2010-01 marzo', 'yyyy-dd month');
SELECT TO_DATE('2010-01 abril', 'yyyy-dd month');
SELECT TO_DATE('2010-01 mayo', 'yyyy-dd month');
SELECT TO_DATE('2010-01 junio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 julio', 'yyyy-dd month');
SELECT TO_DATE('2010-01 agosto', 'yyyy-dd month');
SELECT TO_DATE('2010-01 septiembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 octubre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 noviembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 diciembre', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 ENE', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 FEB', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 ABR', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAY', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUN', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUL', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AGO', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 SEP', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 OCT', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 NOV', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 DIC', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 ene', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 feb', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mar', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 abr', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 may', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 jun', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 jul', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 ago', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 sep', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 oct', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 nov', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 dic', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 enero', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 febrero', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 marzo', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 abril', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 mayo', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 junio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 julio', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 agosto', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 septiembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 octubre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 noviembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 diciembre', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 ene', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 feb', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 mar', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 abr', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 may', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 jun', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 jul', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 ago', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 sep', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 oct', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 nov', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 dic', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teÌt Nov', 'yyyy-dd "teìt" Mon');

SELECT TO_DATE('2010-01 teìt Nov', 'yyyy-dd "teÌt" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


