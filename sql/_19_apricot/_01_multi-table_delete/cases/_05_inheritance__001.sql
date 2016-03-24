--SERVER
create class t(i int);
insert into t values (1), (2), (3), (4), (5);

create class t1 under t (j int);
insert into t1 values (4, 4), (5,5), (6, 6), (7, 7), (8, 8);

create class t11 under t1 (k int);
insert into t11 values (4, 4, 4), (5, 5, 5), (6, 6, 6), (10, 10, 10), (11, 11, 11);

create class t2 under t (l int);
insert into t2 values (-4, -4), (-5,-5), (-6, -6), (-7, -7), (-8, -8);

create class t21 under t2 (m int);
insert into t21 values (-4, -4, -4), (-5, -5, -5), (-6, -6, -6), (-10, -10, -10), (-11, -11, -11);

delete t1, t2 from all t1, all t2 where abs(t1.j)=5 and abs(t2.l)=5;
select * from all t order by 1;
delete t1, t2 from only t1, all t2 where abs(t1.j)=4 and abs(t2.l)=4;
select * from all t order by 1;
delete t1, t2 from all t1, only t2 where abs(t1.j)=6 and abs(t2.l)=6;
select * from all t order by 1;
delete t from all t;
select * from all t order by 1;

drop class t11;
drop class t21;
drop class t1;
drop class t2;
drop class t;