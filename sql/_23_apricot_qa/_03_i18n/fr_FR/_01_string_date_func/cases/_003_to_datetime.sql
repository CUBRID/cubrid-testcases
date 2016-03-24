--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = fr_FR';
-- to_datetime
select 'TO_DATETIME( , DAY   )';
SELECT TO_DATETIME('2011-05-01 DIMANCHE 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-02 LUNDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-03 MARDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-04 MERCREDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-05 JEUDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-06 VENDREDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');
SELECT TO_DATETIME('2011-05-07 SAMEDI 10:11:12.678', 'yyyy-MM-DD DAY HH:MI:SS.FF');

select 'TO_DATETIME( ,  day )';
SELECT TO_DATETIME('2011-05-01 dimanche', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-02 lundi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-03 mardi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-04 mercredi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-05 jeudi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-06 vendredi', 'yyyy-MM-DD day');
SELECT TO_DATETIME('2011-05-07 samedi', 'yyyy-MM-DD day');

select 'TO_DATETIME( , DY )';
SELECT TO_DATETIME('2011-05-01 DIM.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-02 LUN.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-03 MAR.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-04 MER.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-05 jeu.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-06 ven.', 'yyyy-MM-DD DY');
SELECT TO_DATETIME('2011-05-07 sam.', 'yyyy-MM-DD DY');

select 'TO_DATETIME( ,  dy )';
SELECT TO_DATETIME('2011-05-01 dim.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-02 lun.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-03 mar.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-04 mer.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-05 jeu.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-06 ven.', 'yyyy-MM-DD dy');
SELECT TO_DATETIME('2011-05-07 sam.', 'yyyy-MM-DD dy');

-- month
select 'TO_DATETIME( ,  MONTH)';
SELECT TO_DATETIME('2010-01 JANVIER', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 FÉVRIER', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 MARS', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 AVRIL', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 MAI', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 JUIN', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 JUILLET', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 AOÛT', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 SEPTEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 OCTOBRE', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 NOVEMBRE', 'yyyy-dd MONTH');
SELECT TO_DATETIME('2010-01 DÉCEMBRE', 'yyyy-dd MONTH');

select 'TO_DATETIME( ,  month)';
SELECT TO_DATETIME('2010-01 janvier', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 février', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 mars', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 avril', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 mai', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 juin', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 juillet', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 août', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 septembre', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 octobre', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 novembre', 'yyyy-dd month');
SELECT TO_DATETIME('2010-01 décembre', 'yyyy-dd month');


select 'TO_DATETIME( ,  MON)';
SELECT TO_DATETIME('2010-01 JANV.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 FÉVR.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 MARS', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 AVR.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 MAI', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 JUIN', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 JUIL.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 AOÛT', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 SEPT.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 OCT.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 NOV.', 'yyyy-dd MON');
SELECT TO_DATETIME('2010-01 DÉC.', 'yyyy-dd MON');

select 'TO_DATETIME( ,  mon)';
SELECT TO_DATETIME('2010-01 janv.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 févr.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 mars', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 avr.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 mai', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 juin', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 juil.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 août', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 sept.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 oct.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 nov.', 'yyyy-dd mon');
SELECT TO_DATETIME('2010-01 déc.', 'yyyy-dd mon');

select 'TO_DATETIME( ,  Month)';
SELECT TO_DATETIME('2010-01 janvier', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 février', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 mars', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 avril', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 mai', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 juin', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 juillet', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 août', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 septembre', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 octobre', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 novembre', 'yyyy-dd Month');
SELECT TO_DATETIME('2010-01 décembre', 'yyyy-dd Month');

select 'TO_DATETIME( ,  Mon)';
SELECT TO_DATETIME('2010-01 janv.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 févr.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 mars', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 avr.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 mai', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 juin', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 juil.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 août', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 sept.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 oct.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 nov.', 'yyyy-dd Mon');
SELECT TO_DATETIME('2010-01 déc.', 'yyyy-dd Mon');

-- text
SELECT TO_DATETIME('2010-01 teIt nov.', 'yyyy-dd "teit" Mon');

SELECT TO_DATE('2010-01 teIt nov.', 'yyyy-dd "teSt" Mon');

select 'TO_DATETIME( ,  PM)';
SELECT TO_DATETIME('2011-05-01 DIMANCHE 10:11:12 PM', 'yyyy-MM-DD DAY HH:MI:SS PM');
SELECT TO_DATETIME('2011-05-01 DIMANCHE 10:11:12 AM', 'yyyy-MM-DD DAY HH:MI:SS AM');
SELECT TO_DATETIME('2011-05-01 DIMANCHE 10:11:12 P.M.', 'yyyy-MM-DD DAY HH:MI:SS P.M.');
SELECT TO_DATETIME('2011-05-01 DIMANCHE 10:11:12 A.M.', 'yyyy-MM-DD DAY HH:MI:SS A.M.');
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
