-- day long form : Sunday - Saturday
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = zh_CN';
select 'Days long form';
--test
SELECT STR_TO_DATE('星期日 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期一 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期二 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期三 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期四 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期五 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期六 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期七 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('礼拜一 2 2011','%W %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('星期2 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
--test
SELECT STR_TO_DATE('1月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('2月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('3月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('4月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('5月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('6月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('7月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('8月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('9月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('10月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('11月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('12月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('2月 1, 2013','%b %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('12月 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
--test
SELECT STR_TO_DATE('周日 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周一 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周二 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周三 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周四 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周五 2 2011','%a %u %Y') FROM db_root;
--test
SELECT STR_TO_DATE('周六 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
--test
SELECT STR_TO_DATE('一月, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('二月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('三月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('四月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('五月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('六月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('七月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('八月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('九月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('十月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('十一月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('十二月 1, 2013','%M %d,%Y') FROM db_root;


--test
SELECT STR_TO_DATE('7月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('十三月 1, 2013','%M %d,%Y') FROM db_root;
--test
SELECT STR_TO_DATE('合些月 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
--test
SELECT STR_TO_DATE('一月 1, 2013 10:11:12 上午','%M %d,%Y %h:%i:%s %p') FROM db_root;
--test
SELECT STR_TO_DATE('一月 1, 2013 13:11:12 下午','%M %d,%Y %h:%i:%s %p') FROM db_root;
--test
SELECT STR_TO_DATE('一月 1, 2013 8:11:12 上午','%M %d,%Y %h:%i:%s %p') FROM db_root;
--test
SELECT STR_TO_DATE('一月 1, 2013 8:11:12 上午','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;