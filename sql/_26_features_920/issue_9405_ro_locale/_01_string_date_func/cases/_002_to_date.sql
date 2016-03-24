--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ro_RO';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 DUMINICĂ', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 LUNI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 MARȚI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 MIERCURI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 JOI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 VINERI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 SÂMBĂTĂ', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 duminică', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 luni', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 marți', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 miercuri', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 joi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 vineri', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 sâmbătă', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 DU', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 LU', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 MA', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 MI', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 JO', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 VI', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 SÂ', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 du', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 lu', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 ma', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 mi', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 jo', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 vi', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 sâ', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 IANUARIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 FEBRUARIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MARTIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 APRILIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 IUNIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 IULIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AUGUST', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 SEPTEMBRIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 OCTOMBRIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 NOIEMBRIE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 DECEMBRIE', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 ianuarie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 februarie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 martie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 aprilie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd month');
SELECT TO_DATE('2010-01 iunie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 iulie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 august', 'yyyy-dd month');
SELECT TO_DATE('2010-01 septembrie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 octombrie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 noiembrie', 'yyyy-dd month');
SELECT TO_DATE('2010-01 decembrie', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 IAN.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 FEB.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAR.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 APR.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 IUN.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 IUL.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AUG.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 SEPT.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 OCT.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 NOV.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 DEC.', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 ian.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 feb.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mar.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 apr.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 iun.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 iul.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 aug.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 sept.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 oct.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 nov.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 dec.', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 ianuarie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 februarie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 martie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 aprilie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 iunie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 iulie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 august', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 septembrie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 octombrie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 noiembrie', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 decembrie', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 ian.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 feb.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 mar.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 apr.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 iun.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 iul.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 aug.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 sept.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 oct.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 nov.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 dec.', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teȚt nov.', 'yyyy-dd "tețt" Mon');

SELECT TO_DATE('2010-01 teĂt nov.', 'yyyy-dd "teÂt" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


