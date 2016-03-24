--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = de_DE';
set system parameters 'intl_date_lang = de_DE';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('Sonntag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Montag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Dienstag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mittwoch 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Donnerstag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Freitag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Samstag 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('SoNNtag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MoNTAG 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('DienSTAG 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('MITTWoch 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('DonneRSTag 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('FREitAG 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('SaMStAg 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('Mittwoc 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('Jan 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Feb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mär 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Apr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mai 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Jun 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Jul 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Aug 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Sep 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Okt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nov 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Dez 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('JaN 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('FEb 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MÄr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ApR 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAI 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('jUN 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuL 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AUg 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SeP 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OkT 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('NOv 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('dEz 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('So. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mo. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Di. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mi. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Do. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Fr. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Sa. 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('SO. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('mo. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('dI. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('MI. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('do. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Fr. 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('SA. 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('Januar 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Februar 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('März 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('April 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mai 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Juni 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Juli 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('August 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('September 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Oktober 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('November 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Dezember 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('JanUAR 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('FebrUAr 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MÄrz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ApRIL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAi 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuNi 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('JuLI 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AuGuSt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('SepTEMBER 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('OktobeR 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('NovEMber 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('DeZEMBer 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('Marz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MärzMärz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Märs 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('Oktober 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('Oktober 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Oktober 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Oktober 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
