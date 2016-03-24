--TEST: [FilteredIndex] Filtered index doesn't work well when RENAME that table

drop table if exists t1;

create table t1 (a int, b int, c int);
create index i_t1 on t1 (a) where t1.a>0;
show index in t1;

rename table t1 to s1;
--test: check index name after renaming the table
show index in s1;

rename table s1 as t1;
show index in t1;

rename table t1 as s1;
show index in s1;

--alter column
alter table s1 change a aaa int;
show index in s1;

drop table s1;
drop table if exists t1;


