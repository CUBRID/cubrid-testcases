set system parameters 'create_table_reuseoid=no';
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- natural join --

-- 1, basic ------
create table t1 ( a int, b1 int); 
create table t2 ( a int, b2 int);

insert into t1 values(1,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

-- 2, many tables
create table t3 (a int, b3 int);
insert into t3 values(1,3);
select /*+ RECOMPILE*/ * from t1 natural join t2 natural join t3 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 natural left join t3 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 natural right join t3 order by 1,2,3,4;

-- 3, many cols
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
create table t1 ( a int, b int); 
create table t2 ( a int, b int);

insert into t1 values(1,1);
insert into t1 values(2,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

-- 4, table is derived
drop table if exists father1;
drop table if exists father2;
drop table if exists father3;
drop table if exists son1;
drop table if exists son2;
create table father1 (a int);
create table father2 (b1 int);
create table father3 (b2 int);
create table son1 under father1, father2 inherit a of father1, b1 of father2;
create table son2 under father1, father3 inherit a of father1, b2 of father3;
insert into son1 values(1,1);
insert into son2 values(1,1);
insert into son2 values(2,2);
select /*+ RECOMPILE*/ * from son1 natural join son2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from son1 natural left join son2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from son1 natural right join son2 order by 1,2,3,4;
drop table if exists father1;
drop table if exists father2;
drop table if exists father3;
drop table if exists son1;
drop table if exists son2;

-- 5, col is collection
drop table if exists t1;
drop table if exists t2;

create table t1 ( a set(int), b1 int); 
create table t2 ( a set(int), b2 int);

insert into t1 values({1},1);
insert into t2 values({1},1);
insert into t2 values({2},2);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- 6, no on cond
create table t1 ( a1 int, b1 int); 
create table t2 ( a2 int, b2 int);

insert into t1 values(1,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

drop table if exists t1;
drop table if exists t2;

-- 7, type is different
create table t1 ( a char(1), b1 int); 
create table t2 ( a int, b2 int);

insert into t1 values('a', 1);
insert into t2 values(1, 1);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

drop table t1;
create table t1 ( a char(1), b1 int); 
insert into t1 values('1', 1);

select /*+ RECOMPILE*/ * from t1 natural join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural left join t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from t1 natural right join t2 order by 1,2,3,4;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- 8, natural join in subquery
create table t1 ( a int, b1 int); 
create table t2 ( a int, b2 int);
create table t3 ( a int, b3 int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);

insert into t2 values(1, 3);
insert into t2 values(2, 4);

insert into t3 values(1, 9);
insert into t3 values(2, 8);
insert into t3 values(3, 7);
insert into t3 values(4, 6);

select t3.b3 from t3 where t3.a in (select t2.b2 from t1 natural join t2) order by 1;
select t3.b3 from t3 where t3.a in (select t2.b2 from t1 inner join t2 on t1.a = t2.a) order by 1;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- 9, subquery in natural
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 ( a int, b int); 
create table t2 ( a int, b int);
create table t3 ( a int, b int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);

insert into t2 values(1, 3);
insert into t2 values(2, 4);

insert into t3 values(1, 9);
insert into t3 values(2, 8);
insert into t3 values(3, 7);
insert into t3 values(4, 6);

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural join (select a, b as bb from t2) order by 1,2,3,4;
select * from t1 natural join (select a as txx, b from t2) order by 1,2,3,4;
select * from t1 natural join (select * from t1,t2) order by 1,2,3,4;

select * from (select * from t2) natural join t1 order by 1,2,3,4;
select * from t1 natural join (select t2.a as txx, t3.a from t2,t3) order by 1,2,3,4;
select * from t1 natural left join (select t2.a as txx, t3.* from t2,t3) order by 1,2,3,4;

select * from t1 natural join (select * from t2) as tt order by 1,2,3,4;
select * from t1 inner join (select * from t2) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select a, b as bb from t2) as tt order by 1,2,3,4;
select * from t1 inner join (select a, b as bb from t2) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (select a as txx, b from t2) as tt order by 1,2,3,4;
select * from t1 inner join (select a as txx, b from t2) as tt on t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t1,t2) as tt order by 1,2,3,4;

select * from (select * from t2) as tt natural join t1 order by 1,2,3,4;
select * from (select * from t2) as tt inner join t1 on tt.a = t1.a and tt.b = t1.b order by 1,2,3,4;
select * from t1 natural join (select t2.a as txx, t3.a from t2,t3) as tt order by 1,2,3,4;
select * from t1 inner join (select t2.a as txx, t3.a from t2,t3) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural left join (select t2.a as txx, t3.* from t2,t3) as tt order by 1,2,3,4;
select * from t1 left join (select t2.a as txx, t3.* from t2,t3) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;

select * from t1 natural join (select * from t2) as tt(a, bxx) order by 1,2,3,4;
select * from t1 inner join (select * from t2) as tt(a, bxx) on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (values(1,1)) order by 1,2,3,4;
select * from t1 natural join (values(1 as a,1)) order by 1,2,3,4;
select * from t1 natural join (values(1 as a,1)) as tt order by 1,2,3,4;
select * from t1 inner join (values(1 as a,1)) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (values(1 as a,1),(2,1) order by 1,2);
select * from t1 natural join (values(1 as a,1),(2,1)) as tt order by 1,2,3,4;
select * from t1 natural join (values(1,1),(2,1)) as tt(a, bxx) order by 1,2,3,4;
select * from t1 inner join (values(1 as a,1),(2,1)) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (values(1 as a,1 as b),(2,1)) order by 1,2,3,4;
select * from t1 inner join (values(1 as a,1 as b),(2,1)) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;

create table t4 (a int, b int);
insert into t4 values(1,1);
select * from t1 natural join (select * from t1 difference select * from t4 order by 1,2);
select * from t1 natural join (select * from t1 difference select * from t4) as tt order by 1,2,3,4;
select * from t1 natural join (select * from t1 difference select * from t4) as tt(a,b) order by 1,2,3,4;
select * from t1 inner join (select * from t1 difference select * from t4) as tt(a,b) on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t1 intersection select * from t4) order by 1,2,3,4;
select * from t1 inner join (select * from t1 intersection select * from t4) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t2 union select * from t4) order by 1,2,3,4;
select * from t1 inner join (select * from t2 union select * from t4) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;

