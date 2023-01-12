-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

--REGEXP_INSTR
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_INSTR('삼성로 86길, 강남구, 서울특별시', ',[^,]+,', 1, 1);
SELECT REGEXP_INSTR('삼성로 86길, 강남구, 서울특별시', '[[:alpha:]]+', 1, 3);
SELECT REGEXP_INSTR('11억 8112만 5400원', '\d+[[:alpha:]]', 3, 1);
SELECT REGEXP_INSTR('Kłak Aleksander', '[[:alpha:]]+', 1, 1);
SELECT REGEXP_INSTR (_euckr'가나다라' COLLATE euckr_bin, _utf8' [가-나]{4}' COLLATE utf8_ko_cs);
SELECT REGEXP_INSTR ('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs);

SET NAMES iso88591;
SELECT REGEXP_INSTR('Kłak Aleksander', '[[:alpha:]]+', 1, 1);


set system parameters 'regexp_engine=default';

