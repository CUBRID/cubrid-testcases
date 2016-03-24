--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2 (i int);
insert into t2 values (1), (2), (3), (4), (5);

update t1 set t1.i=t1.i + 1 order by t1.i;
select * from t1 order by 1;
select * from t2 order by 1;

update t1, t2 set t2.i=t1.i + 1, t1.i=t2.i + 1 order by t1.i;
select * from t1 order by 1;
select * from t2 order by 1;

update t2 set t2.i=t2.i + 1 order by t2.i limit 5;
select * from t1 order by 1;
select * from t2 order by 1;

update t1, t2 set t2.i=t1.i + 1, t1.i=t2.i + 1 limit 5;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;