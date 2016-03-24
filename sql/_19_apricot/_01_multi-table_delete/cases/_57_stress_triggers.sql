create table t(i int);
insert into t values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10);

create table t6(i int);
insert into t6 select * from t;

create table t7(i int);
insert into t7 select * from t;

create table t8(i int);
insert into t8 select * from t;
create trigger tr8 before delete on t if (obj.i > 4) execute delete t6, t7 from t6, t7 where t6.i=obj.i and t7.i=obj.i;

create table t5(i int);
insert into t5 select * from t;
create trigger tr5 before update on t5 execute delete t6, t7, t8 from t6 inner join t7 on t6.i=t7.i inner join t8 on t7.i=t8.i where t6.i=obj.i and t6.i < 7;

create table t4(i int);
insert into t4 select * from t;
create trigger tr4 after update on t4 execute delete from t5 where i=obj.i;

create table t3(i int);
insert into t3 select * from t;
create trigger tr3 after insert on t3 execute update t4 set i=i + 1 where i=obj.i;

create table t2(i int);
insert into t2 select * from t;
create trigger tr2 before delete on t2 execute insert into t3 values(obj.i);

create table t1(i int);
insert into t1 select * from t;
create trigger tr1 after delete on t1 execute delete t2 from t2 inner join t3 on t2.i=t3.i where t2.i mod 5 != 0;

create table t9(i int);
insert into t9 select * from t;
create trigger tr9 before delete on t execute delete from t1 where i=obj.i + 2;

delete t9, t from t9 inner join t on t9.i=t.i;

select count(*) from t9;
select count(*) from t1;
select count(*) from t2;
select count(*) from t3;
select count(*) from t4;
select count(*) from t5;
select count(*) from t6;
select count(*) from t7;
select count(*) from t8;

drop table t9;
drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
drop table t8;
drop table t6;
drop table t7;
drop table t;
