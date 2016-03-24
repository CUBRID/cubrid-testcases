drop table if exists t1;
drop table if exists t2;
create table t1(a int unique key);
create table t2(a int, b int);
insert into t1 values (1),(2);
insert into t2 values (1,11),(2,12);
insert into t1 select a from t2 on duplicate key update t1.a=t2.b;
select * from t1 order by a asc;
drop t1,t2;