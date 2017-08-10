drop if exists t;
create table t(i int);
insert into t values(1);
insert into t values(3);
WITH recursive 
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
select * from cte1 union select * from cte2  order by 1;
drop if exists t;
