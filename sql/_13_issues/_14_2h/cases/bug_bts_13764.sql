drop table if exists foo;
create table foo (a int, b int, c int);
 insert into foo values (1, 1, 1);
insert into foo values (1, 2, 2);
insert into foo values (1, 3, 3);
 select *
from (select a, b, count(c) from foo group by a) J;
 select *
from (select a, b, count(c) from foo group by a) J
where J.b = 1;
select /*+ recompile */ a, b, count(c) from foo group by a having b=1;
select /*+ recompile */ a, b, count(c) from foo group by a having a=1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a  having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a  having b=a;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+c;
select /*+ recompile */ a, b, count(c) from foo group by a having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a having count(a)<>0;

 insert into foo values (1, 1, 2);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
 insert into foo values (1, 0, 2);
 insert into foo values (1, 0, 1);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
 insert into foo values (2, 0, 2);
 insert into foo values (2, 0, 1);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+count(c);

drop table if exists foo;
create table foo (a int, b int, c int);
 insert into foo values (1, 3, 3);
insert into foo values (1, 2, 2);
insert into foo values (1, 1, 1);
 select *
from (select a, b, count(c) from foo group by a) J;
 select *
from (select a, b, count(c) from foo group by a) J
where J.b = 1;
 select *
from (select a, b, count(c) from foo group by a) J
where J.a = 1;
select /*+ recompile */ a, b, count(c) from foo group by a having b=1;
select /*+ recompile */ a, b, count(c) from foo group by a having a=1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a  having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a  having b=a;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+c;
select /*+ recompile */ a, b, count(c) from foo group by a having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a having count(a)<>0;
select /*+ recompile */ a, b, count(c) from foo group by a, b+1 having b+1>1;

 insert into foo values (1, 1, 2);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
 insert into foo values (1, 0, 2);
 insert into foo values (1, 0, 1);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
 insert into foo values (2, 0, 2);
 insert into foo values (2, 0, 1);
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+count(c);

drop table if exists foo; 
create table foo (a int, b int, c int);
 insert into foo values (1, 1, 1);
insert into foo values (1, 2, 2);
insert into foo values (1, 3, 3);

insert into foo values (2, 2, 1);
insert into foo values (2, 1, 2);

 select * from (select a, b, count(c) from foo group by a) J order by 1,2,3;
 select * from (select a, b, count(c) from foo group by a) J where J.b = 1;

select /*+ recompile */ a, b, count(c) from foo group by a having b=1;

select /*+ recompile */ a, b, count(c) from foo group by a having a=1;

select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+c;
select /*+ recompile */ a, b, count(c) from foo group by a having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a having count(a)<>0;
select /*+ recompile */ a, b, count(c) from foo group by a, b+1 having b+1>1;
select /*+ recompile */ a, b, count(c) from foo group by a, b+1 having b+1>1;
drop  table foo;

drop table if exists foo; 
create table foo (a int, b int, c int);
 insert into foo values (1, 1, 1);
insert into foo values (1, 2, 2);
insert into foo values (1, 3, 3);

insert into foo values (2, 1, 1);
insert into foo values (2, 2, 2);

 select * from (select a, b, count(c) from foo group by a) J order by 1,2,3;
 select * from (select a, b, count(c) from foo group by a) J where J.b = 1;

select /*+ recompile */ a, b, count(c) from foo group by a having b=1;

select /*+ recompile */ a, b, count(c) from foo group by a having a=1;

select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a having a=b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+1;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a=b+c;
select /*+ recompile */ a, b, count(c) from foo group by a having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a, b having a between a and b;
select /*+ recompile */ a, b, count(c) from foo group by a having count(a)<>0;
select /*+ recompile */ a, b, count(c) from foo group by a, b+1 having b+1>1;
select /*+ recompile */ a, b, count(c) from foo group by a, b+1 having b+1>1;
drop  table foo;

