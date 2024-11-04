drop table if exists t1;
create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(1,2,1);
insert into t1 values(2,3,2);
insert into t1 values(2,4,3);
insert into t1 values(10,50,4);
insert into t1 values(20,60,5);


create table t2 (i1 int,d1 double,f1 float);
insert into t2 values(1,2,1);
insert into t2 values(2,3,2);
insert into t2 values(2,4,3);
insert into t2 values(10,50,4);
insert into t2 values(20,60,5);

select t1.i1, t2.i1 from t1,t2 where  t1.i1 = t2.d1 - 1.0 order by 1,2;

prepare st from 'select t1.i1, t2.i1 from t1,t2 where  t1.i1 = t2.d1 - ? order by 1,2';
execute st using 1.0;
deallocate prepare st;


select t1.i1, t2.i1 from t1 left join t2 on t1.i1 = t2.d1 - 1.0 order by 1,2;

prepare st from 'select t1.i1, t2.i1 from t1 left join t2 on t1.i1 = t2.d1 - ? order by 1,2';
execute st using 1.0;
deallocate prepare st;


select t1.i1, t2.d1 from t1 join t2 on t1.i1 * '10' < t2.d1 - 30.0 order by 1,2;

prepare st from 'select t1.i1, t2.d1 from t1 join t2 on t1.i1 * ? < t2.d1 - ? order by 1,2';
execute st using '10', 30.0;
deallocate prepare st;

drop t1;
drop t2;
