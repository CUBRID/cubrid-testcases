
drop table if exists t1, t2;

create table t1(i int);
create table t2(i int);

insert into t1 values(1);
insert into t1 values(2);
insert into t1 values(3);

insert into t2 values(-1);
insert into t2 values(2);

--test: aggreage function in subquery of where clause
select * from t1 where exists (select sum(t1.i) from t2 where t2.i > 0) order by 1;


--test: aggreage function in subquery of update statement
update t1 set t1.i = (select sum(t1.i) from t2 where t1.i = t2.i);
select * from t1 order by 1;


--test: aggreage function in subquery of select statement
select (select sum(t1.i) from t2 order by 1 limit 1) from t1 order by 1;
select (select sum(t1.i) from t2) from t1 order by 1;


drop table t1;
drop table t2;
