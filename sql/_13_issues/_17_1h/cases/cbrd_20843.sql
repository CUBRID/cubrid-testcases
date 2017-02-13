drop table if exists t1;
CREATE TABLE t1 (a INT);
INSERT INTO t1 VALUES (1),(2),(3);
SELECT * FROM (WITH a AS (SELECT * FROM t1) SELECT 1) AS t1;

SELECT * FROM 
( 
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=6
)select n1 from cte1
) AS t1;
SELECT * FROM 
( 
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=6
)select n1 from cte1
);

SELECT * FROM 
( 
with  recursive cte1 as 
(
select 1 as n1,1 as n2 
union all select 2*n1,n2+1 from cte1 where n2<=6
)select n1 from cte1
) t1 order by 1;

drop table if exists t1;
