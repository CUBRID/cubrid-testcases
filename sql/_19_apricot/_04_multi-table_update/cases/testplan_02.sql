--CLIENT
create table t1 (i int);
create trigger tr_t1 after update on t1 execute update t1 tt1, t1 tt2 set tt1.i=tt1.i+10, tt2.i=tt1.i + 100 where tt1.i=obj.i;
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
create trigger tr_t2 after update on t2 execute delete from t2 where i=obj.i;
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int);
create trigger tr_t3 after update on t3 execute update t1, t2 set t1.i=obj.i, t2.i=-obj.i;
insert into t3 values (1), (2), (3), (4), (5);

update t1 set i=5;
select * from t1 order by 1;

drop trigger tr_t1;
update t1 inner join t2 on t1.i=t2.i inner join t3 on t2.i=t3.i set t1.i=t1.i + 1, t2.i=t2.i + 1 where t1.i < 2;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop table t1;
drop table t2;
drop table t3;