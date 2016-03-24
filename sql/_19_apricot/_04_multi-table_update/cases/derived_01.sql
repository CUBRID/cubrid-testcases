--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2 (i int);
insert into t2 values (1), (2), (3), (4), (5);

update t1 inner join (select * from t2) t on t1.i=t.i set t1.i=t.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

update t1inner join (select * from t2) t on t1.i=t.i set t.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

update t1, (select * from t2 where t2.i >2) t set t.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;