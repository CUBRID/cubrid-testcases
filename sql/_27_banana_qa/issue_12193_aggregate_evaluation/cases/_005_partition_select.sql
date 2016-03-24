--test aggregate functions in subqueries of select statement with hash partition table

drop table if exists t1, t2;

create table t1(a int, b varchar(10), c int) partition by hash(a) partitions 10;
create table t2(a int, b varchar(10), c int) partition by hash(b) partitions 5;

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

--test: as select expression
select a, b, (select avg(c) from t1 where a=ttt.a) as average from t1 ttt order by 1, 2;  
select a, b, (select sum(c) from t2 where a=t1.a) as average from t1 order by 1, 2;  
select (select count(t1.c) from t2 where b < 'f') as average from t1 order by 1;  
select a, b, (select count(t1.c) from t2 where b < 'f') as average from t1 order by 1, 2;  

--test: as table specification
select a, b, average from (select a, b, (select avg(c) from t1 where a=ttt.a) as average from t1 ttt) order by 1, 2;
select a, b, average from (select a, b, (select sum(c) from t2 where a=t1.a) as average from t1) where a < 8 order by 1, 2;
select a, b, average from (select a, b, (select count(t1.c) from t2 where b < 'f') as average from t1) order by 1, 2;

--test: in where clause
select a, b, c from t1 ttt where c < (select max(c) from t1 where b=ttt.b) order by 1;
select a, b, c from t1 where c = (select min(c)/100 from t2 where b > t1.b) order by 1, 2;
select a, b, c from t1 where c >= (select rank() over(partition by t1.b order by t1.a) from t2) order by 1, 2; 
select * from t1 where b in (select max(b) from t2 where a=t1.a) order by 1, 2;
select * from t2 where a = any(select avg(t2.c/100) from t1 where b in (select max(b) from t2)) order by 1, 2;
select * from t1 where exists (select sum(t1.c) over(partition by b order by a) from t2 where c > 100) order by 1, 2;


drop table t1;
drop table t2;

