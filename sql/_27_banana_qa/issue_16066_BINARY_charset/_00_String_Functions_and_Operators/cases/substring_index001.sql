--+ holdcas on;
set names binary;

SELECT SUBSTRING_INDEX('www.cubrid.org','.','2');

SELECT SUBSTRING_INDEX('字符.串1','.','1');
SELECT SUBSTRING_INDEX('字符.串1字符.串1字符.串1', '.','1');
SELECT SUBSTRING_INDEX('字符.串1字符.串1字符.串1字符.串1字符.串1', '串1字符','2.1');


SELECT SUBSTRING_INDEX (cast( _utf8'12345가.나다라마.가나다라마' as string charset euckr), '.' , '2');
SELECT SUBSTRING_INDEX (cast( _utf8'12345가.나다라마.가나다라마' as string charset euckr), cast( _utf8'나다라마' as string charset euckr) , '1');


SELECT SUBSTRING_INDEX (cast( _utf8'Öö_Şş.Üü2Öö_Şş.Üü2Öö_Şş_Üü2' as string charset iso88591), '.' , '2');
SELECT SUBSTRING_INDEX (cast( _utf8'Öö_Şş.Üü2Öö_Şş.Üü2Öö_Şş_Üü2' as string charset iso88591), cast( _utf8'Üü2Öö_Şş' as string charset iso88591) , '1');


SELECT SUBSTRING_INDEX(chr(0),'.','2');


set names iso88591;
commit;
--+ holdcas off;
