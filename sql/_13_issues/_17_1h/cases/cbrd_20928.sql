drop table if exists t1;
drop view if exists v1;
create table t1 (a int, b int);
create view v1 as select * from t1;
insert into t1 values (1,1), (2,2);
with c1 as (select * from t1)
select  * from t1, c1, v1
union all
select  * from t1, c1, v1 order by 1,2,3,4,5,6;
drop view if exists v1;
drop table if exists t1;
create table t1 (a int, b int);
create view v1 as select * from t1;
insert into t1 values (1,1), (2,2);
with c1 as (select * from v1)
select * from (select  c1.* from c1, v1) t order by 1,2;
drop view if exists v1;
drop table if exists t1;
