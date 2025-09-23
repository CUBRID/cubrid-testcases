-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

--REGEXP
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT /*+ RECOMPILE */ '가나다라' REGEXP '가';
SELECT /*+ RECOMPILE */ '가나다라' REGEXP '마';
SELECT /*+ RECOMPILE */ '가나다' REGEXP '[[:alpha:]]';
SELECT /*+ RECOMPILE */ '123' REGEXP '[[:alpha:]]';

--re2 library unicode verification.
SELECT /*+ RECOMPILE */ '가나다' REGEXP '\p{Hangul}';
SELECT /*+ RECOMPILE */ '123' REGEXP '\p{Hangul}';


--REGEXP_REPLACE
SET NAMES utf8 COLLATE utf8_ko_cs;
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('가나다라', '[가-나]{4}', '한글');
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('가나다라', '[가-라]{4}', '한글');
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('가나다라', '[[:alpha:]]', '한글');
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('a1가b2나다라', '[가-다]', '#', 6);
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('a1가b2나다라', '[가-다]', '#', 1, 3);
SELECT /*+ RECOMPILE */ REGEXP_REPLACE(_euckr'가나다라', _utf8' [가-나]{4}', _utf8'다른 문자셋');
--According to CBRD-23641 do not include
--SELECT REGEXP_REPLACE(_euckr'가나다라' collate euckr_bin, _utf8' [가-나]{4}', _utf8'다른 문자셋');

--re2 library unicode verification.
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('가나다라', '\p{Hangul}', '한글');

SET NAMES utf8; 
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('Kłak Aleksander', '[[:alpha:]]+','#', 1, 1);
SELECT /*+ RECOMPILE */ REGEXP_REPLACE(_euckr'가나다라', _utf8' [가-나]{4}', _utf8'다른 문자셋');
SELECT /*+ RECOMPILE */ REGEXP_REPLACE('가나다라' COLLATE utf8_ko_cs,  _utf8' [த]' COLLATE utf8_tr_cs, 'INVALID');

--According to CBRD-23641 do not include
--SET NAMES iso88591;
--SELECT REGEXP_REPLACE('Kłak Aleksander', '[[:alpha:]]+','#', 1, 1);

set system parameters 'regexp_engine=default';

