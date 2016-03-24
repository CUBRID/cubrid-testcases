-- day long form : Sunday - Saturday
--+ holdcas on;
set names iso88591;
set system parameters 'intl_date_lang = ko_KR';
select 'Days long form';
SELECT STR_TO_DATE('Iryoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Woryoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Hwayoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Suyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mogyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Geumyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Toyoil 2 2011','%W %u %Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('Iryoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Woryoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Hwayoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Suyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mogyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Geumyoil 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('Toyoil 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('Toyoil_err 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('1wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12wol 1, 2013','%b %d,%Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('1wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11wol 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12wol 1, 2013','%b %d,%Y') FROM db_root;

-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('Il 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Wol 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Hwa 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Su 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mok 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Geum 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('To 2 2011','%a %u %Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('Il 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Wol 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Hwa 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Su 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Mok 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('Geum 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('To 2 2011','%a %u %Y') FROM db_root;


-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('1wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12wol 1, 2013','%M %d,%Y') FROM db_root;
-- variations : no casing in Korean, cloned tests above, for compatibility with other lang
SELECT STR_TO_DATE('1wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('2wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('3wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('4wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('5wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('6wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('7wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('8wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('9wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('10wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('11wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('12wol 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('Wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('13wol 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('1wolWol 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('10wol 1, 2013 10:11:12 ojeon','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('10wol 1, 2013 10:11:12 ojeon','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10wol 1, 2013 8:11:12 ojeon','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('10wol 1, 2013 8:11:12 ojeon','%M %d,%Y %r') FROM db_root;

set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
