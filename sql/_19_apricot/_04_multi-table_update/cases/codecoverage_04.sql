--CLIENT
create table t1 (i int) partition by range (i) (partition part_3 values less than (3), partition part_5 values less than (5));
insert into t1 values (1), (2), (3), (4);

create table t3 (i int);
insert into t3 values (1), (2), (3), (4);

create table t2 (i int);
create trigger tr_t2 before update on t2 execute update t1, t3 set t1.i= -t3.i where t1.i=t3.i and t1.i=obj.i;
insert into t2 values (2), (3), (4), (5);

update t2 inner join t1 on t1.i=t2.i set t2.i=t1.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;

create table t4 (i int) partition by range (i) (partition t4_part_3 values less than (3), partition t4_part_5 values less than (5));
insert into t4 values (1), (2), (3), (4);

create unique index idx on t4(i);
update t4, t2 set t4.i=t4.i - 100;
select * from t1 order by 1;
select * from t2 order by 1;

create table t5 (i int) partition by range (i) (partition t5_part_3 values less than (3), partition t5_part_5 values less than (5));
insert into t5 values (1), (2), (3), (4);

create unique index idx on t5(i);
update t5, t2 set t5.i=t5.i + 100;
select * from t1 order by 1;
select * from t2 order by 1;

alter t1 remove partitioning;

drop table t2;
drop table t1;
drop table t3;
drop table t4;
drop table t5;