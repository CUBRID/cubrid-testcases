--+ holdcas on;
drop table if exists t,t2;
--add select 1,2,3 into :a,:b,:c is in order to delete variable which was set in other sql file
select 1,2,3 into :a,:b,:c;
drop variable a,b,c;
--clear vaiable end
create table t (i char(10), j int) partition by hash(i) partitions 5;

create index idx on t (i);

insert into t values (1, 1);
insert into t values (1, 2);
insert into t values (1, 3);
insert into t values (2, 1);
insert into t values (2, 2);
insert into t values (2, 3);
insert into t values (3, 1);
insert into t values (3, 2);
insert into t values (3, 3);
insert into t values (4, 1);
insert into t values (4, 2);
insert into t values (4, 3);
insert into t values (5, 1);
insert into t values (5, 2);
insert into t values (5, 3);
insert into t values (6, 1);
insert into t values (6, 2);
insert into t values (6, 3);
insert into t values (7, 1);
insert into t values (7, 2);
insert into t values (7, 3);
insert into t values (8, 1);
insert into t values (8, 2);
insert into t values (8, 3);
insert into t values (9, 1);
insert into t values (9, 2);
insert into t values (9, 3);
insert into t values (10, 1);
insert into t values (10, 2);
insert into t values (10, 3);

create table t2 under t;

insert into t2 select * from t;

create view v as select * from t2;

select /*+ recompile */ i,j from v where i > -5 group by i limit 4;

select /*+ recompile */ i,j from v where i in (5,6,7) and j<10 group by i limit 101;

select /*+ recompile */ i,j from v where i > -5 group by i limit 2,4;

select /*+ recompile */ i,j from v where i > -5 group by i limit 100;

select /*+ recompile */ i,j from v where i > -5 group by i having j > 0 limit 4;

select /*+ recompile */ i,j from v where i > -5 group by i having j > 0 limit 2,4;

select /*+ recompile */ i,j from v where i > -5 group by i having j > 0 limit 100;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 0 limit 4;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 0 limit 2,4;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 0 limit 100;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 3 limit 4;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 3 limit 2,4;

select /*+ recompile */ i,j from v where i > -5 group by i having avg(j) > 3 limit 100;

drop table if exists t1,t2;

create table t1(a int primary key, b char(10));
insert into t1 values(1, 'a');
insert into t1 values(2, 'b');
insert into t1 values(3, 'c');

create table t2(a int, b char(10));
insert into t2 values(1, 'a');
insert into t2 values(2, 'b');
insert into t2 values(3, 'c');

create view v as select (select t2.b from t2 where t1.a=t2.b) b, t1.a from t1;

drop view v;

create view v as select * from t1;

select /*+ recompile */ a,b from v where a > -5 group by a having avg(a) > 3 limit 100;

select /*+ recompile */ a,b from v where a > -5 group by "";

select /*+ recompile */ a,b,count(*) from v where a > 0 group by 1;

select /*+ recompile */ b,a,count(*),avg(a) from v where a > 0 group by 2;

drop table if exists t1,t2;
drop view v;
drop table if exists t;

CREATE TABLE t(a int, b VARCHAR(20));
INSERT INTO t VALUES
(501, 'a'),
(501, 'a'),
(501, 'b'),
(501, 'b'),
(501, 'c'),
(501, 'c');
 
SELECT a , b FROM t WHERE a > 100 GROUP BY b  WITH ROLLUP;

drop table if exists t1,t2,t;

create table t1(a int primary key auto_increment, b char(10));
insert into t1 values(null, 'a');
insert into t1 values(null, 'b');
insert into t1 values(null, 'c');

create table t2(a int, b char(10));
insert into t2 values(1, 'a');
insert into t2 values(2, 'b');
insert into t2 values(3, 'c');

create view v as select (select t2.b from t2 where t1.a=t2.b) b, t1.a from t1;

drop view v;

select * from v;

create view v as select a from t1 group by a;
drop view v;

create view v as select b from t1 group by a;


select /*+ recompile */ a,b from v where a > -5 group by a having avg(a) > 3 limit 100;

select /*+ recompile */ a,b from v where a > -5 group by "";

select /*+ recompile */ a,b,count(*) from v where a > 0 group by 1;

select /*+ recompile */ b,a,count(*),avg(a) from v where a > 0 group by 2;

drop table if exists t1,t2;
drop view v;

drop table if exists t1,t2,t;

create table t1(a int auto_increment, b char(10));
insert into t1 values(null, 'a');
insert into t1 values(null, 'b');
insert into t1 values(null, 'c');

create table t2(a int, b char(10));
insert into t2 values(1, 'a');
insert into t2 values(2, 'b');
insert into t2 values(3, 'c');

create view v as select a,b from t1 group by a;
drop view v;

create view v as select incr(b) from t1 group by (a);

drop table if exists t1,t2;
commit;
--+ holdcas off;

