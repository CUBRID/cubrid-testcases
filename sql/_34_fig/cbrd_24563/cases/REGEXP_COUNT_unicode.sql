-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

--REGEXP_COUNT
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_COUNT('가나다가나다가나다라', '(가나)다', 1);
SELECT REGEXP_COUNT('가나 가나다라 마바사아 자차카타 파하', '[[:alpha:]]+', 1);
SELECT REGEXP_COUNT('11억 8112만 5400 won 더하기 420만 4432 won', '[[:alpha:]]', 8);
SELECT REGEXP_COUNT('Kłak Aleksander', '[[:alpha:]]+', 1);
SELECT REGEXP_COUNT(_euckr'가나다라' COLLATE euckr_bin, _utf8' [가-나]' COLLATE utf8_ko_cs);
SELECT REGEXP_COUNT('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs);

SET NAMES iso88591;
SELECT REGEXP_COUNT('Kłak Aleksander', '[[:alpha:]]+', 1);


set system parameters 'regexp_engine=default';

