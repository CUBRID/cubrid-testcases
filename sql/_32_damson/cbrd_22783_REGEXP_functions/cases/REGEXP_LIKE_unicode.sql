-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

--REGEXP_LIKE
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT REGEXP_LIKE('가나다가나다가나다라', '(가나)다');
SELECT REGEXP_LIKE('가나 가나다라 마바사아 자차카타 파하', '[[:alpha:]]+');
SELECT REGEXP_LIKE('11억 1111', '[[:alpha:]]');
SELECT REGEXP_LIKE('Kłak Aleksander', '[[:alpha:]]');
SELECT REGEXP_LIKE(_euckr'가나다라' COLLATE euckr_bin, _utf8' [가-나]' COLLATE utf8_ko_cs);
SELECT REGEXP_LIKE('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs);

SET NAMES iso88591;
SELECT REGEXP_LIKE('Kłak Aleksander', '[[:alpha:]]');


set system parameters 'regexp_engine=default';

