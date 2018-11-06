drop table if exists t1,t2;
CREATE TABLE t1 (a1 int, b1 int);
CREATE TABLE t2 (a2 int, b2 int);
INSERT INTO t1 values(1,1);
INSERT INTO t1 values(3,3);
INSERT INTO t2 values(1,1);
INSERT INTO t2 values(2,2);

drop table if exists foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL JOIN cte2  order by 1,2,3,4;

select * from foo;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) delete foo INNER JOIN cte2 on foo.a2=cte2.a2 INNER JOIN cte1 on foo.a1=cte1.a1 ;
select * from foo;


drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL LEFT JOIN  cte2 order by 1,2,3,4;
select * from foo;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) update foo NATURAL RIGHT JOIN  cte2 set foo.b1=-2 ;
select * from foo;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) update foo LEFT JOIN cte2 on foo.a1=cte2.a2 set foo.b1=-3;
select * from foo;


drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 RIGHT JOIN  cte2 on a1=a2 order by 1,2,3,4;
select * from foo;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) update foo RIGHT JOIN  cte2 on foo.a1=cte2.a2 set foo.b1=-10;
select * from foo;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) update foo CROSS JOIN cte2 set foo.b1=0;
select * from foo;
drop if exists t1,t2;
~                                                                                                                                            
Type  :quit<Enter>  to exit Vim                                                                                            1,1           All
