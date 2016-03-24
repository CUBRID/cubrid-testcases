--How not to use enum in column creation
create table t1(e enum);
drop table t1;

create table t1(e enum());
drop table t1;

create table t1(e enum('a', 'b', 'c', 'a', 'd'));
drop table t1;