-- day long form : Sunday - Saturday
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = ko_KR';
select 'Days long form';
SELECT STR_TO_DATE('일요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('월요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('화요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('수요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('목요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('금요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('토요일 2 2011','%W %u %Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('일요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('월요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('화요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('수요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('목요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('금요일 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('토요일 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('토요일_err 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('1월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12월 1, 2013','%b %d,%Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('1월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11월 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12월 1, 2013','%b %d,%Y') FROM db_root;

-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('일 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('월 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('화 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('수 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('목 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('금 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('토 2 2011','%a %u %Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('일 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('월 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('화 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('수 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('목 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('금 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('토 2 2011','%a %u %Y') FROM db_root;


-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('1월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12월 1, 2013','%M %d,%Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('1월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12월 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('13월 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('1월월 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('10월 1, 2013 10:11:12 오전','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('10월 1, 2013 10:11:12 오전','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10월 1, 2013 8:11:12 오전','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10월 1, 2013 8:11:12 오전','%M %d,%Y %r') FROM db_root;

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
