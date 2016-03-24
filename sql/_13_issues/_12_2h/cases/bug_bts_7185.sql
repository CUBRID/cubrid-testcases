--TEST: [Multi-table Update] Number of affected rows is incorrect when updating 2 tables at the same time.

autocommit off;
drop table if exists t1, t2, t3;

create table t1(a int);
insert into t1 values(1), (1), (1), (1);

create table t2(b int);
insert into t2 values(1), (1), (1), (1);

create table t3(c int);
insert into t3 values(1), (1), (1), (1);

commit;

update t1 m1, t2 m2 set m1.a=100, m2.b=100 where m1.a=m2.b;
select * from t1 order by 1;
select * from t2 order by 1;

rollback;


update t1 m1, t2 m2, t3 m3 set m1.a=100, m2.b=100, m3.c=100 where m1.a=m2.b and m1.a=m3.c;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

rollback;

update t1 m1, t2 m2, t3 m3, t1 m4, t2 m5 set m1.a=100, m2.b=100, m3.c=100, m4.a=999, m5.b=111 where m1.a=m2.b and m3.c=m4.a;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

rollback;

drop table t1, t2, t3;


create table t1(a int, b varchar);
insert into t1 values(1, 't1'), (2, 't1'), (2, 't1'), (3, 't1');

create table t2(a int, b varchar);
insert into t2 values(1, 't2'), (2, 't2'), (3, 't2'), (3, 't2'), (4, 't2');

update t1 m1, t2 m2 set m1.b=m2.b, m2.b=m1.b where m1.a=m2.a;
select * from t1 order by 1, 2;
select * from t2 order by 1, 2;

drop table t1, t2;

commit;

autocommit on;


