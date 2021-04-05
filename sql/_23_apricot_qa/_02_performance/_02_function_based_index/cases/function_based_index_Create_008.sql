--+ holdcas on;
create table t1 (i int, d double);
create index idx on t1 (sqrt(d));
--test insert fail
insert into t1 value(1,-1);
drop table t1;
create table t1 (i int, d double);
insert into t1 value(1,-1);
--test create fail
create index idx on t1 (sqrt(d));
drop table t1;
commit;
--+ holdcas off;
