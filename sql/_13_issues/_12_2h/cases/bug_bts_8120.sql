drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int, unique index t1_a (a));
create table t2(a int, b int, index i (a));
insert into t1 values (2,2);
insert into t2 values (2,2);
create trigger tri_t1_after_update after update on t1 execute insert into t2 values (4,4);
update t1 join t2 on t1.a=t2.a set t1.a=3, t2.a=3;


drop table if exists t1;
drop table if exists t2;
