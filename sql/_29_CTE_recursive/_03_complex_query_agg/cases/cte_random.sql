WITH t0(so) AS (
        SELECT ROW_NUMBER() OVER (ORDER BY v0 ASC) AS so
        FROM (values (0)) as t(v0)
    )
SELECT 1 AS k1, a3.so AS k2
FROM t0 AS a3

UNION ALL

SELECT 2 AS k2, a8.so AS k2
FROM t0 AS a8;

drop if exists t;
create table t(e1 int primary key,e2 varchar(10));
insert into t values(1,'a');
WITH qry_0 as /*+ no_inline */ (SELECT e2 AS a1, e1 as str FROM  t) select (select e1 from t) as x, a1 from qry_0;
insert into t values(2,'a');
WITH qry_0 as /*+ no_inline */ (SELECT e2 AS a1, e1 as str FROM  t) select (select e1 from t) as x, a1 from qry_0;
drop if exists t;

WITH tmp as
(SELECT * FROM db_root)
SELECT 123 as col2, count(tmp.*) FROM tmp;

with t(d,n) as
  (
 select cast('2017-2-20' as date), 1
  from db_root
  union all
  select t.d  + 1, t.n +1
  from t
  where  t.n < 10
  )
  select n from t;
  
  with rec(dayc,LV) as(
select cast(date '2010-04-15' as date),1 
union all
select cast(dayc+1 as date),LV+1
  from rec
 where LV<= 3)
select * from rec;

with rec(lv, dayc, dayc2) as
(
select 1, cast('2017-2-20' as date), null 
 union all
select  lv + 1, cast(dayc as date) + 1, dayc  from rec  where lv <= 3
)
select *  from rec;

with y as (
select * from (with rec(lv, dayc, dayc2) as
(
select 1, cast(sysdate as date), null 
 union all
select  lv + 1, cast(dayc as date) + 1, dayc  from rec  where lv <= 3
)
select *  from rec) x)select lv from y order by 1;

with y as (
select  list(with rec(lv, dayc, dayc2) as
(
select 1, cast(sysdate as date), null 
 union all
select  lv + 1, cast(dayc as date) + 1, dayc  from rec  where lv <= 3
)
select lv  from rec) as x)select * from y order by 1;

