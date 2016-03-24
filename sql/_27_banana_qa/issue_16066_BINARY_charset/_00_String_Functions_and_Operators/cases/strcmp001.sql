--+ holdcas on;
set names binary;

select strcmp('字符串1','字符串1');

-- there are different charset

select strcmp('字符串1', _utf8'字符串2');
select strcmp('字符串1', cast( _utf8'문자열 2' as string charset euckr));
select strcmp('字符串1', cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));

select strcmp(cast( _utf8'문자열 2' as string charset euckr), _utf8'字符串2');
select strcmp(cast( _utf8'문자열 2' as string charset euckr), cast( _utf8'문자열 2' as string charset euckr));
select strcmp(cast( _utf8'문자열 2' as string charset euckr), cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));

select strcmp( cast(_utf8'Öö_Şş_Üü2' as string charset iso88591), cast( _utf8'문자열 2' as string charset euckr));
select strcmp( cast(_utf8'Öö_Şş_Üü2' as string charset iso88591), cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));



select strcmp(cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));


select strcmp('chr(0)', _utf8'字符串2');

set names iso88591;
commit;
--+ holdcas off;
