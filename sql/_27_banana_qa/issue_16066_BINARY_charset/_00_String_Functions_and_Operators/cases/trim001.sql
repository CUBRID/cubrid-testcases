--+ holdcas on;
set names binary;

select trim('  字符串1   ');
select trim(cast(        _utf8'문자열 2'        as string charset euckr));
select trim(cast(       _utf8'Öö_Şş_Üü2'       as string charset iso88591));

-- there are different charset

SELECT TRIM ('i' FROM 'iiiiiOlympiciiiii');
select trim('棒'  from '棒棒棒棒字符串2棒棒棒棒');
select trim(cast( _utf8'문' as string charset euckr)  from cast( _utf8'문문문문자열 2문문문' as string charset euckr));
select trim(cast(_utf8'Öö' as string charset iso88591)  from  cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖöÖö' as string charset iso88591));

select trim('棒'  from  cast( _utf8'문문문문자열 2문문문' as string charset euckr));
select trim('棒'  from   cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖö' as string charset iso88591));


SELECT TRIM (LEADING 'i' FROM 'iiiiiOlympiciiiii');
select trim(LEADING '棒'  from '棒棒棒棒字符串2棒棒棒棒');
select trim(LEADING cast( _utf8'문' as string charset euckr)  from cast( _utf8'문문문자열 2문문문문' as string charset euckr));
select trim(LEADING cast(_utf8'Öö' as string charset iso88591)  from  cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖö' as string charset iso88591));

select trim(LEADING '棒'  from  cast( _utf8'문문문문자열 2문문문' as string charset euckr));
select trim( LEADING '棒'  from   cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖö' as string charset iso88591));


SELECT TRIM (TRAILING 'i' FROM 'iiiiiOlympiciiiii');
select trim(TRAILING '棒'  from '棒棒棒棒字符串2棒棒棒棒');
select trim(TRAILING cast( _utf8'문' as string charset euckr)  from cast( _utf8'문문문문자열 2문문문' as string charset euckr));
select trim(TRAILING cast(_utf8'Öö' as string charset iso88591)  from  cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖöÖö' as string charset iso88591));

select trim(TRAILING '棒'  from  cast( _utf8'문문문문자열 2문문문' as string charset euckr));
select trim(TRAILING '棒'  from   cast(_utf8'ÖöÖöÖöÖö_Şş_Üü2ÖöÖöÖö' as string charset iso88591));

SELECT TRIM (chr(0) FROM 'iiiiiOlympiciiiii');

set names iso88591;
commit;
--+ holdcas off;
