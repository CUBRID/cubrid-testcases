--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

prepare x from 'update t1 inner join t2 on t1.i=t2.i set t1.i=?, t2.i=?';
execute x using 1, 2;
select * from t1 order by 1;
select * from t2 order by 1;
deallocate prepare x;

drop table t1;
drop table t2;