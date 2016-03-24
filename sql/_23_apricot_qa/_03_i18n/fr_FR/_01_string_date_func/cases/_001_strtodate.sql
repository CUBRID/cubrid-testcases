--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = fr_FR';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('dimanche 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('lundi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('mardi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('mercredi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('jeudi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('vendredi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('samedi 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('diMANche 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('LUndi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MardI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MeRcReDi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('jeUDI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('VENDreDI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('saMEDi 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('dimanché 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('janv. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('févr. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mars 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('avr. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mai 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juin 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juil. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('août 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sept. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('oct. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nov. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('déc. 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('jANv. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('fÉVr. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaRS 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('avR. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAi 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juIn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juIl. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AoÛt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Sept. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('oCt. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOV. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DéC. 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('dim. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('lun. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mar. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mer. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('jeu. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ven. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sam. 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('DIim. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('lUN. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('MaR. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mEr. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('jEU. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('VEn. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('SaM. 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('janvier 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('février 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mars 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('avril 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mai 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juin 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juillet 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('août 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('septembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('octobre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('novembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('décembre 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('JANVier 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('fÉVrier 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mARs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('avRIl 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaI 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuiN 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('juiLLEt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aoÛT 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sePtEMbRe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OctOBRe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOVEmbrE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DéCembrE 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('someMonth 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AnotherMonth 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Samemonth 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('octobre 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('octobre 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octobre 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octobre 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
