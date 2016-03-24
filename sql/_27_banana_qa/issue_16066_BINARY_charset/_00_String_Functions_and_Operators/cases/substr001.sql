--+ holdcas on;
set names binary;


SELECT SUBSTR('字符串1',3,1);
SELECT SUBSTR('字符串1字符串1字符串1', 6, 4);

SELECT SUBSTR(_utf8'字符串1字符串1字符串1', 6, 4);
SELECT SUBSTR('字符串1字符串1字符串1字符串1字符串1', -6, 4);
SELECT SUBSTR('字符串1字符串1字符串1', 6);
SELECT SUBSTR('字符串1字符串1字符串1', -6);


SELECT SUBSTR (cast( _utf8'12345가나다라마가나다라마' as string charset euckr), 6 , 4);
SELECT SUBSTR (cast( _utf8'12345가나다라마가나다라마' as string charset euckr), -6 , 4);
SELECT SUBSTR(cast( _utf8'12345가나다라마가나다라마' as string charset euckr), 6);
SELECT SUBSTR(cast( _utf8'12345가나다라마가나다라마' as string charset euckr), -6);


SELECT SUBSTR (cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591), 6 , 4);
SELECT SUBSTR (cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591), -6 , 4);
SELECT SUBSTR(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591), 6);
SELECT SUBSTR(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591), -6);

SELECT SUBSTR(chr(0),3,1);


set names iso88591;
commit;
--+ holdcas off;
