
drop table if exists t;
create table t(i int);
insert into t values(1);

drop table if exists xoo;
create table xoo as
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
select *
FROM    cte1
UNION ALL
SELECT  *
FROM    cte2
UNION ALL
SELECT  *
FROM    cte1 order by 1;



insert into xoo
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

insert into xoo
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


WITH recursive Numbers AS
(
    SELECT 1 as n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n+1 <= 10
) delete from xoo where id in (
SELECT n
FROM Numbers order by 1);



