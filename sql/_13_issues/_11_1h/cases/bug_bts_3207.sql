create table t1 (a int, b int, c int);
create view v1 as select * from t1;
alter view v1 as select a from t1;
select * from v1;

drop view v1;
drop table t1;


