--SERVER
create table t1(i int) partition by range (i)(
											partition before_3 values less than (3),
											partition before_5 values less than (5),
											partition before_100 values less than (100));
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int) partition by range (i)(
											partition before_3 values less than (3),
											partition before_5 values less than (5),
											partition before_100 values less than (100));
insert into t2 values (2), (3), (4), (5), (6);

update t1, t2 set t1.i=t1.i + 1, t2.i=t2.i - 1;
select * from t1 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t2;