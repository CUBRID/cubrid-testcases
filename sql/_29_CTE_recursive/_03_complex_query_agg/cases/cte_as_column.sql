drop if exists t1,t2;
CREATE TABLE t1(i INT);
INSERT INTO t1 VALUES (1), (2), (3), (4), (5);
CREATE TABLE t2(i INT);
INSERT INTO t2 VALUES (1), (2), (3), (4), (5);
select i, list(with cte as (SELECT * FROM t2 ORDER BY 1) select * from cte)  from t1;
select i, list(with cte as (SELECT * FROM t2 ORDER BY 1) select * from cte) as j from t1;
select i, (with cte as (SELECT * FROM t2 ORDER BY 1) select * from cte order by 1 limit 1) as j from t1;
select i, (with cte as (select 1 m union all  SELECT i+1 FROM t2 where i<10 ORDER BY 1) select * from cte order by 1 desc limit 1) as j from t1;
select i, (with cte(m) as (select 1 m union all  SELECT m+1 FROM cte where m<10 ORDER BY 1) select * from cte order by 1) as j from 
t1;
select i, (with cte(m) as (select 1 m union all  SELECT m+1 FROM cte where m<10 ORDER BY 1) select * from cte order by 1 desc limit 1) as j  from t1;
drop if exists t1,t2;
