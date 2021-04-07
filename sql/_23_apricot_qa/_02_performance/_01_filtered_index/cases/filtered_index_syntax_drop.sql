--+ holdcas on;
create table t(d int);
--test
create index idx on t(d) where d>0;
--test
drop index on t(d);
--test
create index idx on t(d) where d>0;
--test
drop index on t(d) where d>0;

--test
create index idx on t(d) where d>0;
--test
drop index idx on t(d);
--test
create index idx on t(d) where d>0;
--test
drop index idx on t(d) where d>0;
drop index idx on t(d);
drop table t;
commit;
--+ holdcas off;
