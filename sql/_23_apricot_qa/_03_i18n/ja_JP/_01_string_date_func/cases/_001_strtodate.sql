-- day long form : Sunday - Saturday
--+ holdcas on;
set names utf8;
set system parameters 'intl_number_lang = ja_JP';
set system parameters 'intl_date_lang = ja_JP';
select 'Days long form';
SELECT STR_TO_DATE('日曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('月曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('火曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('水曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('木曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('金曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('土曜日 2 2011','%W %u %Y') FROM db_root;
-- variations : no casing in Japanese, duplicating tests above for compatibility
SELECT STR_TO_DATE('日曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('月曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('火曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('水曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('木曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('金曜日 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('土曜日 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('bogus_val 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('1月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12月 1, 2013','%b %d,%Y') FROM db_root;
-- variations : no casing in Japanese, duplicating tests above for compatibility
SELECT STR_TO_DATE('1月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11月 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12月 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('日 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('月 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('火 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('水 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('木 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('金 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('土 2 2011','%a %u %Y') FROM db_root;
-- variations : no casing in Japanese, duplicating tests above for compatibility
SELECT STR_TO_DATE('日 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('月 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('火 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('水 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('木 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('金 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('土 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('1月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12月 1, 2013','%M %d,%Y') FROM db_root;
-- variations : no casing in Japanese, duplicating tests above for compatibility
SELECT STR_TO_DATE('1月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12月 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('13月 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('1月月 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('10月 1, 2013 10:11:12 午前','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('10月 1, 2013 10:11:12 午前','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10月 1, 2013 8:11:12 午前','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10月 1, 2013 8:11:12 午前','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = ja_JP';
set system parameters 'intl_number_lang = ja_JP';
set names iso88591;
commit;
--+ holdcas off;
