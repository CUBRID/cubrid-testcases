--+ holdcas on;
create table t1 (i int, d double);
--test create fail
create index idx on t1 (sqrt(sqrt(d)));
--test create fail
create index idx on t1 (sqrt(d+1));
--test create fail
create index idx on t1 (sqrt(d)) where i>0;
--test create fail
create index idx on t1 (sqrt(i));
--test create fail
create index idx on t1 (i+1,sqrt(d));
--test create successfully
create index idx on t1 (i,sqrt(d));
drop table t1;
commit;
--+ holdcas off;
