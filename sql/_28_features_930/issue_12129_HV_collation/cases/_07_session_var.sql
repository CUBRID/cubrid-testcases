--+ holdcas on;
set names iso88591;

set names utf8;
set @v = 2;

select @v + 2;

set names iso88591;
set @v = '2';
select @v + '2', collation (@v + '2');


prepare s from 'select @v + ?, collation (@v + ?)';
execute s using '2','2';
execute s using _utf8'2',_utf8'2';
execute s using _iso88591'2',_iso88591'2';
deallocate prepare s;

set names iso88591;
set @v1='a';
prepare stmt from 'select coercibility(?), coercibility(@v1), collation(?), collation(@v1), ? = @v1';
set names utf8 collate utf8_en_ci;
execute stmt using 'A', 'A', 'A';
set names utf8 collate utf8_en_cs;
execute stmt using 'A', 'A', 'A';
deallocate prepare stmt;



set names utf8;
set @tmp=1;
select typeof(@tmp);
select @tmp+1;
set @a=@tmp+1;
select typeof(@a);
select @a:=@tmp+1;
select typeof(@a);
select @a:=@tmp%2;
select typeof(@a);



create table t1 (s1 string collate utf8_en_ci);
insert into t1 values ('A'),('a');

select @v + s1, collation (@v + s1), hex(s1) from t1 order by 1,2,3;
drop variable @v,@v1,@tmp,@a;
drop t1;

set names iso88591;



--+ holdcas off;
