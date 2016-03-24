--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5);

create table t2(i int);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (1), (2), (3), (4), (5);

create table t3(i int);
create trigger tr3 before update on t3 execute insert into t_tr values(obj.i, 't3');
insert into t3 values (1), (2), (3), (4), (5);

update t3 inner join (t1, t2) t on t3.i=t.i set t.i=t.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t_tr order by 1, 2;

update t1 inner join t2 on t1.i=t2.i set (t2.i, t1.i)=(select t1.i + t3.i + 1.i, t2.i + t3.i from t3 where t3.i=t1.i - 1);
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t_tr order by 1, 2;

update (t1, t2) t set t.i=t.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t_tr order by 1, 2;

update (t1, t2, t3) set i=i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t_tr order by 1, 2;

update t1 right join (t1, t2, t3) t on t1.i=t.i set t.i=t.i + 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop table t3;
drop table t_tr;