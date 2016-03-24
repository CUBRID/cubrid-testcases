--CLIENT - SERVER
create class t_tr(i int, tbl varchar(255));

create table t1 (i int) partition by range (i) (partition part_3 values less than (3), partition part_5 values less than (5));
insert into t1 values (1), (2), (3), (4);

create table t2 (i int);
create trigger tr_t2 after update on t2 execute insert into t_tr values (obj.i, 't2');
insert into t2 values (1), (2), (3), (4), (5);

update t1, t2 set t1.i=t1.i - 1, t2.i = t2.i + 1 where t1.i=3;
update t1, t2 set t1.i=-t1.i;

create trigger tr_t1 after update on t1 execute insert into t_tr values (obj.i, 't1');
update t1, t2 set t1.i=t1.i + 1, t2.i = t2.i + 1 where t1.i=-2;

drop table t1;
drop table t2;
drop table t_tr;