--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int) partition by range (i)(
											partition before_3 values less than (3),
											partition before_5 values less than (5),
											partition before_100 values less than (100));
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

create table t2(i int) partition by range (i)(
											partition before_3 values less than (3),
											partition before_5 values less than (5),
											partition before_100 values less than (100));
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (2), (3), (4), (5), (6), (7), (8), (9), (10), (11);

update t1 inner join t2 on t1.i=t2.i set t1.i=t1.i + 1, t2.i=t2.i - 1 where t1.i > 5;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

update t1 inner join t2 on t1.i=t2.i set t1.i=t1.i + 1, t2.i=t2.i - 1 where t1.i <= 5;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop table t_tr;