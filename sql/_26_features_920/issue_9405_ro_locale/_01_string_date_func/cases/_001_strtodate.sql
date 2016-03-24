--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ro_RO';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('duminică 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('luni 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('marți 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('miercuri 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('joi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('vineri 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('sâmbătă 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('dUMiniCĂ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('LUnI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MarȚI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MieRcuRi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('JoI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ViNeRI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('sÂmBătĂ 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('duminică 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('ian. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('feb. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mar. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('apr. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mai 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iun. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iul. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aug. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sept. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('oct. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nov. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('dec. 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('IaN. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('fEb. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mAR. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('APr. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAi 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iUN. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('IUl. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AuG. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Sept. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('oCt. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOV. 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DeC. 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('Du 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Lu 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Ma 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mi 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Jo 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Vi 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Sâ 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('du 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('LU 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('MA 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mi 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Jo 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Vi 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sÂ 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('ianuarie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('februarie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('martie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aprilie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mai 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iunie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iulie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('august 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('septembrie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('octombrie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('noiembrie 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('decembrie 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('iaNuArIe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('FEbruaRIE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mArTiE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aPrIlIe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaI 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('iUNIe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('IuliE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('auGUst 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sEptEMbriE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OcToMbRiE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOiEmBrIe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DEceMBriE 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('someMonth 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AnotherMonth 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Samemonth 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('octombrie 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('octombrie 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octombrie 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octombrie 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
