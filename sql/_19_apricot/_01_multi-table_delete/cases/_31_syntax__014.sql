--CLIENT
create class t_tr(i int, tbl varchar(255));

create class t1(i int, str varchar(255));
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1, 'one');
insert into t1 values (2, 'two');
insert into t1 values (3, 'three');
insert into t1 values (4, 'four');
insert into t1 values (5, 'five');

create class t2(i int);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (1), (2), (3), (4), (5);

delete t1.*, t2.* from t1, t2 where t1.i=t2.i and t1.i=1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t1.*, t2.* from t1, t2 where t1.i=t2.i and t1.i=2;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t1, t2 from t1, t2 where t1.i=t2.i and t1.i=3;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t1.* from t1 where i=4;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

delete t2.* from t2 where i=4;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t_tr order by 1, 2;

drop class t1;
drop class t2;
drop class t_tr;