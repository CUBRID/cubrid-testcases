--test aggregate functions in subqueries of delete statement

autocommit off;

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

commit;

--test: as table specification
delete from (select a, b, (select avg(c) from t1 where a=ttt.a) as average from t1 ttt);
select * from t1 order by 1, 2;
rollback;

delete from (select a, b, (select sum(c) from t2 where a=t1.a) as average from t1) where a < 8;
select * from t1 order by 1, 2;
rollback;

delete from (select a, b, (select count(t1.c) from t2 where b < 'f') as average from t1);
select * from t1 order by 1, 2;
rollback;

--test: in where clause
delete from t1 ttt where c > (select min(c) from t1 where b=ttt.b);
select * from t1 order by 1, 2;
rollback;

delete from t1 where c = (select min(c)/100 from t2 where b > t1.b);
select * from t1 order by 1, 2;
rollback;

delete from t1 where c <= (select rank() over(partition by t1.b order by t1.a) from t2); 
select * from t1 order by 1, 2;
rollback;

delete from t1 where b in (select max(b) from t2 where a=t1.a);
select * from t1 order by 1, 2;
rollback;

delete from t2 where a = some(select avg(t2.c/100) from t1 where b in (select max(b) from t2));
select * from t2 order by 1, 2;
rollback;

delete from t1 where exists (select sum(t1.c) over(partition by b order by a) from t2 where c > 100);
select * from t1 order by 1, 2;
rollback;


drop table t1;
drop table t2;


commit;
autocommit on;
