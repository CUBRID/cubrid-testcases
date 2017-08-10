drop if exists t1;
create table t1(i int);
insert into t1 values(1);
insert into t1 values(3);
insert into t1 values(5);
with recursive cte(row_cnt,n) as (
select 1,1
union all
select count(row_cnt) over(order by row_cnt),n+1 from cte where n<=5)
select row_cnt from cte order by 1;
with recursive cte1(row_cnt) as (select count(i) from t1 where i<=1),
cte2(row_cnt) as (select count(i) from t1 where i >1  and i<=3),
cte3(row_cnt) as (select count(i) from t1 where i >1  and i<=3),
cte4(row_cnt) as (select count(*) from t1 where i>3 and i<=5)
 select count(*) over () from (select * from cte1
 union all
 select * from cte2
 union all
 select * from cte3
 union all
 select * from cte4) order by 1
;
drop table t1;
