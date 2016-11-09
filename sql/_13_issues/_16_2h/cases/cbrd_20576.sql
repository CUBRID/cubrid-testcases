--+ holdcas on;
set names utf8;

select disk_size('aa');
select disk_size(_binary'aa');

set names binary;
select  disk_size('모음');
select  disk_size(cast('모음' as string collate euckr_bin));

set names utf8;
drop table if exists t1;
create table t1(s1 string collate utf8_bin,
s2 varchar collate euckr_bin,
s3 varchar collate binary);
insert into t1 values(repeat('我',300),repeat('모음',150),repeat('abcd',120));
select * from t1;
select disk_size(s1),disk_size(s2),disk_size(s3) from t1;


set @a1='a' collate utf8_en_cs;
set names iso88591;
select disk_size(@a1);

set names euckr;
prepare st1 from 'select disk_size(?)';
execute st1 using '모음';


drop table t1;
drop variable @a1;
deallocate prepare st1;
set names iso88591;
--+ holdcas off;
