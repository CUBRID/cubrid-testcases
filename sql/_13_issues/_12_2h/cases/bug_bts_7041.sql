create table t (d double);
create index idx on t(d) where d>0;
show index in t;
alter table t change d a double;
show index in t;
drop index idx on t;
drop table t;