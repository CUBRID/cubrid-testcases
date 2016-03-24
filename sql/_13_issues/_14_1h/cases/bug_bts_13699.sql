--[I18N] Error occurs when comparing the column of system table with session variable.

set names utf8;
set @v='iso88591';
show collation where charset=@v;

set names euckr;
set @v='iso88591';
show collation where charset=@v;

set @v='iso88591_en_ci' collate iso88591_en_ci;
show collation where collation=@v;

set @v='utf8_en_cs' collate utf8_en_cs;
select * from db_collation where coll_name=@v;

set @v='utf8_ko_cs' collate utf8_ko_cs;
select * from _db_collation where coll_name=@v;


drop variable @v;
set names iso88591;

