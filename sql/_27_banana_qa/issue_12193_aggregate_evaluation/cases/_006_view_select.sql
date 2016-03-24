--test aggregate functions in subqueries of select statement in a view

drop table if exists t1, t2;
drop view if exists v1, v2;

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

create view v1 as select * from t1 where a < 7 and c > -1;
create view v2 as select * from t2 where b in ('a', 'c', 'e', 'g', 'i');

--test: as select expression
select a, b, (select avg(c) from v1 where a=ttt.a) as average from v1 ttt order by 1, 2;  
select a, b, (select sum(c) from v2 where a=v1.a) as average from v1 order by 1, 2;  
select (select count(v1.c) from v2 where b < 'f') as average from v1 order by 1;  
select a, b, (select count(v1.c) from v2 where b < 'f') as average from v1 order by 1, 2;  

--test: as table specification
select a, b, average from (select a, b, (select avg(c) from v1 where a=ttt.a) as average from v1 ttt) order by 1, 2;
select a, b, average from (select a, b, (select sum(c) from v2 where a=v1.a) as average from v1) where a < 8 order by 1, 2;
select a, b, average from (select a, b, (select count(v1.c) from v2 where b < 'f') as average from v1) order by 1, 2;

--test: in where clause
select a, b, c from v1 ttt where c < (select max(c) from v1 where b=ttt.b) order by 1;
select a, b, c from v1 where c = (select min(c)/100 from v2 where b > v1.b) order by 1, 2;
select a, b, c from v1 where c >= (select rank() over(partition by v1.b order by v1.a) from v2) order by 1, 2; 
select * from v1 where b in (select max(b) from v2 where a=v1.a) order by 1, 2;
select * from v2 where a = any(select avg(v2.c/100) from v1 where b in (select max(b) from v2)) order by 1, 2;
select * from v1 where exists (select sum(v1.c) over(partition by b order by a) from t2 where c > 100) order by 1, 2;


drop view v1, v2;
drop table t1, t2;
