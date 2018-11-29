drop table if exists t;
create table t(i int);
insert into t values(1);
insert into t values(3);

WITH recursive
    cte1 as (SELECT i from t where i<2),
    cte2 as (SELECT i from t where i>2)
update t set i=i+1 
where i=some(select i from cte1 union select i from cte2);
select * from t order by 1;

WITH recursive
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
update t set i=i+1 
where i=some(select i from cte1 union select i from cte2);
select * from t order by 1;

WITH recursive
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
update t set i=i+1
where i=any(select i from cte1);
select * from t order by 1;

WITH recursive
    cte1 as (SELECT i from t where i<2),
    cte2 as (SELECT i from t where i>2)
update t set i=i+1
where i=some(select i from cte1 union all select i from cte2);
select * from t order by 1;

drop table if exists t,t1,t2;
create table t1(i int);
create table t2(i int);
insert into t1 values(1),(3),(4);
insert into t1 values(3),(4),(5),(6);

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
update t1 set i=i+1 
where i=any(select i from cte1 difference select i from cte2);

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
update t1 set i=i+1
where i=any(select i from cte1 intersect select i from cte2);
select * from t1 order by 1;


with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
update t1 set i=i+1
where i in (select i from cte1 intersect select i from cte2);
select * from t1 order by 1;

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)

update t1 set i=i+1
where exists (select i from cte1 union all select i from cte2);

drop table if exists t1,t2,t;