select * from t1 natural join (select a, b as bxx from t1 difference select * from t4) order by 1,2,3,4;
select * from t1 inner join (select a, b as bxx from t1 difference select * from t4) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (select a, b as bxx from t1 intersection select * from t4) order by 1,2,3,4;
select * from t1 inner join (select a, b as bxx from t1 intersection select * from t4) as tt on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (select a, b as bxx from t2 union select * from t4) order by 1,2,3,4;
select * from t1 inner join (select a, b as bxx from t2 union select * from t4) as tt on t1.a = tt.a order by 1,2,3,4;

select * from t1 natural join (select * from t1 difference select a, b as bxx from t4) order by 1,2,3,4;
select * from t1 inner join (select * from t1 difference select a, b as bxx from t4) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t1 intersection select a, b as bxx from t4) order by 1,2,3,4;
select * from t1 inner join (select * from t1 intersection select a, b as bxx from t4) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t2 union select a, b as bxx from t4) order by 1,2,3,4;
select * from t1 inner join (select * from t2 union select a, b as bxx from t4) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;

select * from t1 natural join (select * from t1 difference values(1 as a,1)) order by 1,2,3,4;
select * from t1 natural join (select * from t1 difference values(1 as a,1)) as tt order by 1,2,3,4;
select * from t1 natural join (select * from t1 difference values(1,1)) as tt(a,bxx) order by 1,2,3,4;
select * from t1 inner join (select * from t1 difference values(1,1)) as tt(a,bxx) on t1.a = tt.a order by 1,2,3,4;
select * from t1 natural join (select * from t1 intersection values(1,1)) order by 1,2,3,4;
select * from t1 inner join (select * from t1 intersection values(1,1)) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;
select * from t1 natural join (select * from t2 union values(1,1)) order by 1,2,3,4;
select * from t1 inner join (select * from t2 union values(1,1)) as tt on t1.a = tt.a and t1.b = tt.b order by 1,2,3,4;

select * from ((select 1 as x) as t1) inner join ((select 1 as x) as t2) on t1.x = t2.x order by 1,2;
select * from ((select 1 as x) as t1) natural join ((select 1 as x) as t2) order by 1,2;
select * from ((select 1 as x) as t1) inner join ((select 2 as x) as t2) on t1.x = t2.x order by 1,2;
select * from ((select 1 as x) as t1) natural join ((select 2 as x) as t2) order by 1,2;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;

-- 10, view
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 ( a int, b int); 
create table t2 ( a int, b int);
create table t3 ( a int, b int);

insert into t1 values(1, 1);
insert into t1 values(2, 2);

insert into t2 values(1, 3);
insert into t2 values(2, 4);

insert into t3 values(1, 9);
insert into t3 values(2, 8);
insert into t3 values(3, 7);
insert into t3 values(4, 6);

create view v2 as select * from t2;
select * from t1 natural join v2 order by 1,2,3,4;
select * from t1 natural left join v2 order by 1,2,3,4;
select * from t1 natural right join v2 order by 1,2,3,4;

create view v3 as select a, b as tx from t3;
select * from t1 natural join v3 order by 1,2,3,4;
select * from t1 natural left join v3 order by 1,2,3,4;
select * from t1 natural right join v3 order by 1,2,3,4;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop view if exists v2;
drop view if exists v3;

-- 11, attribute is set/object/enum/numeric

-- enum ---
drop table if exists t1;
drop table if exists t2;
create table t1(color ENUM('red', 'yellow', 'blue', 'green'), b1 int);
create table t2(color ENUM('red', 'yellow', 'blue', 'green'), b2 int);

