create table t(a int);
create index idx on t(a) where last_insert_id()>1000;
drop table t;