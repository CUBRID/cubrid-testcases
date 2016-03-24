--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = es_ES';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('domingo 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('lunes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('martes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('miércoles 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('jueves 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('viernes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('sábado 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('doMINgo 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('LUnes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('maRTES 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('miÉRColes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('JUevES 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ViERnes 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('sÁbAdO 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('miercoles 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('ene 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('feb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mar 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('abr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('may 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('jun 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('jul 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ago 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sep 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('oct 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nov 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('dic 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('ENE 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('fEb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('maR 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Abr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAy 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuN 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('jUL 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AGO 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sep 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ocT 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nOv 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DIc 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('dom 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('lun 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mar 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mié 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('jue 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('vie 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sáb 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('dom 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Lun 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mAR 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mIÉ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('JuE 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('VIe 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sÁB 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('enero 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('febrero 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('marzo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('abril 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mayo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('junio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('julio 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('agosto 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('septiembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('octubre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('noviembre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('diciembre 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('enERo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('fEBRERO 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MARzo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aBRIL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mAYo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuNIO 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('jULiO 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aGOSTo 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SeptiembrE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('octUBRE 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('NOvieMBRe 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DICIEMbre 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('DICIEMbree 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DICIEEMbre 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DICiiIEMbre 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('octubre 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('octubre 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octubre 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('octubre 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