insert into t1 values('red', 1);
insert into t1 values('yellow', 2);

insert into t2 values('red', 3);
insert into t2 values('blue', 4);

select * from t1 natural join t2 order by 1,2,3,4;
select * from t1 natural left join t2 order by 1,2,3,4;
select * from t1 natural right join t2 order by 1,2,3,4;

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural left join (select * from t2) order by 1,2,3,4;
select * from t1 natural right join (select * from t2) order by 1,2,3,4;


-- set --
drop table if exists t1;
drop table if exists t2;

create table t1(a SET(int), b1 int);
create table t2(a SET(int), b2 int);

insert into t1 values({1,2}, 1);
insert into t1 values({3,4}, 2);

insert into t2 values({1,2}, 3);
insert into t2 values({5,6}, 4);

select * from t1 natural join t2 order by 1,2,3,4;
select * from t1 natural left join t2 order by 1,2,3,4;
select * from t1 natural right join t2 order by 1,2,3,4;

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural join (select a, b2 as txx from t2) order by 1,2,3,4;
select * from t1 natural left join (select * from t2) order by 1,2,3,4;
select * from t1 natural right join (select * from t2) order by 1,2,3,4;


-- MULTISET --
drop table if exists t1;
drop table if exists t2;

create table t1(a MULTISET(int), b1 int);
create table t2(a MULTISET(int), b2 int);

insert into t1 values({1,2}, 1);
insert into t1 values({3,4}, 2);

insert into t2 values({1,2}, 3);
insert into t2 values({5,6}, 4);

select * from t1 natural join t2 order by 1,2,3,4;
select * from t1 natural left join t2 order by 1,2,3,4;
select * from t1 natural right join t2 order by 1,2,3,4;

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural join (select a, b2 as txx from t2) order by 1,2,3,4;
select * from t1 natural left join (select * from t2) order by 1,2,3,4;
select * from t1 natural right join (select * from t2) order by 1,2,3,4;

-- LIST -- 
drop table if exists t1;
drop table if exists t2;

create table t1(a LIST(int), b1 int);
create table t2(a LIST(int), b2 int);

insert into t1 values({1,2}, 1);
insert into t1 values({3,4}, 2);

insert into t2 values({1,2}, 3);
insert into t2 values({5,6}, 4);

select * from t1 natural join t2 order by 1,2,3,4;
select * from t1 natural left join t2 order by 1,2,3,4;
select * from t1 natural right join t2 order by 1,2,3,4;

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural join (select a, b2 as txx from t2) order by 1,2,3,4;
select * from t1 natural left join (select * from t2) order by 1,2,3,4;
select * from t1 natural right join (select * from t2) order by 1,2,3,4;

-- object -- 
drop table if exists t0;
drop table if exists t1;
drop table if exists t2;

create table t0(aa int, bb int);
insert into t0 values(1,1);
insert into t0 values(2,2);
insert into t0 values(3,3);

select t0 into:t01 from t0 where aa = 1 order by 1;
select t0 into:t02 from t0 where aa = 2 order by 1;
select t0 into:t03 from t0 where aa = 3 order by 1;

create table t1(a t0, b1 int);
create table t2(a t0, b2 int);

insert into t1 values(:t01, 1);
insert into t1 values(:t02, 2);

insert into t2 values(:t01, 3);
insert into t2 values(:t03, 4);

select * from t1 natural join t2 order by 2,3,4;
select * from t1 natural left join t2 order by 2,3,4;
select * from t1 natural right join t2 order by 2,3,4;

select * from t1 natural join (select * from t2) order by 2,3,4;
select * from t1 natural join (select a, b2 as b1 from t2) order by 2,3,4;
select * from t1 natural left join (select * from t2) order by 2,3,4;
select * from t1 natural right join (select * from t2) order by 2,3,4;

drop table if exists t0;
drop table if exists t1;
drop table if exists t2;

-- NUMERIC --
drop table if exists t1;
drop table if exists t2;

create table t1(a numeric(10,5), b1 int);
create table t2(a numeric(10,5), b2 int);

insert into t1 values(1.1, 1);
insert into t1 values(2.2, 2);

insert into t2 values(2.2, 3);
insert into t2 values(3.3, 4);

select * from t1 natural join t2 order by 1,2,3,4;
select * from t1 natural left join t2 order by 1,2,3,4;
select * from t1 natural right join t2 order by 1,2,3,4;

select * from t1 natural join (select * from t2) order by 1,2,3,4;
select * from t1 natural join (select a, b2 as b1 from t2) order by 1,2,3,4;
select * from t1 natural left join (select * from t2) order by 1,2,3,4;
select * from t1 natural right join (select * from t2) order by 1,2,3,4;

drop table if exists t1;
drop table if exists t2;
set system parameters 'create_table_reuseoid=yes';
