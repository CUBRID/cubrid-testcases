-- day long form : Sunday - Saturday
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = tr_TR';

select 'Days long form';
SELECT STR_TO_DATE('Pazar 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pazartesi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Sali 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Carsamba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Persembe 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cuma 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cumartesi 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('paZar 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('pazArtesI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('salI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('CarSamba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('peRSEmbe 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('CUMa 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('CumaRTesI 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('CumaRTesI 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('Ock 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Sbt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mrt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nsn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mys 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Hzr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Tmz 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ags 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Eyl 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ekm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ksm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Arl 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('oCk 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('sbt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mRt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nsn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mYs 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('hZr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('TMz 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AGs 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EyL 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('eKm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('kSm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aRl 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('Pz 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pt 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Sa 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Ca 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pe 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cu 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Ct 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('pZ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('PT 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sA 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ca 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('PE 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('CU 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('cT 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('Ocak 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Subat 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mart 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nisan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mayis 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Haziran 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Temmuz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Agustos 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Eylul 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ekim 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Kasim 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Aralik 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('OCAk 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('suBAt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaRt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('NIsan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAyIs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('HazIran 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('TemMuz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AgustOs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EylUL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EkIm 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('KasIm 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AralIk 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('NIsan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EylUL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAyIs 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('Ekim 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('Ekim 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ekim 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ekim 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
