--+ holdcas on;
set names binary;

select coercibility(cast(_utf8't' as string collate binary));
select NULL + cast ( _utf8'a' as string collate binary);
prepare st from 'select coercibility(cast(? as string collate euckr_bin))';
prepare st from 'select coercibility(? collate euckr_bin)';

set names iso88591;
commit;
--+ holdcas off;