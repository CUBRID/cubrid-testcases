--+ holdcas on;
set names binary;
SELECT SPACE(8);

select space('字符串1');

select length(space('字符串1'));

select space(_utf8'字符串2');
select length(space(_utf8'字符串2'));

select space(cast( _utf8'문자열 2' as string charset euckr));
select length(space(cast( _utf8'문자열 2' as string charset euckr)));


select space(cast( _utf8'문자열 2' as string charset euckr));
select length(space(cast( _utf8'문자열 2' as string charset euckr)));

select space(cast(_utf8'Öö_Şş_Üü2' as string charset iso88591));
select length(space(cast(_utf8'Öö_Şş_Üü 2' as string charset iso88591)));


select space('chr(0)');

set names iso88591;
commit;
--+ holdcas off;



