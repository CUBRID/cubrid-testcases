--SERVER
create class t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create class t2(i int);
insert into t2 values (3), (4), (5), (6), (7);

delete t1 from t1 right join t2 on t1.i=t2.i;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;