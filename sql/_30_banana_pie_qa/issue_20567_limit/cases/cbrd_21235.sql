--+ holdcas on;

drop table if exists t1;
create table t1 (a int);
insert into t1 select rownum from db_class limit 15;
with cte as (select * from t1) select * from cte order by 1 limit 5;
with cte as (select * from t1) select * from cte order by 1 limit 0, 10; 

with cte as (select * from t1) select * from cte order by 1 limit 5*1+(0-0/1)*0;
with cte as (select * from t1) select * from cte order by 1 limit 0*1+(0-0/1)*0, 10*1/1+1-1;



drop table if exists t1;



--+ holdcas off;
