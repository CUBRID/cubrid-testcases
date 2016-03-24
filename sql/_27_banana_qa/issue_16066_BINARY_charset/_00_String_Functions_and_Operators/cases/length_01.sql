--+ holdcas on;
set names binary;

SELECT length('字符串1');
SELECT CHAR_LENGTH('字符串1');
SELECT CHARACTER_LENGTH('字符串1');
SELECT LENGTHB('字符串1');

SELECT  length(cast(cast( _utf8'문자열' as string charset euckr) as string charset binary));
SELECT   CHAR_LENGTH(cast( _utf8'문자열' as string charset euckr));
SELECT  CHARACTER_LENGTH(cast( _utf8'문자열' as string charset euckr));
select LENGTHB(cast( _utf8'문자열' as string charset euckr));

set names iso88591;
commit;
--+ holdcas off;
