create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1);
insert into t2 values (1,1), (2,2);
create trigger tri_t2_before_update before update on t2 execute update t1 join t2 on t1.a=t2.a set t1.a=999 where t1.a=2;
update t1 join t2 on t1.a=t2.a set t2.a=3, t1.a=2 where t1.a=1;
select * from t1;
select * from t1;
drop t1,t2;