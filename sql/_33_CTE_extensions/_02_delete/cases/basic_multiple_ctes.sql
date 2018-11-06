drop table if exists t;
create table t(i int);
insert into t(i) values(1),(2),(3);
with cte1 as
(select 1),
cte2 as
(select 2)
delete from t where i in (select * from cte1 union all select * from cte2);
drop table if exists t;


