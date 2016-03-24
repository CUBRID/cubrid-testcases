--
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int);
insert into t3 values (1), (2), (3), (4), (5);

update t1 left join t3 on t1.i=t3.i+1 inner join t2 on t2.i=t1.i set t3.i=t2.i * 10, t1.i=t2.i - 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop table t1;
drop table t2;
drop table t3;