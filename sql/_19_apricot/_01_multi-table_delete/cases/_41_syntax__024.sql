--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1 (i int);
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5), (6);

create table t2 (i int);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (2), (3), (4), (5), (6), (7);

delete t1 from (select * from t2 as t1 where t1.i < 6) a inner join t1 on t1.i = a.i where t1.i > 2 ;
select  * from t1 order by 1;
select  * from t2 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop class t_tr;