--
create table t1(i int not null);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int not null);
insert into t3 values (1), (2), (3), (4), (5);

update t1 inner join t2 on t1.i=t2.i inner join t3 on t2.i=t3.i set t2.i=null, t1.i=13, t3.i=13 where t1.i=3;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

update t1 inner join t2 on t1.i=t2.i inner join t3 on t2.i=t3.i set t2.i=14, t1.i=null, t3.i=14 where t1.i=4;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

update t1 inner join t2 on t1.i=t2.i inner join t3 on t2.i=t3.i set t2.i=15, t1.i=15, t3.i=null where t1.i=5;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop table t1;
drop table t2;
drop table t3;