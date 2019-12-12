drop if exists t1,t2,v12;
CREATE TABLE t1(i INT);
INSERT INTO t1 VALUES (1), (2), (3), (4), (5);

CREATE TABLE t2(i INT);
INSERT INTO t2 VALUES (1), (2), (3), (4), (5);
CREATE INDEX idx_t2_i ON t2(i);
with cte(a,b) as (SELECT * FROM t1 INNER JOIN t2 ON t1.i=t2.i ORDER BY 1 ) select * from cte;    

CREATE VIEW v12 AS SELECT t1.i AS i1, t2.i AS i2 FROM t1 INNER JOIN t2 ON t1.i=t2.i;

with cte as (SELECT * FROM t1 ORDER BY 1) select * from cte FOR UPDATE;
with cte as (SELECT * FROM t1 ORDER BY 1) select * from cte FOR UPDATE OF cte;
with cte(i1,i2) as (SELECT * FROM t1 INNER JOIN t2 ON t1.i=t2.i ORDER BY 1) select * from cte FOR UPDATE OF cte;

SELECT * FROM t1 INNER JOIN (with cte as (SELECT * FROM t2 WHERE t2.i > 0) select * from cte) r ON t1.i=r.i WHERE t1.i > 0 ORDER BY 1 FOR UPDATE;

with cte as (SELECT * FROM v12 ORDER BY 1 ) select * from  cte FOR UPDATE;
SELECT * FROM t1, (with cte as (SELECT * FROM v12, t2 WHERE t2.i > 0 AND t2.i=v12.i1) select * from cte) r WHERE t1.i > 0 AND t1.i=r.i ORDER BY 1 FOR UPDATE OF r;
drop if exists t1,t2,v12;