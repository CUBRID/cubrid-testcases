--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3);

create table t2(i int);
insert into t2 values (1), (2), (3);

update t1, t2 set t1.i=4, t2.i=5;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;