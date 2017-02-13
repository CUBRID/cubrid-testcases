drop if exists t;
create table t(i int);
insert into t values(1);
WITH recursive cte1(id) AS(
  SELECT  1  from t
  union all
  select id*2 from cte1 where id<=1024
),
cte2(id) AS(
  SELECT  1  from t
  union all
  select cte2.id+1 from cte2,cte1 where cte2.id<=10240 and (3*cte2.id)=cte1.id
),
cte3(id) as (
  select 1 from t
  union all
  select cte3.id+1 from cte3,cte2 where cte3.id<=10240 and (6*cte3.id)=cte2.id
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;

WITH recursive cte1(id) AS(
  SELECT  1  from t
  union all
  select id*2 from cte1 where id<=1024
),
cte2(id) AS(
  SELECT  1  from t
  union all
  select cte2.id+1 from cte2,cte1 where cte2.id<=10240 and (4*cte2.id)=cte1.id
),
cte3(id) as (
  select 1 from t
  union all
  select cte3.id+1 from cte3,cte2 where cte3.id<=10240 and (8*cte3.id)=cte2.id
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte3 order by 1;

drop if exists t;
WITH recursive cte1 AS(
  SELECT  1 AS id
  union all
  select id*2 from cte1 where id<=1024
),
cte2 AS(
  SELECT  1 AS id
  union all
  select id+1 from cte2 where id<=10240 and (3*id)=cte1.id
),
cte3 as (
  select 1 AS id
  union all
  select id+1 from cte3 where id<=10240 and (6*id)=cte2.id
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;

WITH recursive cte1 AS(
  SELECT  1 AS id
  union all
  select id*2 from cte1 where id<=1024
),
cte2 AS(
  SELECT  1 AS id
  union all
  select id+1 from cte2 where id<=10240 and (3*id)=cte1.id
),
cte3 as (
  select 1 AS id
  union all
  select id+1 from cte3 where id<=10240 and (6*id)=cte2.id
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;
drop if exists t;
