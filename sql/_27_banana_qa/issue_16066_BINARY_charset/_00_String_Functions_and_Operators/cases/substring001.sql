--+ holdcas on;
set names binary;


SELECT SUBSTRING('字符串1'  from 3 for 1);
SELECT SUBSTRING('字符串1字符串1字符串1', 6, 4);
SELECT SUBSTRING('字符串1字符串1字符串1字符串1字符串1' from -6 for 4);
SELECT SUBSTRING('字符串1字符串1字符串1' from 6);
SELCET SUBSTRING('字符串1字符串1字符串1' from -6);


SELECT SUBSTRING (cast( _utf8'12345가나다라마가나다라마' as string charset euckr) from 6 for 4);
SELECT SUBSTRING (cast( _utf8'12345가나다라마가나다라마' as string charset euckr) from -6 for 4);
SELECT SUBSTRING(cast( _utf8'12345가나다라마가나다라마' as string charset euckr) from 6);
SELECT SUBSTRING(cast( _utf8'12345가나다라마가나다라마' as string charset euckr) from -6);


SELECT SUBSTRING (cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591) from 6 for 4);
SELECT SUBSTRING (cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591) from -6 for 4);
SELECT SUBSTRING(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591) from 6);
SELECT SUBSTRING(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591) from -6);

SELECT SUBSTRING(chr(0) from 2 for 1);


set names iso88591;
commit;
--+ holdcas off;
