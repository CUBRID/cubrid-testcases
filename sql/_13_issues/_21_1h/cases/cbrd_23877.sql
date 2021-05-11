drop if exists src;
drop if exists t1;
drop if exists t2;
drop if exists t3;
drop if exists t4;
drop if exists t5;
drop if exists dst1;
drop if exists dst2;

--operator
create table src (a int, b int, name1 varchar, name2 varchar(20));
insert into src values (1, 1, 'google','google.com');
insert into src values (NULL, 2, 'google1','www.google1.com');
insert into src values (3, NULL, NULL ,'www.google2.com');
insert into src values (NULL, NULL, 'google3',NULL);

--should fail
create table t1 as select (a*0), b from src;
desc t1;

--should fail
create table t1 as select (a*0) as a*0, b from src;
desc t1;

create table t1 as select (a*0) as [(a*0)], b from src;
desc t1;

--should fail
create table t2 as select a+b, a*b, a-b, a/b from src;
desc t2;

create table t2 as select a+b as [a+b], a*b as [a*b], a-b as [a-b], a/b as [a/b] from src;
desc t2;

--should fail
create table t3 as select sum(a), max(b), count(*), nvl(a, '') from src;
desc t3;

create table t3 as select sum(a) as [sum(a)], max(b) as [max(b)], count(*) as [count(*)] from src;
desc t3;

create table t4 as with cte as 
(
select (a*0), b from src
)
select * from cte;
desc t4;

drop t4;
create table t4 as with cte as 
(
select (a*0) as [(a*0)], b from src
)
select * from cte;
desc t4;

--should fail
create table t5 replace as select (a*0), b from src;
desc t5;

create table t5 replace as select (a*0) as [(a*0)], b from src;
desc t5;

--function
-- should fail
create table dst1 as select repeat(name1,2), char_length(name2) from src;
desc dst1;

create table dst1 as select repeat(name1,2) as repeat, char_length(name2) as length from src;
desc dst1;

drop dst1;
create table dst1 as select repeat(name1,2) as [repeat(name2,2)], char_length(name2) as [char_length(name2)]from src;
desc dst1;

--should fail
create table dst2 as select a, b, last_value(b) over (partition by a order by b) from src;
desc dst2;

create table dst2 as select a, b, last_value(b) over (partition by a order by b) as ret_val from src;
desc dst2;

drop src;
drop t1;
drop t2;
drop t3;
drop t4;
drop t5;
drop dst1;
drop dst2;
