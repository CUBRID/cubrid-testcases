--+ holdcas on;
set names binary;

SELECT ELT(1, '문자열'||chr(0)||'열','문자열','문자열','문자열');

SELECT ELT(2, '문자열', chr(0),'문자열','문자열','문자열');

SELECT ELT(2, '문자열', cast(_utf8'문자열' as string charset euckr),'문자열','문자열');

SELECT ELT(0, '문자열',cast(_utf8'문자' as string charset euckr),'자열','문자');
SELECT ELT(-1, '문자'||chr(0)||'열',cast(_utf8'문자' as string charset euckr),'문자열','문자');

set names iso88591;
commit;
--+ holdcas off;
