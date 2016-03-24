--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = fr_FR';
-- date
select 'to_date( , DAY )';
SELECT TO_DATE('2011-05-01 DIMANCHE', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-02 LUNDI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-03 MARDI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-04 MERCREDI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-05 JEUDI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-06 VENDREDI', 'yyyy-MM-DD DAY');
SELECT TO_DATE('2011-05-07 SAMEDI', 'yyyy-MM-DD DAY');

select 'to_date( ,  day )';
SELECT TO_DATE('2011-05-01 dimanche', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-02 lundi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-03 mardi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-04 mercredi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-05 jeudi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-06 vendredi', 'yyyy-MM-DD day');
SELECT TO_DATE('2011-05-07 samedi', 'yyyy-MM-DD day');

select 'to_date( , DY )';
SELECT TO_DATE('2011-05-01 DIM.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-02 LUN.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-03 MAR.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-04 MER.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-05 jeu.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-06 ven.', 'yyyy-MM-DD DY');
SELECT TO_DATE('2011-05-07 sam.', 'yyyy-MM-DD DY');

select 'to_date( ,  dy )';
SELECT TO_DATE('2011-05-01 dim.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-02 lun.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-03 mar.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-04 mer.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-05 jeu.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-06 ven.', 'yyyy-MM-DD dy');
SELECT TO_DATE('2011-05-07 sam.', 'yyyy-MM-DD dy');

-- month
select 'to_date( ,  MONTH)';
SELECT TO_DATE('2010-01 JANVIER', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 FÉVRIER', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MARS', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AVRIL', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JUIN', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 JUILLET', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 AOÛT', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 SEPTEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 OCTOBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 NOVEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATE('2010-01 DÉCEMBRE', 'yyyy-dd MONTH');

select 'to_date( ,  month)';
SELECT TO_DATE('2010-01 janvier', 'yyyy-dd month');
SELECT TO_DATE('2010-01 février', 'yyyy-dd month');
SELECT TO_DATE('2010-01 mars', 'yyyy-dd month');
SELECT TO_DATE('2010-01 avril', 'yyyy-dd month');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd month');
SELECT TO_DATE('2010-01 juin', 'yyyy-dd month');
SELECT TO_DATE('2010-01 juillet', 'yyyy-dd month');
SELECT TO_DATE('2010-01 août', 'yyyy-dd month');
SELECT TO_DATE('2010-01 septembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 octobre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 novembre', 'yyyy-dd month');
SELECT TO_DATE('2010-01 décembre', 'yyyy-dd month');


select 'to_date( ,  MON)';
SELECT TO_DATE('2010-01 JANV.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 FÉVR.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MARS', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AVR.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 MAI', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUIN', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 JUIL.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 AOÛT', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 SEPT.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 OCT.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 NOV.', 'yyyy-dd MON');
SELECT TO_DATE('2010-01 DÉC.', 'yyyy-dd MON');

select 'to_date( ,  mon)';
SELECT TO_DATE('2010-01 janv.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 févr.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mars', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 avr.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 juin', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 juil.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 août', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 sept.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 oct.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 nov.', 'yyyy-dd mon');
SELECT TO_DATE('2010-01 déc.', 'yyyy-dd mon');

select 'to_date( ,  Month)';
SELECT TO_DATE('2010-01 janvier', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 février', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 mars', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 avril', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 juin', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 juillet', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 août', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 septembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 octobre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 novembre', 'yyyy-dd Month');
SELECT TO_DATE('2010-01 décembre', 'yyyy-dd Month');

select 'to_date( ,  Mon)';
SELECT TO_DATE('2010-01 janv.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 févr.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 mars', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 avr.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 mai', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 juin', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 juil.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 août', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 sept.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 oct.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 nov.', 'yyyy-dd Mon');
SELECT TO_DATE('2010-01 déc.', 'yyyy-dd Mon');

-- text
SELECT TO_DATE('2010-01 teIt nov.', 'yyyy-dd "teit" Mon');

SELECT TO_DATE('2010-01 teIt nov.', 'yyyy-dd "teSt" Mon');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;


