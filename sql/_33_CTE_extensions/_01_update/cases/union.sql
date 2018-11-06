drop table if exists t;
create table t(i int);
insert into t values(1);
insert into t values(3);

insert into t
WITH recursive 
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
select * from cte1 union select * from cte2  order by 1;

select * from t;

WITH recursive
    cte1 as (SELECT i from t where i<2),
    cte2 as (SELECT i from t where i>2)
delete from t where i=some(select i from cte1 union select i from cte2);
select * from t;

WITH recursive
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
delete from t where i=some(select * from cte1 union select * from cte2);

insert into t values(1);
insert into t values(3);

WITH recursive
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
delete from t where i=some(select * from cte1);

WITH recursive
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
delete from t where i=some(select i from cte1);
select * from t;

insert into t values(1);
insert into t values(3);
WITH recursive
    cte1 as (SELECT i from t where i<2),
    cte2 as (SELECT i from t where i>2)
delete from t where i=some(select i from cte1 union all select i from cte2);
select * from t;

drop table if exists t,t1,t2;
create table t1(i int);
create table t2(i int);
insert into t1 values(1),(3),(4);
insert into t1 values(3),(4),(5),(6);

insert into t1
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select i from cte1 difference select i from cte2;

insert into t1
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select i from cte1 union select i from cte2;

insert into t1
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select i from cte1 union all select i from cte2;

replace into t1
with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
select i from cte1 intersect select i from cte2;


with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
delete from t1 where i in (select i from cte1 intersect select i from cte2);


with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
delete from t1 where i in (select i from cte1 union all select i from cte2);


with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
delete from t1 where i in (select i from cte1 union  select i from cte2);

with cte1 as
(
 select * from t1
),
cte2 as
(
 select * from t2
)
delete from t1 where i in (select i from cte1 difference select i from cte2);


