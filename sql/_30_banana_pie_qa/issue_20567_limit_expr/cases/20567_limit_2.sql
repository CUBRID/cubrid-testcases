--+ holdcas on;
drop table if exists t1, t2;

create table t1(a int, b varchar(10), c int);
create table t2(a int, b varchar(10), c int);
insert into t1 values(1, 'a', 1);
insert into t1 values(2, 'b', 1);
insert into t1 values(3, 'c', 2);
insert into t1 values(4, 'd', 2);
insert into t1 values(5, 'e', 3);
insert into t1 values(6, 'f', 3);
insert into t2 values(1, 'a', 100);
insert into t2 values(3, 'c', 100);
insert into t2 values(5, 'e', 200);
insert into t2 values(7, 'g', 200);
insert into t2 values(9, 'i', 300);

select a, b, (select avg(c) from t1 where a=ttt.a limit 20-1) as average from t1 ttt order by 1, 2 limit (1-1+2)*8/16, 5*2-1-3*1;
select a, b, average from (select a, b, (select sum(c) from t2 where a=t1.a limit 1-0*9) as average from t1 limit  1+4-1) where a < 8 order by 1, 2 limit 1-1, 5/2+1;
select * from t1 where b in (select max(b) from t2 where a=t1.a) order by 1, 2 limit 1+0*1, 2*(2+1);
select * from t2 where a = any(select avg(t2.c/100) from t1 where b in (select max(b) from t2)) order by 1, 2 limit 1+0-0.1, 5*2.00+1;

--view
create view v1 as select t1.a, t2.c from t1, t2 where t1.b=t2.b limit 0+1, 1+2-3+4*5/2;
select * from v1 limit 0+0, 1+200 ;
select * from v1 where a is not null order by a desc limit 0+0, 1+(200*0)/3+4/3 ;
show create view v1;
drop view v1;

--cte
with cte as (select * from t1 where t1.a%2 = 0 order by t1.a limit 1-1,3*3)
select * from cte limit 8/2/2 offset 8/8;

with cte as (select * from t1 where t1.a%2 = 0 order by t1.a limit 0,3*3)
select * from cte limit 2*2-1 offset 0;

drop table if exists t1, t2;

--partition by list
drop table if exists foo, foo1;
create table foo(a int unique) partition by list (a)(
	partition p0 values in (1,2,3),
	partition p1 values in (4,5,6),
	partition p2 values in (7,8,9)
);
insert into foo values (1);
insert into foo values (2);
insert into foo values (3),(4),(7);
insert into foo values (9) on duplicate key update a = 5;
insert into foo values (9) on duplicate key update a = 5;
select * from foo order by 1 limit (0+1), 1;
select * from foo order by 1 limit (0+1) offset 1;

select * from foo__p__p0 order by 1 limit (0+1), 1*7;
select * from foo__p__p2 order by 1 limit (0+1) offset 0;

create table foo1(a int,b  varchar(30)) partition by list(b) (partition b1 values in ('1','3','2') );
insert into foo1 select '1','3' from db_class limit 4 offset 0;
insert into foo1 select '2','3' from db_class limit 4 offset 0;

select * FROM foo LEFT JOIN foo1 ON foo.a=foo1.a WHERE foo.a=1 limit 19-2*9, 2/4+3;
select distinct * FROM foo LEFT JOIN foo1 ON foo.a=foo1.a order by 1 limit 3 offset 0;

drop table if exists foo, foo1;

--partition by hash
drop table if exists t1,t2;

create table t1 (a int primary key) partition by hash(a) partitions 3; 
insert into t1 select rownum from db_class limit 0, 4*11;

create table t2 (a int primary key) partition by hash(a) partitions 3; 
insert into t2 select rownum from db_class limit 0, 4*11+4;

select * FROM t1 LEFT JOIN t2 ON t1.a=t2.a WHERE t1.a=25 limit 43453481*1-3234324/101 ;
update statistics on all classes;
select /*+ recompile use_nl */ * FROM t1 LEFT JOIN t2 ON t1.a=t2.a limit 0-21312+21312,32344*32344/32344/32344*10 ;

drop table if exists t1, t2;

--partition by range
drop table if exists participant2;

CREATE TABLE participant2 (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT, e enum('a', 'c', 'b', 'e', 'd', 'x', 'y', 'z') )
PARTITION BY RANGE (host_year)
(PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
 
INSERT INTO participant2 VALUES (1988, 'NZL', 3, 2, 8, 3);
INSERT INTO participant2 VALUES (1988, 'CAN', 3, 2, 5, 1);
INSERT INTO participant2 VALUES (1996, 'KOR', 7, 15, 5, 2);
INSERT INTO participant2 VALUES (2000, 'RUS', 32, 28, 28, 5);
INSERT INTO participant2 VALUES (2004, 'JPN', 16, 9, 12, 4);
select * from participant2 order by e limit 0, 4*2+3/2;
select * from participant2 order by e limit 0+4 offset 2+3/2;
select * from participant2 where gold < 20 order by e limit (2+3)/2;

drop table if exists participant2;


--+ holdcas off;


