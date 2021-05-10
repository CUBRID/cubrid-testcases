drop if exists src;
drop if exists t1;
drop if exists t2;
drop if exists t3;
drop if exists t4;
drop if exists t5;
drop if exists t6;
drop if exists t7;
drop if exists dst1;
drop if exists dst2;
drop if exists dst3;

--operator
create table src (a int, b int);
insert into src values (1, 1);
insert into src values (NULL, 2);
insert into src values (3, NULL);

--should fail
create table t1 as select (a*0), b from src;
desc t1;

--should fail
create table t2 as select (a*0) as a*0, b from src;
desc t2;

create table t3 as select (a*0) as [(a*0)], b from src;
desc t3;

--should fail
create table t4 as select a+b, a*b, a-b, a/b from src;
desc t4;

create table t5 as select a+b as [a+b], a*b as [a*b], a-b as [a-b], a/b as [a/b] from src;
desc t5;

--should fail
create table t6 as select sum(a), max(b), count(*), nvl(a, '') from src;
desc t6;

create table t7 as select sum(a) as [sum(a)], max(b) as [max(b)], count(*) as [count(*)] from src;
desc t7;

drop table src;

--function
create table src (name1 varchar, name2 varchar(20));
insert into src values ( 'google','google.com');
insert into src values ( 'google1','www.google1.com');
insert into src values ( NULL ,'www.google2.com');
insert into src values ( 'google3',NULL);

-- should fail
create table dst1 as select repeat(name1,2)  from src;
desc dst1;

create table dst2 as select repeat(name1,2) as repeat from src;
desc dst2;

create table dst3 as select repeat(name2,2) as [repeat(name2,2)] from src;
desc dst3;



drop src;
drop t1;
drop t2;
drop t3;
drop t4;
drop t5;
drop t6;
drop t7;
drop dst1;
drop dst2;
drop dst3;
