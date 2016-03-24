--dev case1, error cases.

create table t1 (a int);
create view v1 as select * from t1;

drop view v1 cascade constraints;
drop view t1 cascade constraints;
drop v1 cascade constraints;
drop t1,v1 cascade constraints;

drop table t1 cascade constraints;
drop view v1;
