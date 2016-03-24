
--01_natural_join_002.sql
------------------------------
--the different data types: test with 2 tables(2 column) natural join, the column name order is the same.
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b char(10)); 
create table t2 ( a int, b char(10));

insert into t1 values(3,'hello');
insert into t1 values(1,null);
insert into t2 values(3,'hello');
insert into t2 values(5,null);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 order by 1,2,3,4;

--the different data types: test with 2 tables(2 column) natural join, the column name order is the different.
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b char(10)); 
create table t2 ( b int, a char(10));

insert into t1 values(3,'hello');
insert into t1 values(1,null);
insert into t2 values(3,'hello');
insert into t2 values(5,null);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 ;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

------------------------------
--the different data types: test with 2 tables(1,2 column) natural join, the column name order is the same.
drop table if exists t1;
drop table if exists t2;


create table t1 ( a int, b char(10)); 
create table t2 ( a int);

insert into t1 values(3,'hello');
insert into t1 values(1,'hello');
insert into t2 values(3);
insert into t2 values(5);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1) t2;

--the different data types: test with 2 tables(1,2 column) natural join, the column name order is the different.
drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b char(10)); 
create table t2 ( b int);

insert into t1 values(3,4);
insert into t1 values(1,2);
insert into t2 values(3);
insert into t2 values(5);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1) t2;

------------------------------
--the different data types: test with 4 tables(2 column) natural join, the column name order is the same.
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;

create table t1 ( a int, b char(10)); 
create table t2 ( a int, b char(10));
create table t3 ( a int, b char(10)); 
create table t4 ( a int, b char(10));

insert into t1 values(3,'hello');
insert into t1 values(1,2);
insert into t2 values(3,'hello');
insert into t2 values(5,6);
insert into t3 values(3,'hello');
insert into t3 values(1,2);
insert into t4 values(3,'hello');
insert into t4 values(5,6);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 natural join (select * from t3 order by 1,2) t3 natural join t4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 natural left join (select * from t3 order by 1,2) t3 natural left join t4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 natural right join (select * from t3 order by 1,2) t3 natural right join t4;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;

--the different data types: test with 4 tables(2 column) natural join, the column name order is the different.
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
create table t1 ( a int, b char(10)); 
create table t2 ( b int, a char(10));
create table t3 ( c int, d char(10)); 
create table t4 ( a int, b char(10));

insert into t1 values(3,'hello');
insert into t1 values(1,2);
insert into t2 values(3,'hello');
insert into t2 values(5,6);
insert into t3 values(3,'hello');
insert into t3 values(1,2);
insert into t4 values(3,'hello');
insert into t4 values(5,6);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;