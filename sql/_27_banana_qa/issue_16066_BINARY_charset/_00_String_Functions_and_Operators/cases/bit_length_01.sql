--+ holdcas on;
set names binary;
SELECT BIT_LENGTH('字符串1');
SELECT BIT_LENGTH(cast( _utf8'문자열' as string charset euckr));
SELECT BIT_LENGTH(_utf8'字符串1');
SELECT BIT_LENGTH(cast(_utf8'À' as string charset iso88591));
SELECT BIT_LENGTH(chr(0));
set names iso88591;
commit;
--+ holdcas off;