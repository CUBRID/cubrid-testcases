--+ holdcas on;
set names utf8;

select translate('字符串1','字符','字');
select translate('字符串1','字符',null);
select translate('字符串1',null,'字');
select translate('字符串1','字符','');


-- there are different charset

select translate('字符串1', _utf8'字符',_utf8'字');
select translate( cast( _utf8'문자열 2' as string charset euckr), cast( _utf8'문자열' as string charset euckr),cast( _utf8'문자' as string charset euckr));
select translate(cast(_utf8'Öö_Şş_Üü2' as string charset iso88591), cast(_utf8'Öö_Şş' as string charset iso88591), cast(_utf8'Öö' as string charset iso88591));


select translate( _binary'문자열 2', cast( _utf8'문자' as string charset euckr),_utf8'字符串2');
select translate( _binary'Öö_Şş_Üü2', cast( _utf8'문자열 2' as string charset euckr),_utf8'字符串2');


select translate(cast( _utf8'문자열 2' as string charset euckr), cast( _utf8'문자' as string charset euckr),_utf8'字符串2');
select translate(cast( _utf8'문자열 2' as string charset euckr),  cast( _utf8'문자' as string charset euckr),cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));

select translate( cast(_utf8'Öö_Şş_Üü2' as string charset iso88591), cast( _utf8'문자열 2' as string charset euckr),_utf8'字符串2');
select translate( cast(_utf8'Öö_Şş_Üü2' as string charset iso88591), cast(_utf8'Öö_Şş_Üü2' as string charset iso88591),cast( _utf8'문자' as string charset euckr));



set names iso88591;
commit;
--+ holdcas off;
