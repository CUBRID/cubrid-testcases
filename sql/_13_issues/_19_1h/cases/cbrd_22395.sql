drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
select avg(i) from t;

with cte1 as
(
select avg(i) from t
)
update t set i=i-(select * from cte1);
select * from t order by 1;

with cte1 as
(
select avg(i) from t
)
delete from t where i<(select * from cte1);
select * from t order by 1;

drop table if exists t;
