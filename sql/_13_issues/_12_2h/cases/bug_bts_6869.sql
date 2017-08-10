create table t(a char(10));
create index idx on t(a(1));
alter index idx on t(a(1)) where a>'0' rebuild;
drop table t;
