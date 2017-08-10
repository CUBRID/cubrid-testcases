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

drop table if exists t;
create table t(i int);
insert into t values(1);
WITH  cte1(id) AS(
  SELECT  1  from t
  union all
  select id*2 from cte1 where id<=1024
),cte2(id) AS(
  SELECT 1 from t
  union all
  select id+1 from cte2 where id<=10240 and 3*cte2.id in (select * from cte1)
  ),cte3(id) AS(
  select 1  from t
  union all
  select id+1 from cte3 where id<=10240 and 6*cte3.id   in (select * from cte2)
) 
SELECT  * 
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;
drop table t;

WITH Numbers AS
(
    SELECT 1 as n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n+1 <= 10
)
SELECT n
FROM Numbers order by n;

WITH recursive Numbers AS
(
    SELECT 1 as n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n+1 <= 10
)
SELECT n
FROM Numbers order by 1;
