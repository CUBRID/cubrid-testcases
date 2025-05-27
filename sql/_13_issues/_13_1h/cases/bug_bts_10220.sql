set names utf8;

select coercibility(cast(_utf8't' as string collate euckr_bin));
select NULL + cast ( _utf8'a' as string collate euckr_bin);
prepare st from 'select coercibility(cast(? as string collate euckr_bin))';
deallocate prepare st;
prepare st from 'select coercibility(? collate euckr_bin)';
deallocate prepare st;

set names iso88591;
