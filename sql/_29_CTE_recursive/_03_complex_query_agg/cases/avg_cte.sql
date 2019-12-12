drop if exists t1;
create table t1(i int);
insert into t1 values(1);
insert into t1 values(3);
insert into t1 values(5);
with recursive cte as (
select 1 m,1 n,1 l
union all
select 1,avg(i) over(order by i),rownum  from t1 where i<=1 
union all 
select m+1,n+1,l+1 from cte where l<5
)
select *  from cte order by 1;
with recursive cte as (
select 1 m,1 n,1 l
union all
select m+1,avg(i) over(partition by i order by i),l+1 from t1,cte where i<=1 and l<5)
select * from cte order by 1;
with recursive cte as (
select 1 m,1 l
union all
select avg(i) over(partition by i),l+1 as cnt from t1,cte where i >1  and i<=3 and l<5)
select * from cte order by 1;
with recursive cte as (
select 1 m,1 l
union all
select avg(i) over(partition by i),l+1 from t1,cte where i>3 and i<=5 and l<5)
select * from cte order by 1;
with recursive cte as (
select 1 m,1 l
union all
select avg(i) over(partition by i),l+1 from t1,cte where i>5 and l<5)
select * from cte;
with recursive cte1(row_cnt) as (select avg(i) from t1 where i<=1),
cte2(row_cnt) as (select avg(i) from t1 where i >1  and i<=3),
cte3(row_cnt) as (select avg(i) from t1 where i >1  and i<=3),
cte4(row_cnt) as (select avg(i) from t1 where i>3 and i<=5)
 select avg(row_cnt) over () from (select * from cte1
 union all
 select * from cte2
 union all
 select * from cte3
 union all
 select * from cte4)order by 1;
drop table t1;
