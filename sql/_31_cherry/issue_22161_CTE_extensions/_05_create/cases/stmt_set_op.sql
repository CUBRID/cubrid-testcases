drop table if exists t1,t2,foo1,foo2,foo3,foo4;

CREATE TABLE t1 (ID INT, Name VARCHAR(32));
INSERT INTO t1 VALUES (1,'Kim');
INSERT INTO t1 VALUES (2,'Moy');
INSERT INTO t1 VALUES (3,'Jonas');
INSERT INTO t1 VALUES (4,'Smith');
INSERT INTO t1 VALUES (5,'Kim');
INSERT INTO t1 VALUES (6,'Smith');
INSERT INTO t1 VALUES (7,'Brown');

CREATE TABLE t2 (id INT, Name VARCHAR(32));
INSERT INTO t2 VALUES (5,'Kim');
INSERT INTO t2 VALUES (6,'Smith');
INSERT INTO t2 VALUES (7,'Brown');
INSERT INTO t2 VALUES (8,'Lin');
INSERT INTO t2 VALUES (9,'Edwin');
INSERT INTO t2 VALUES (10,'Edwin');

create table foo1 as
with cte as
(
SELECT id, name FROM t1
UNION
SELECT id, name FROM t2
) select * from cte;

create table foo2 as
with cte as
(
SELECT id, name FROM t1
UNION ALL
SELECT id, name FROM t2
)select * from cte;


create table foo3 as
with cte as
(
SELECT id, name FROM t1
DIFFERENCE
SELECT id, name FROM t2
)select * from cte;

create table foo4 as
with cte as
(
SELECT id, name FROM t1
INTERSECT
SELECT id, name FROM t2
)select * from cte;

select * from foo1 order by 1,2;
select * from foo2 order by 1,2;
select * from foo3 order by 1,2;
select * from foo4 order by 1,2;



with cte1 as
(
SELECT id, name FROM t1
UNION
SELECT id, name FROM t2
) ,
 cte2 as
(
SELECT id, name FROM t1
UNION ALL
SELECT id, name FROM t2
),
cte3 as
(
SELECT id, name FROM t1
DIFFERENCE
SELECT id, name FROM t2
),
cte4 as
(
SELECT id, name FROM t1
INTERSECT
SELECT id, name FROM t2
) delete foo2 where id in (select id from cte4);
select * from foo2 order by 1,2;


with cte1 as
(
SELECT id, name FROM t1
UNION
SELECT id, name FROM t2
) delete from foo1 where id in (select id from cte1
DIFFERENCE
select id from foo2
);
select * from foo1 order by 1,2;


with cte as
(
SELECT id, name FROM t1
INTERSECT
SELECT id, name FROM t2
) update foo1,foo2
 set foo1.id=foo1.id+100
, foo2.id=foo2.id+100
where (select count(n1) from 
(
  with cte_tmp as
  (
  SELECT id, name FROM foo1
  INTERSECT
  SELECT id, name FROM foo2 ) select * from cte_tmp
) as x(n1,n2) ) >= (select count(id) from cte);
select * from foo1 order by 1,2;
select * from foo2 order by 1,2;


with cte as
(
SELECT id, name FROM foo1
DIFFERENCE
SELECT id, name FROM foo2
) delete from foo1,foo2 using foo1,foo2
where (select count(*) from cte)=0;
select * from foo1 order by 1,2;
select * from foo2 order by 1,2;


insert into foo3
with cte1 as
(
SELECT id, name FROM t1
UNION
SELECT id, name FROM t2
) ,
 cte2 as
(
SELECT id, name FROM t1
UNION ALL
SELECT id, name FROM t2
),
cte3 as
(
SELECT id, name FROM t1
DIFFERENCE
SELECT id, name FROM t2
),
cte4 as
(
SELECT id, name FROM t1
INTERSECT
SELECT id, name FROM t2
)select * from cte4 order by 1,2;

select * from foo3 order by 1,2; 




replace into foo4
with cte1 as
(
SELECT id, name FROM t1
UNION
SELECT id, name FROM t2
) ,
 cte2 as
(
SELECT id, name FROM t1
UNION ALL
SELECT id, name FROM t2
),
cte3 as
(
SELECT id, name FROM t1
DIFFERENCE
SELECT id, name FROM t2
),
cte4 as
(
SELECT id, name FROM t1
INTERSECT
SELECT id, name FROM t2
)select * from cte3 order by 1,2;

select * from foo4 order by 1,2;

drop table if exists t1,t2,foo1,foo2,foo3,foo4;

