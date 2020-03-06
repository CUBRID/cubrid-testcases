--REGEXP
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT '가나다라' REGEXP '가';
SELECT '가나다라' REGEXP '마';
SELECT '가나다' REGEXP '[[:alpha:]]';
SELECT '123' REGEXP '[[:alpha:]]';

--REGEXP_REPLACE
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_REPLACE('가나다라', '[가-나]{4}', '한글');
SELECT REGEXP_REPLACE('가나다라', '[가-라]{4}', '한글');
SELECT REGEXP_REPLACE('가나다라', '[[:alpha:]]', '한글')
SELECT REGEXP_REPLACE('a1가b2나다라', '[가-다]', '#', 6);
SELECT REGEXP_REPLACE('a1가b2나다라', '[가-다]', '#', 1, 3);
SELECT REGEXP_REPLACE(_euckr'가나다라' collate euckr_bin, _utf8' [가-나]{4}', _utf8'다른 문자셋');
SELECT REGEXP_REPLACE(_euckr'가나다라', _utf8' [가-나]{4}', _utf8'다른 문자셋');

SET NAMES utf8; 
SELECT REGEXP_REPLACE(_euckr'가나다라', _utf8' [가-나]{4}', _utf8'다른 문자셋');
SELECT REGEXP_REPLACE('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs, 'INVALID');

--REGEXP_SUBSTR
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_SUBSTR('삼성로 86길, 강남구, 서울특별시', ',[^,]+,', 1, 1);
SELECT REGEXP_SUBSTR('삼성로 86길, 강남구, 서울특별시', '[[:alpha:]]+', 1, 3);
SELECT REGEXP_SUBSTR('11억 8112만 5400원', '\d+[[:alpha:]]', 3, 1);
SELECT REGEXP_SUBSTR(_euckr'가나다라' COLLATE euckr_bin, _utf8' [가-나]{4}' COLLATE utf8_ko_cs);
SELECT REGEXP_SUBSTR('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs);
