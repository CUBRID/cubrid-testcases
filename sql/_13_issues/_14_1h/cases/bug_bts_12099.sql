drop table if exists t1;
drop view if exists v1;
create table t1 (i1 int, s1 string);
create view v1 as select q.* from (select case when i1=1 then abs('1') end from t1) q;
select * from v1;
drop view if exists v1;
drop table if exists t1;
