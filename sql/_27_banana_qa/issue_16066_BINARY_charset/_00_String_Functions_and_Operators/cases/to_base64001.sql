--+ holdcas on;
set names binary;

SELECT TO_BASE64('字符串1'), FROM_BASE64(TO_BASE64('字符串1'));


SELECT TO_BASE64(cast( _utf8'12345가나다라마가나다라마' as string charset euckr)),  FROM_BASE64(TO_BASE64(cast( _utf8'12345가나다라마가나다라마' as string charset euckr)));
SELECT TO_BASE64(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)), FROM_BASE64(TO_BASE64(cast( _utf8'Öö_Şş_Üü2Öö_Şş_Üü2Öö_Şş_Üü2' as string charset iso88591)));


set names iso88591;
commit;
--+ holdcas off;
