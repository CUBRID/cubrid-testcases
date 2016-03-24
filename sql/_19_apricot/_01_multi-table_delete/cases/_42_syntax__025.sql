--SERVER
create table t1 (i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2 (i int);
insert into t2 values (2), (3), (4), (5), (6);

delete t1 from t2 as t1 inner join t1 as t2 on t1.i=t2.i where t1.i > 3;
select * from t1 order by 1;
select * from t2 order by 1;

delete t2 from t2 as t1 inner join t1 as t2 on t1.i=t2.i where t2.i < 4;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;