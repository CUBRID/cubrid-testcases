--+ holdcas on;
set names binary;
SELECT ASCII('문자열');
SELECT ASCII(cast( _utf8'문자열 2' as string charset euckr));
SELECT ASCII(cast( _utf8'abc' as string charset iso88591));
SELECT ASCII(chr(0));


set names iso88591;
commit;
--+ holdcas off;