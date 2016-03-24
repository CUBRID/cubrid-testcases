drop table if exists t1;
drop table if exists t4;
create table t1(i int PRIMARY KEY);
insert into t1 values (1), (2), (3), (4), (5);
create table t4(i int PRIMARY KEY);
insert into t4 values (1), (2), (3), (4), (5);
update t1 left join t4 on t1.i=-t4.i-1 set t1.i=t4.i, t4.i=t1.i;
select * from t1 ;

drop table if exists t1;
drop table if exists t4;
