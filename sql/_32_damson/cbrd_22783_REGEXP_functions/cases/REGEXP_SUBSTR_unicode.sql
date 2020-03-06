--REGEXP_SUBSTR
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_SUBSTR('삼성로 86길, 강남구, 서울특별시', ',[^,]+,', 1, 1);
SELECT REGEXP_SUBSTR('삼성로 86길, 강남구, 서울특별시', '[[:alpha:]]+', 1, 3);
SELECT REGEXP_SUBSTR('11억 8112만 5400원', '\d+[[:alpha:]]', 3, 1);
SELECT REGEXP_SUBSTR(_euckr'가나다라' COLLATE euckr_bin, _utf8' [가-나]{4}' COLLATE utf8_ko_cs);
SELECT REGEXP_SUBSTR('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs);
