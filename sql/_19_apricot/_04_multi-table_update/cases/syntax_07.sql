--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (3), (4), (5), (6), (7);

update t1 left join t2 on t1.i=t2.i set t1.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

update t1 left join t2 on t1.i=t2.i set t2.i=t2.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

update t1 right join t2 on t1.i=t2.i set t1.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

update t1 right join t2 on t1.i=t2.i set t2.i=t2.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;