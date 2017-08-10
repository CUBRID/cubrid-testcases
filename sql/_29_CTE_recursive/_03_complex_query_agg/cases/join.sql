drop if exists t1,t2;
CREATE TABLE t1 (a int, b1 int);
CREATE TABLE t2 (a int, b2 int);

INSERT INTO t1 values(1,1);
INSERT INTO t1 values(3,3);
INSERT INTO t2 values(1,1);
INSERT INTO t2 values(2,2);
with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4;

with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 INNER JOIN cte2 on cte1.a=cte2.a order by 1,2,3,4;

with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL LEFT JOIN  cte2 order by 1,2,3,4;

with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL RIGHT JOIN  cte2 order by 1,2,3,4;
with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 LEFT JOIN  cte2 on cte1.a=cte2.a order by 1,2,3,4;

with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 RIGHT JOIN  cte2 on cte1.a=cte2.a order by 1,2,3,4;

with cte1 as 
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as 
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 CROSS JOIN  cte2 order by 1,2,3,4;
drop if exists t1,t2;