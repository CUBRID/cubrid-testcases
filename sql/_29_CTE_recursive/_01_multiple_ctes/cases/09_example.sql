drop if exists t;
create table t(i int);
insert into t values(1);
insert into t values(3);
WITH 
    cte1 as (SELECT * from t where i<2),
    cte2 as (SELECT * from t where i>2)
select * from cte1 
select * from cte2;
drop if exists t;

WITH recursive cte1(txt) AS (SELECT 'This '),
     cte2(txt) AS (SELECT CONCAT(cte1.txt,'is a ') FROM cte1),
     cte3(txt) AS (SELECT 'nice query' UNION
                   SELECT 'query that rocks' UNION
                   SELECT 'query'),
     cte4(txt) AS (SELECT concat(cte2.txt, cte3.txt) FROM cte2, cte3)
SELECT MAX(txt), MIN(txt) FROM cte4;
