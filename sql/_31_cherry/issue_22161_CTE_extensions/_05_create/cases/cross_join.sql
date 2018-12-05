drop if exists t1,t2;
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
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4;

select * from foo order by 1,2,3,4;

insert into foo
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4;

select * from foo order by 1,2,3,4;


with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2)
,cte3 as
(select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4)
delete foo from foo inner join cte3 on foo.a1=cte3.a1 and foo.a2=cte3.a2 and foo.b1=cte3.b1 and foo.b2=cte3.b2;

select * from foo order by 1,2;

replace into foo
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4;

select * from foo order by 1,2,3,4;

with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2)
,cte3 as
(select * from cte1 NATURAL JOIN cte2 order by 1,2,3,4)
update  foo inner join cte3 on foo.a1=cte3.a1 and foo.a2=cte3.a2 and foo.b1=cte3.b1 and foo.b2=cte3.b2
set foo.a1=foo.a1+100
, foo.a2=foo.a2+200
, foo.b1=foo.b1+300
, foo.b2=foo.b2+400;

select * from foo order by 1,2,3,4;

drop table foo;


create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 INNER JOIN cte2 on a1=a2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;


drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL LEFT JOIN  cte2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;


drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 NATURAL RIGHT JOIN  cte2 order by 1,2,3,4;
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 LEFT JOIN  cte2 on a1=a2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;


drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 RIGHT JOIN  cte2 on a1=a2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;

drop table foo;
create table foo as
with cte1 as
(SELECT /*+ RECOMPILE*/ * FROM t1)
,cte2 as
(SELECT /*+ RECOMPILE*/ *FROM t2) select * from cte1 CROSS JOIN  cte2 order by 1,2,3,4;
select * from foo order by 1,2,3,4;
drop if exists t1,t2,foo;
