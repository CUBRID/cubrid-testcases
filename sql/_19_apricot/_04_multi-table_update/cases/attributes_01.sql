--CLIENT
create table t1 class attribute (a int, b int) (i int);
insert into t1 values (1), (2), (3), (4), (5);

create table t2 class attribute (a int, b int) (i int);
insert into t2 values (1), (2), (3), (4), (5);

create table t3 class attribute (a int, b int) (i int);
insert into t3 values (1), (2), (3), (4), (5);

update class t1, class t2, class t3 set t1.a=1, t2.a=2, t3.a=3;
select * from class t1;
select * from class t2;
select * from class t3;

update class t1, class t2, class t3 set t2.b=t1.a,t3.b=t3.a, t1.b=t1.a;
select * from class t1;
select * from class t2;
select * from class t3;

update t1, t2, class t2 set t1.i=t1.i + class t2.a, t2.i=t2.i+class t2.b;
select * from class t1;
select * from t1 order by 1;
select * from class t2;
select * from t2 order by 1;

update t3, class t3 set t3.i=t3.i + 1, class t3.b=5;
select * from class t3;
select * from t3 order by 1;

update t3 set t3.i=t3.i + 1, class t3.b=5;
select * from class t3;
select * from t3 order by 1;

update t1, t3 set t1.i=t1.i + class t1.a + class t2.a + class t3.a, t3.i=t3.i+class t1.b + class t2.b + class t3.b;
select * from class t1;
select * from t1 order by 1;
select * from class t3;
select * from t3 order by 1;

drop table t1;
drop table t2;
drop table t3;