--CLIENT
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t4(i int);
insert into t4 values (1), (2), (3), (4), (5);

create table t2(i int);
create trigger tr_t2 before update on t2 execute update t4 set t4.i=-t4.i where t4.i=obj.i;
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int);
create trigger tr_t3 before update on t3 execute update t1, t2 set t2.i=t1.i + 10 * obj.i where t1.i=t2.i and t1.i=obj.i;
insert into t3 values (1), (2), (3), (4), (5);

update t3 , t4 set t3.i= t3.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;

update t1 left join t4 on t1.i=-t4.i - 1 set t1.i=t4.i, t4.i=t1.i;

drop table t3;
drop table t2;
drop table t4;
drop table t1;