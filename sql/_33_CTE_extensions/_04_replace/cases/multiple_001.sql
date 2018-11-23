drop table if exists t;
create table t as
WITH recursive cte1 AS(
  SELECT  1 AS id
  union all
  select id*2 from cte1 where id<=1024
),
cte2 AS(
  SELECT  1 AS id
  union all
  select id+1 from cte2 where id<=10240 and (3*id)=(select id from cte1 order by 1 desc limit 1)
),
cte3 as (
  select 1 AS id
  union all
  select id+1 from cte3 where id<=10240 and (6*id)=(select id from cte2 order by 1 desc limit 1)
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;


insert into t
WITH recursive cte1 AS(
  SELECT  1 AS id
  union all
  select id*2 from cte1 where id<=1024
),
cte2 AS(
  SELECT  1 AS id
  union all
  select id+1 from cte2 where id<=10240 and (3*id)=(select id from cte1 order by 1 desc limit 1)
),
cte3 as (
  select 1 AS id
  union all
  select id+1 from cte3 where id<=10240 and (6*id)=(select id from cte2 order by 1 desc limit 1)
)
SELECT  *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;
select distinct id from t;
select id,count(id) from t group by id order by id;
