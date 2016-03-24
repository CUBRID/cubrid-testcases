--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = tr_TR';
set system parameters 'intl_date_lang = tr_TR';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('Pazar 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pazartesi 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Salı 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Çarşamba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Perşembe 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cuma 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cumartesi 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('paZar 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('pazArtesİ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('salI 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('çarŞamba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('peRŞEmbe 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('CUMa 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('CumaRTesİ 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('CumaRTesI 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('Ock 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Şbt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mrt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nsn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mys 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Hzr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Tmz 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ağs 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Eyl 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ekm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ksm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Arl 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('oCk 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('şbt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mRt 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('nsn 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('mYs 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('hZr 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('TMz 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AĞs 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EyL 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('eKm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('kSm 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('aRl 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('Pz 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pt 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Sa 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Ça 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Pe 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Cu 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Ct 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('pZ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('PT 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('sA 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ça 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('PE 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('CU 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('cT 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('Ocak 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Şubat 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mart 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nisan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Mayıs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Haziran 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Temmuz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ağustos 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Eylül 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ekim 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Kasım 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Aralık 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('OCAk 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('şuBAt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MaRt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Nİsan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAyIs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Hazİran 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('TemMuz 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AĞustOs 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EylÜL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('Ekİm 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('KasIm 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('AralIk 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('NIsan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('EylUL 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('MAyİs 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('Ekim 1, 2013 10:11:12 am','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('Ekim 1, 2013 10:11:12 aM','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ekim 1, 2013 8:11:12 Am','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('Ekim 1, 2013 8:11:12 Am','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set system parameters 'intl_number_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
