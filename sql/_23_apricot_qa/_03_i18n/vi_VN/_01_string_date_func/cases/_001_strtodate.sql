-- day long form : Sunday - Saturday
--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = vi_VN';
select 'Days long form';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('Chủ nhật 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ hai 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ ba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ tư 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ năm 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ sáu 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ bảy 2 2011','%W %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('Chủ NHật 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ThỨ hai 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ThỨ Ba 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ThỨ TƯ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ NĂm 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ SÁu 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Thứ bẢY 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('Thu bay 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('thg 1 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 2 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 3 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 4 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 5 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 6 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 7 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 8 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 9 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 10 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 11 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thg 12 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('THG 1 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THG 2 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THG 3 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tHG 4 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tHG 5 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tHG 6 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THg 7 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THg 8 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THg 9 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ThG 10 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ThG 11 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ThG 12 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('CN 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 2 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 3 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 4 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 5 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 6 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 7 2 2011','%a %u %Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('CN 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 2 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('TH 3 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('th 4 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('th 5 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Th 6 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('tH 7 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('tháng một 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng hai 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng ba 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng tư 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng năm 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng sáu 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng bảy 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng tám 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng chín 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng mười 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng mười một 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng mười hai 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing
SELECT STR_TO_DATE('thÁNG MỘt 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THÁng hai 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THáNG BA 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháNG tƯ 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thÁNG nĂM 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THÁng sÁu 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THÁNg BẢy 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('THÁNG TáM 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ThÁnG ChÍn 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tháng mƯỜi 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tHÁNg MƯời một 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thÁNG MƯỜI hai 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('thang mƯỜi 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('tHÁNg MUời một 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('thÁNG MƯoI hai 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('tháng mười 1, 2013 10:11:12 SA','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('tháng mười 1, 2013 10:11:12 sA','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('tháng mười 1, 2013 8:11:12 Sa','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('tháng mười 1, 2013 8:11:12 sa','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
