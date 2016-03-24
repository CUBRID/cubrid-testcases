--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = it_IT';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('domenica 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('lunedì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('martedì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('mercoledì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('giovedì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('venerdì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('sabato 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('doMENIca 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('lunEDÌ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('maRTEDì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MERCOLedì 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('GIOveDÌ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('veneRDÌ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('saBAto 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('giovedi 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('Gen 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Feb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mar 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Apr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mag 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Giu 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Lug 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ago 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Set 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ott 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nov 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Dic 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('GEn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('FEb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mAR 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ApR 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaG 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('GIu 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('LuG 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AgO 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SEt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OtT 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOv 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('dic 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('dom 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('lun 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mar 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mer 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('gio 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ven 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sab 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('dom 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('LUN 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mAR 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mer 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('gIO 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('VeN 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sAB 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('Gennaio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Febbraio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Marzo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Aprile 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Maggio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Giugno 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Luglio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Agosto 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Settembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ottobre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Novembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Dicembre 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('GENNaio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('FebBRAio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MarZO 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ApRILe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MagGIO 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('giUGno 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('LuGLio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AgOsTo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SetTEMbRE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OttoBRE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('NOVembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DicEMBRE 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('MagGIOoo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SeTTtTEMbRE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DicEMBREEE 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('Ottobre 1, 2013 10:11:12 m','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('Ottobre 1, 2013 10:11:12 M','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ottobre 1, 2013 8:11:12 m','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ottobre 1, 2013 8:11:12 M','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
