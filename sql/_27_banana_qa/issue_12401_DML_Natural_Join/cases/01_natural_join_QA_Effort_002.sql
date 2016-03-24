
drop table if exists t1;
drop table if exists t2;

-- natural join --
-- test with the same data types
-- 1, test with 2 tables(2 columns) natural join, the column name order is the same.
create table t1 ( a int, b1 int); 
create table t2 ( a int, b2 int);

insert into t1 values(1,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;
create table t1 ( a int, b int); 
create table t2 ( a int, b int);

insert into t1 values(1,1);
insert into t1 values(2,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;

-- 2, test with 2 tables(2 columns) natural join, the column name order is the different.
create table t1 ( a int, b int); 
create table t2 ( b int, a int);

insert into t1 values(1,1);
insert into t1 values(2,1);
insert into t2 values(1,2);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;


drop table if exists t1;
drop table if exists t2;

create table t1 ( a int, b int); 
create table t2 ( b int, a int);

insert into t1 values(1,1);
insert into t1 values(1,1);
insert into t1 values(2,1);
insert into t2 values(1,2);
insert into t2 values(2,2);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 order by 1,2,3,4;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 order by 1,2,3,4;

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 order by t2.a,t2.b;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 order by t2.a,t2.b;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 order by t2.a,t2.b;

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 order by t2.a desc,t2.b desc;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 order by t2.a desc,t2.b desc;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 order by t2.a desc,t2.b desc;

drop table if exists t1;
drop table if exists t2;


-- 3, test with 2 tables(1,2 columns) natural join, the column name order is the same.
drop table if exists t1;
drop table if exists t2;

create table t1 ( a1 int); 
create table t2 ( a1 int, b2 int);

insert into t1 values(1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;

-- 4, test with 2 tables(1,2 columns) natural join, the column name order is the different.
drop table if exists t1;
drop table if exists t2;

create table t1 ( a1 int); 
create table t2 ( b2 int,a1 int);

insert into t1 values(1);
insert into t2 values(1,1);
insert into t2 values(2,2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;


-- 5, test with 3 tables(2 columns) natural join, the column name order is the same.
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
create table t1 ( a int, b1 int); 
create table t2 ( a int, b1 int);
insert into t1 values(1,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

create table t3 (a int, b1 int);
insert into t3 values(1,3);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 natural join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 natural left join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 natural right join (select * from t3 order by 1,2) t3;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;


-- 6, test with 3 tables(2 columns) natural join, the column name order is the different.
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
create table t1 ( a int, b1 int); 
create table t2 ( a int, b2 int);
insert into t1 values(1,1);
insert into t2 values(1,1);
insert into t2 values(2,2);

create table t3 (a int, b2 int);
insert into t3 values(1,3);
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 natural join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 natural left join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 natural right join (select * from t3 order by 1,2) t3;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;


-- test with different data types
-- 1, test with 2 tables(2 columns) natural join, the column name order is the same.
-- col is collection
drop table if exists t1;
drop table if exists t2;

create table t1 ( a set(int), b1 int); 
create table t2 ( a set(int), b1 int);

insert into t1 values({1},1);
insert into t2 values({1},1);
insert into t2 values({2},2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;


-- 2, test with 2 tables(2 columns) natural join, the column name order is the different.
-- col is collection
drop table if exists t1;
drop table if exists t2;

create table t1 ( a set(int), b1 int); 
create table t2 (  b1 int, a set(int));

insert into t1 values({1},1);
insert into t2 values({1},1);
insert into t2 values({2},2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;

-- 3, test with 2 tables(1,2 columns) natural join, the column name order is the same.
-- col is collection
drop table if exists t1;
drop table if exists t2;

create table t1 ( a set(int)); 
create table t2 ( a set(int), b1 int);

insert into t1 values({1});
insert into t2 values({1},1);
insert into t2 values({2},2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;


-- 4, test with 2 tables(1,2 columns) natural join, the column name order is the different.
-- col is collection
drop table if exists t1;
drop table if exists t2;

create table t1 ( a set(int)); 
create table t2 (  b1 int,a set(int) );

insert into t1 values({1});
insert into t2 values(1,{1});
insert into t2 values(2,{2});

select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;

-- 5, test with 3 tables(2 columns) natural join, the column name order is the same.
-- col is collection
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 ( a set(int), b1 int); 
create table t2 ( a set(int), b1 int);
create table t3 ( a set(int), b1 int);

insert into t1 values({1},1);
insert into t2 values({1},1);
insert into t2 values({2},2);
insert into t3 values({2},2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 natural join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 natural left join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 natural right join (select * from t3 order by 1,2) t3;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

-- 6, test with 3 tables(2 columns) natural join, the column name order is the different.
-- col is collection
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1 ( a set(int), b1 int); 
create table t2 (  b1 int ,a set(int));
create table t3 ( a set(int), b1 int);

insert into t1 values({1},1);
insert into t2 values({1},1);
insert into t2 values({2},2);
insert into t3 values({2},2);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2 natural join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2 natural left join (select * from t3 order by 1,2) t3;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2 natural right join (select * from t3 order by 1,2) t3;

drop table if exists t1;
drop table if exists t2;
drop table if exists t3;



-- 7, test with 5 tables(derived)(2 columns) natural join.
-- table is derived
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


-- 7, type is different
drop table if exists t1;
drop table if exists t2;

create table t1 ( a char(1), b1 int); 
create table t2 ( a int, b2 int);

insert into t1 values('a', 1);
insert into t2 values(1, 1);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table t1;
create table t1 ( a char(1), b1 int); 
insert into t1 values('1', 1);

select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural left join (select * from t2 order by 1,2) t2;
select /*+ RECOMPILE*/ * from (select * from t1 order by 1,2) t1 natural right join (select * from t2 order by 1,2) t2;

drop table if exists t1;
drop table if exists t2;


drop table if exists t1;
drop table if exists t2;

create table t1 ( a char(1)); 
create table t2 ( b char(1));


insert into t1 values('a');
insert into t2 values('b');
insert into t2 values('c');


--will fail.Fail is right.
select /*+ RECOMPILE*/ * from t1 natural left join t2 on t1.a=t2.b order by 1;
--will fail.Fail is right.
select /*+ RECOMPILE*/ * from t1 natural right join t2 on t1.a=t2.b order by 1;

drop table if exists t1;
drop table if exists t2;