--CLIENT
create class t_tr(i int);

create class t(i int);
create trigger tr before delete on t execute insert into t_tr values(obj.i);
insert into t values (1), (2), (3), (4), (5);

create class t1 under t (j int);
insert into t1 values (4, 4), (5,5), (6, 6), (7, 7), (8, 8);

create class t11 under t1 (k int);
insert into t11 values (4, 4, 4), (5, 5, 5), (6, 6, 6), (10, 10, 10), (11, 11, 11);

create class t2 under t (l int);
insert into t2 values (-4, -4), (-5,-5), (-6, -6), (-7, -7), (-8, -8);

create class t21 under t2 (m int);
insert into t21 values (-4, -4, -4), (-5, -5, -5), (-6, -6, -6), (-10, -10, -10), (-11, -11, -11);

update all t set t.i=t.i + 1;
select * from t order by 1;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t11 order by 1;
select * from t21 order by 1;
select * from t_tr order by 1;

drop table t11;
drop table t21;
drop table t1;
drop table t2;
drop table t;
drop table t_tr;