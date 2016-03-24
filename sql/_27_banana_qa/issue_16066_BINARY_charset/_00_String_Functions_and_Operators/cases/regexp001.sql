--+ holdcas on;
set names utf8;


SELECT ('字符串1'  REGEXP '^字符');
SELECT ('字符'  REGEXP BINARY  '字符串1');
SELECT ('字符串1'  REGEXP '字符');

SELECT ( cast( _utf8'12345가나다라마가나다라마' as string charset euckr) REGEXP  cast( _utf8'가' as string charset euckr));
SELECT (cast( _utf8'12345가나다라마가나다라마' as string charset euckr) REGEXP BINARY cast( _utf8'가' as string charset euckr));


SELECT ('Öö_Şş_Üü2' COLLATE iso88591_bin REGEXP  'ö' COLLATE iso88591_bin  );
SELECT ('Öö_Şş_Üü2' COLLATE iso88591_bin REGEXP BINARY 'Ö' COLLATE iso88591_bin);


SELECT ( cast( _utf8'Öö_Şş_Üü2' as string charset iso88591)  REGEXP  cast( _utf8'Öö_Ş' as string charset iso88591));
SELECT (cast( _utf8'Öö_Şş_Üü2' as string charset iso88591)  REGEXP BINARY cast( _utf8'Öö_Ş' as string charset iso88591));

SELECT ( cast( _utf8'Öö_Şş_Üü2' as string charset iso88591)  REGEXP  cast( _utf8'Öö_Şş' as string charset iso88591));
SELECT (cast( _utf8'Öö_Şş_Üü2' as string charset iso88591)  REGEXP BINARY cast( _utf8'Öö_Şş' as string charset iso88591));



SELECT ('chr(0)'  REGEXP '^字符');


set names iso88591;
commit;
--+ holdcas off;
