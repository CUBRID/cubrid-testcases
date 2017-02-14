drop table if exists t1;
create table t1 (id1 int primary key);
insert into t1 values(1);
insert into t1 values(2);

WITH cte_nuYx6xUTh AS
(
select default(id1) from t1
)
select * from cte_nuYx6xUTh;

select default(id1) from t1;

select * from (select id1+1 from t1) t1 order by 1;

with cte as (select * from (select id1+1 from t1) t1) select * from cte order by 1;

drop table if exists t1;
