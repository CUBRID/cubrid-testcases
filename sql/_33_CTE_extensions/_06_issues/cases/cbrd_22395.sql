
drop table if exists t;

create table t(i int);

insert into t values(1);

insert into t values(3);

insert into t
WITH recursive
cte1 as (SELECT * from t where i<2),
cte2 as (SELECT * from t where i>2)
select * from cte1 union select * from cte2  order by 1;

select * from t order by 1;

WITH recursive
cte1 as (SELECT i from t where i<2),
cte2 as (SELECT i from t where i>2)
delete from t where i=some(select i from cte1 union select i from cte2);

select * from t order by 1;

WITH recursive
cte1 as (SELECT * from t where i<2),
cte2 as (SELECT * from t where i>2)
delete from t where i=some(select * from cte1 union select * from cte2);

drop table if exists  t
