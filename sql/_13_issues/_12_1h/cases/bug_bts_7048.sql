--TEST: [Multi-table Update] Result is incorrect when updating 2 tables with right outer join.


create table t1(a int);
insert into t1 values(1);

create table t2(b int);
insert into t2 values(1), (2);

select * from t1 right outer join t2 on t1.a=t2.b order by 1, 2;
update t1 right outer join t2 on t1.a=t2.b set t1.a=t2.b*5, t2.b=t1.a+2;

select * from t1 order by 1;
select * from t2 order by 1;


update t1 right outer join t2 on t1.a=t2.b set t1.a=t2.b*5, t2.b=t1.a+2;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1, t2;

