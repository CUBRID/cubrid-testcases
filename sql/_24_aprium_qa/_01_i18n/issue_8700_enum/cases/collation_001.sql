--addition in late binding using enum type
--+ holdcas on;

drop table if exists t2;
set names utf8 collate utf8_en_ci;

select ('A'='a');
create table t2 (e2 enum('A','B'));
show full columns from t2;

insert into t2 values ('a');
select * from t2 order by 1;

drop table t2;

set names iso88591;

commit;
--+ holdcas off;
