--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3);

create table t2(i int);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (1), (2), (3);

update t1, t2 set t1.i=4, t2.i=5;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop table t_tr;