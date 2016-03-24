--+ holdcas on;
set names binary;
SELECT BIN(0);
SELECT BIN('你好啊');
SELECT BIN(cast( _utf8'문자열 2' as string charset euckr));

set names iso88591;
commit;
--+ holdcas off;