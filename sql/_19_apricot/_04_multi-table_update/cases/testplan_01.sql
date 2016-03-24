--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

update t1 inner join (select * from t1 where i >3) t on t1.i=t.i set t1.i=t1.i + 1;
select * from t1 order by 1;

update (select * from t1 where i >3) t inner join t1 on t1.i=t.i set t1.i=t1.i + 1;
select * from t1 order by 1;

update t1 as tt1 inner join t1 as tt2 on tt1.i=tt2.i - 3 set tt1.i=tt2.i * 10, tt2.i=-tt1.i;
select * from t1 order by 1;

drop table t1;