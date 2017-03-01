drop table if exists t1,t2;
create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1, 1);
insert into t2 values (1, 1);
insert into t1 values (2, 2);
insert into t1 values (1, 1);
insert into t1 values (2, 2);
insert into t2 values (3, 3);
with c1(i, j) as (
select * from t1
UNION 
select i+1, j+1 from c1 where i<5
) select * from c1;

with c1(i, j) as (
select * from t1 
UNION
select * from t2
union 
select i+1, j+1 from c1 where i<5
) select * from c1 order by 1,2;

with c1(i, j) as (
select * from t1 
INTERSECTION 
select * from t2
union all
select i+1, j+1 from c1 where i<5
) select * from c1 order by 1,2;

with c1(i, j) as (
select * from t1
DIFFERENCE
select * from t2
union all
select i+1, j+1 from c1 where i<5
) select * from c1 order by 1,2;


with c1(i, j) as (
select * from t1
UNION ALL
select * from t2
union all
select i+1, j+1 from c1 where i<5
) select * from c1 order by 1,2;



with c1(i, j) as (
select * from t1
UNION ALL
select * from t2
INTERSECTION
select i+1, j+1 from c1 where i<5
) select * from c1 order by 1,2;
drop table if exists t1,t2;
