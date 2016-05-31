--+ holdcas on;

set names binary;
set @v1='abc' collate binary;
set @v2=_binary'def';

prepare stmt_charset from 'select charset(concat(?, ?))';
execute stmt_charset using @v1,@v2;
execute stmt_charset using 'a','b';
prepare stmt_coll from 'select collation(concat(?, ?))';
execute stmt_coll using @v1,@v2;
execute stmt_coll using 'a','b';
prepare stmt_coerce from 'select coercibility(concat(?, ?))';
execute stmt_coerce using @v1,@v2;
execute stmt_coerce using 'a','b';

deallocate prepare stmt_charset;
deallocate prepare stmt_coll;
deallocate prepare stmt_coerce;
drop variable @v1, @v2;

set names iso88591;

commit;
--+ holdcas off;
