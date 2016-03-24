--+ holdcas on;
set names utf8;
set system parameters 'intl_date_lang = km_KH';
-- day long form : Sunday - Saturday
select 'Days long form';
SELECT STR_TO_DATE('ថ្ងៃអាទិត្យ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('​ថ្ងៃច័ន្ទ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃអង្គារ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃពុធ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃព្រហស្បតិ៍ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃសុក្រ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃសៅរ៍ 2 2011','%W %u %Y') FROM db_root;
-- variations : casing - in Cambodian, there is no casing,
-- these tests are here only for matching with cases on other languages
SELECT STR_TO_DATE('ថ្ងៃអាទិត្យ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('​ថ្ងៃច័ន្ទ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃអង្គារ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃពុធ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃព្រហស្បតិ៍ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃសុក្រ 2 2011','%W %u %Y') FROM db_root;
SELECT STR_TO_DATE('ថ្ងៃសៅរ៍ 2 2011','%W %u %Y') FROM db_root;
-- err
SELECT STR_TO_DATE('bogus_weekday 2 2011','%W %u %Y') FROM db_root;


-- month short form : Jan - Dec
select 'Months short form';
SELECT STR_TO_DATE('១ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('២ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៣ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៤ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៥ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៦ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៧ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៨ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៩ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១០ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១១ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១២ 1, 2013','%b %d,%Y') FROM db_root;
-- variations : casing - in Cambodian, there is no casing,
-- these tests are here only for matching with cases on other languages
SELECT STR_TO_DATE('១ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('២ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៣ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៤ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៥ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៦ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៧ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៨ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('៩ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១០ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១១ 1, 2013','%b %d,%Y') FROM db_root;
SELECT STR_TO_DATE('១២ 1, 2013','%b %d,%Y') FROM db_root;


-- day short form : Sun - Sat
select 'Days short form';
SELECT STR_TO_DATE('អា 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ច 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('អ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ពុ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ព្រ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('សុ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ស 2 2011','%a %u %Y') FROM db_root;
-- variations : casing - in Cambodian, there is no casing,
-- these tests are here only for matching with cases on other languages
SELECT STR_TO_DATE('អា 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ច 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('អ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ពុ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ព្រ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('សុ 2 2011','%a %u %Y') FROM db_root;
SELECT STR_TO_DATE('ស 2 2011','%a %u %Y') FROM db_root;



-- moth long form : January - December
select 'Months Long form';
SELECT STR_TO_DATE('មករា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កុម្ភៈ 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មិនា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មេសា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ឧសភា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មិថុនា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កក្កដា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('សីហា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កញ្ញា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('តុលា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('វិច្ឆិកា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ធ្នូ 1, 2013','%M %d,%Y') FROM db_root;
-- variations : casing - in Cambodian, there is no casing,
-- these tests are here only for matching with cases on other languages
SELECT STR_TO_DATE('មករា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កុម្ភៈ 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មិនា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មេសា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ឧសភា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('មិថុនា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កក្កដា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('សីហា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កញ្ញា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('តុលា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('វិច្ឆិកា 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ធ្នូ 1, 2013','%M %d,%Y') FROM db_root;

--err
SELECT STR_TO_DATE('NIsan 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('កញ្ញា_err 1, 2013','%M %d,%Y') FROM db_root;
SELECT STR_TO_DATE('ឧសភា_err 1, 2013','%M %d,%Y') FROM db_root;

-- AM/PM
select 'PM/AM';
SELECT STR_TO_DATE('តុលា 1, 2013 10:11:12 ព្រឹក','%M %d,%Y %h:%i:%s %p') FROM db_root;
SELECT STR_TO_DATE('តុលា 1, 2013 10:11:12 ព្រឹក','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('តុលា 1, 2013 8:11:12 ព្រឹក','%M %d,%Y %h:%i:%s %p') FROM db_root;

SELECT STR_TO_DATE('តុលា 1, 2013 8:11:12 ព្រឹក','%M %d,%Y %r') FROM db_root;
set system parameters 'intl_date_lang = en_US';
set names iso88591;
commit;
--+ holdcas off;
