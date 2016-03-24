drop table if exists t1;
drop table if exists t2;

--note: t1 has three columns
create table t1 ( a varchar, b int, c int);
insert into t1 values ('A', 1, 1);

--test: A query with three columns will be default value, it was created. We expect it's not created.
CREATE TABLE t2 ( a varchar(100) default (select a,b,c from t1));

CREATE TABLE t2 ( a varchar(100) default (select a,c from t1));

CREATE TABLE t2 ( a varchar(100) default (select t1.* from t1));

CREATE TABLE t2 ( a varchar(100) default (select t1 from t1));

CREATE TABLE t2 ( a varchar(100) default (select 1,2 from t1));

CREATE TABLE t2 ( a varchar(100) default (select count(*) from t1));

drop table t2; 

CREATE view t2 ( a varchar(100) default (select a,b,c from t1));

CREATE view t2 ( a varchar(100) default (select a,c from t1));

CREATE view t2 ( a varchar(100) default (select t1.* from t1));

CREATE view t2 ( a varchar(100) default (select t1 from t1));

CREATE view t2 ( a varchar(100) default (select 1,2 from t1));

drop table t1;
drop table t2; 

create table t1 ( a varchar, b int, c int) partition by hash(a) partitions 3;
insert into t1 values ('A', 1, 1);

--test: A query with three columns will be default value, it was created. We expect it's not created.
CREATE TABLE t2 ( a varchar(100) default (select a,b,c from t1));

CREATE TABLE t2 ( a varchar(100) default (select a,c from t1));

CREATE TABLE t2 ( a varchar(100) default (select t1.* from t1));

CREATE TABLE t2 ( a varchar(100) default (select t1 from t1));

CREATE TABLE t2 ( a varchar(100) default (select 1,2 from t1));

CREATE TABLE t2 ( a varchar(100) default (select count(*) from t1));

drop table t2; 

CREATE view t2 ( a varchar(100) default (select a,b,c from t1));

CREATE view t2 ( a varchar(100) default (select a,c from t1));

CREATE view t2 ( a varchar(100) default (select t1.* from t1));

CREATE view t2 ( a varchar(100) default (select t1 from t1));

CREATE view t2 ( a varchar(100) default (select 1,2 from t1));

drop table t1;

drop table t2; 

drop table if exists t;
drop table if exists s;

create table t (a int, b int);
create table s (a int, b int);

insert into t values (1,1), (2,2);

create table t_sel (a int default (select * from t order by 1));
drop table if exists t_sel;
create table t_sel (a int default (select a from t order by 1));
drop table if exists t_sel;
create table t_sel (a int default (select a from t order by 1 limit 1));
desc t_sel;
drop table if exists t_sel;

create table t_union (a int default ((select * from t) union (select * from s) order by 1));
drop table if exists t_union;
create table t_union (a int default ((select a from t) union (select a from s) order by 1));
drop table if exists t_union;
create table t_union (a int default ((select a from t) union (select a from s) order by 1 limit 1));
desc t_union;
drop table if exists t_union;

create table t_diff (a int default ((select * from t) difference (select * from s) order by 1));
drop table if exists t_diff;
create table t_diff (a int default ((select a from t) difference (select a from s) order by 1));
drop table if exists t_diff;
create table t_diff (a int default ((select a from t) difference (select a from s) order by 1 limit 1));
desc t_diff;
drop table if exists t_diff;

insert into s values (1,1),(2,2);
create table t_inters (a int default ((select * from t) intersect (select * from s) order by 1));
drop table if exists t_inters;
create table t_inters (a int default ((select a from t) intersect (select a from s) order by 1));
drop table if exists t_inters;
create table t_inters (a int default ((select a from t) intersect (select a from s) order by 1 limit 1));
desc t_inters;
drop table if exists t_inters;

drop s;
truncate t;

create table t_sel (a int default (select a from t order by 1));
desc t_sel;
drop t_sel;
drop t;