drop table if exists t;
create table t (i numeric(10,1), j double,k date,l varchar(200),m char(200),n bigint ) partition by hash(n) partitions 10;
create index idx_t_i on t (i);
create index idx_t_j on t (j);
insert into t select rownum,rownum, TO_DATE('12/25/2008'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;
insert into t select rownum,rownum, TO_DATE('12/25/2009'),rownum||'',rownum||'',rownum from db_class a,db_class b limit 1000;
select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 0 limit 10;
select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j > 10 limit 10;
select /*+ recompile */ i,j,count(*) from t where i > 5 and i < 200 group by i having j =10 limit 10;




drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT);
INSERT INTO t1 VALUES(1,1,1);
INSERT INTO t1 VALUES(2,NULL,2);
INSERT INTO t1 VALUES(2,2,2);
SELECT /*+ recompile*/ a, NVL(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b=2 order by 1,2;
SELECT /*+ recompile */ a, NVL(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b is null order by 1,2;

SELECT a, NVL(b,2) AS bxxx,count(*) FROM t1 GROUP BY a, bxxx having b=2  order by 1,2;
SELECT a, NVL(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b=1 order by 1,2;
SELECT a, NVL(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b is null order by 1,2;
SELECT a, NVL(b,2)AS bxxx,count(*)  FROM t1 GROUP BY a, bxxx having b is null order by 1,2;
SELECT a, NVL(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b is not null order by 1,2;
SELECT a, NVL(b,2)AS bxxx,count(*)  FROM t1 GROUP BY a, bxxx having b is not null order by 1,2;
drop table t1;

drop table if exists t1;
CREATE TABLE t1(a INT, b INT, c INT);
INSERT INTO t1 VALUES(1,1,1);
INSERT INTO t1 VALUES(2,2,2);
INSERT INTO t1 VALUES(2,NULL,2);
SELECT  a, ifnull(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b=2 order by 1,2;
SELECT  a, ifnull(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b is null order by 1,2;
SELECT  a,b, ifnull(b,2) AS bxxx FROM t1 GROUP BY a, bxxx having b=2 order by 1,2;
SELECT  a,b, ifnull(b,2) AS bxxx FROM t1 GROUP BY a, bxxx  order by 1,2;
drop t1;


drop table if exists t1;
 create table t1 (i int ,j char,k int );
 insert into t1 values(3,'a',3);
insert into t1 values(1,'a',1);
insert into t1 values(2,'a',2);
 insert into t1 values(4,'b',4);
insert into t1 values(1,'b',1);
 insert into t1 values(5,'b',5);
 insert into t1 values(6,'c',6);
insert into t1 values(1,'c',1);
 insert into t1 values(7,'c',7);
 select i,k from t1 group by j;
 select newt.i,newt.k from (select * from t1 order by 1,2,3 ) newt group by newt.j; 
 select i,k from t1 group by j having i=1; 
select newt.i,newt.k from (select * from t1 order by 1,2,3 )  newt group by newt.j having newt.i=1; 

 select newt.i,newt.k from (select * from t1 order by 1 desc,2 ,3 ) newt group by newt.j; 
 select i,k from t1 group by j having i=1; 
select newt.i,newt.k from (select * from t1 order by 1 desc,2,3 )  newt group by newt.j having newt.i=1; 

drop table if exists t;

create table t (i int, j int, k int, l int);

insert into t values
(0,0,0,0),
(0,0,1,1),
(0,1,0,2),
(0,1,1,3),
(1,0,0,4),
(1,0,1,5),
(1,1,0,6),
(1,1,1,7),
(null, 0, 0, 8),
(null, 1, 1, 9),
(0, null, 0, 10),
(1, null, 1, 11),
(0, 0, null, 12),
(1, 1, null, 13),
(null, null, null, 14);
select /*+ recompile */ i, count(*) from t group by i ;
select /*+ recompile */ i, count(*) from t group by i having i<>0 and j<>0;
select /*+ recompile */ i, (count(*)=3) from t group by i ;
select /*+ recompile */ i, (count(*)=3) from t group by i having i<>0 and j<>0;
 select /*+ recompile */ i, j,count(*) from t group by i ;
drop t;
CREATE TABLE t (
    yyyy INT,
    mm INT,
    sales_sum double
);

INSERT INTO t  VALUES
    (2000, 1, 1000), (2000, 2, 770), (2000, 3, 630), (2000, 4, 890),
    (2000, 5, 500), (2000, 6, 900), (2000, 7, 1300), (2000, 8, 1800),
    (2000, 9, 2100), (2000, 10, 1300), (2000, 11, 1500), (2000, 12, 1610),
    (2001, 1, 1010), (2001, 2, 700), (2001, 3, 600), (2001, 4, 900),
    (2001, 5, 1200), (2001, 6, 1400), (2001, 7, 1700), (2001, 8, 1110),
    (2001, 9, 970), (2001, 10, 690), (2001, 11, 710), (2001, 12, 880),
    (2002, 1, 980), (2002, 2, 750), (2002, 3, 730), (2002, 4, 980),
    (2002, 5, 1110), (2002, 6, 570), (2002, 7, 1630), (2002, 8, 1890),
    (2002, 9, 2120), (2002, 10, 970), (2002, 11, 420), (2002, 12, 1300);

SELECT yyyy, sum(sales_sum)
FROM t
GROUP BY yyyy;

SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy  having yyyy=2000 and sum(sales_sum) >10000;
SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy  having yyyy=2000 and mm=1;

SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy  having yyyy=2000 or  sum(sales_sum) >10000;
SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy  having mm=1 or  sum(sales_sum) >10000;

SELECT /*+ recompile */ yyyy,mm, sales_sum/sum(sales_sum) as percent
FROM t
GROUP BY yyyy  having mm=1 or  sum(sales_sum) >10000;

SELECT yyyy, sum(sales_sum)
FROM t
GROUP BY yyyy having mm <=10;
SELECT yyyy, sum(sales_sum)
FROM t
GROUP BY yyyy having mm =10;
SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy,mm with rollup ;
SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy,mm with rollup having mm is null ;
SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy,mm with rollup having mm=1 ;

SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy,mm with rollup having yyyy=2000 ;

SELECT yyyy,mm, sales_sum,sum(sales_sum)
FROM t
GROUP BY yyyy,mm with rollup having yyyy=2000 and sum(sales_sum) >10000;
SELECT yyyy,mm, sales_sum,sum(sales_sum) FROM t GROUP BY yyyy  having yyyy=2000 and mm=2;
SELECT yyyy,mm, sales_sum,sum(sales_sum) FROM t GROUP BY yyyy  having sales_sum=1000  or  mm=2;
SELECT yyyy,mm, sales_sum,sum(sales_sum) FROM t GROUP BY yyyy  having sales_sum=1000  and  mm=2;


drop t;
drop table if exists t1;
