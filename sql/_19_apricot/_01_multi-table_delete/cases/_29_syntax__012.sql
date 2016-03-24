--CLIENT
create class t_tr(i int, tbl varchar(255));

create class t1(i int);
create trigger tr1 before delete on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5), (6);

create class t2(i int);
create trigger tr2 before delete on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (2), (3), (4), (5), (6), (7);

create class t3(i int);
create trigger tr3 before delete on t3 execute insert into t_tr values(obj.i, 't3');
insert into t3 values (3), (4), (5), (6), (7), (8);

create class t4(i int);
create trigger tr4 before delete on t4 execute insert into t_tr values(obj.i, 't4');
insert into t4 values (4), (5), (6), (7), (8), (9);

create class t5(i int);
create trigger tr5 before delete on t5 execute insert into t_tr values(obj.i, 't5');
insert into t5 values (5), (6), (7), (8), (9), (10);

delete t2, t4 from t1, t2, t3, t4, t5 where t1.i=t2.i and t2.i=t3.i and t3.i=t4.i and t4.i=t5.i;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;
select * from t5 order by 1;
select * from t_tr order by 1, 2;

drop class t1;
drop class t2;
drop class t3;
drop class t4;
drop class t5;
drop class t_tr;