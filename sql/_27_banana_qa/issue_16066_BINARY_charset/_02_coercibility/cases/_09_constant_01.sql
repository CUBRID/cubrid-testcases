--+ holdcas on;
set names binary;

select coercibility(cast(_utf8't' as string collate binary));
select NULL + cast ( _utf8'a' as string collate binary);
prepare st from 'select coercibility(cast(? as string collate euckr_bin))';
deallocate prepare st;
prepare st from 'select coercibility(? collate euckr_bin)';
deallocate prepare st;
set names iso88591;
commit;
--+ holdcas off;
