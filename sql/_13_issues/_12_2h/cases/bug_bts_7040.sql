create table t (d double);
create index idx on t(sqrt(d));
show index in t;
alter table t change d a double;
show index in t;
drop index idx on t(sqrt(a))
drop table t;