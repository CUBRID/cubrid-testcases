create table t ( a int);
alter table t rename column a to b;
desc t;
drop table t;
