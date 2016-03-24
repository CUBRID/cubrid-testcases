--CLIENT
create class t_tr(i int, tbl varchar(255));

create table t1(i int);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i, 't1');
insert into t1 values (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11);

create table t2(i int);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i, 't2');
insert into t2 values (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

create table t3(i int);
create trigger tr3 before update on t3 execute insert into t_tr values(obj.i, 't3');
insert into t3 values (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13);

create table t4(i int);
create trigger tr4 before update on t4 execute insert into t_tr values(obj.i, 't4');
insert into t4 values (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14);

create table t5(i int);
create trigger tr5 before update on t5 execute insert into t_tr values(obj.i, 't5');
insert into t5 values (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15);

create table t6(i int);
create trigger tr6 before update on t6 execute insert into t_tr values(obj.i, 't6');
insert into t6 values (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16);

create table t7(i int);
create trigger tr7 before update on t7 execute insert into t_tr values(obj.i, 't7');
insert into t7 values (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17);

create table t8(i int);
create trigger tr8 before update on t8 execute insert into t_tr values(obj.i, 't8');
insert into t8 values (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18);

create table t9(i int);
create trigger tr9 before update on t9 execute insert into t_tr values(obj.i, 't9');
insert into t9 values (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19);

create table t10(i int);
create trigger tr10 before update on t10 execute insert into t_tr values(obj.i, 't10');
insert into t10 values (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20);

create table t11(i int);
create trigger tr11 before update on t11 execute insert into t_tr values(obj.i, 't11');
insert into t11 values (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21);

update t1 inner join t2 on t1.i=t2.i
			  inner join t3 on t2.i=t3.i
			  inner join t4 on t3.i=t4.i
			  inner join t5 on t4.i=t5.i
			  inner join t6 on t5.i=t6.i
			  inner join t7 on t6.i=t7.i
			  inner join t8 on t7.i=t8.i
			  inner join t9 on t8.i=t9.i
			  inner join t10 on t9.i=t10.i
			  inner join t11 on t10.i=t11.i
			  set t1.i=-t1.i, t2.i=-t2.i, t3.i=-t3.i, t4.i=-t4.i, t5.i=-t5.i, t6.i=-t6.i, t7.i=-t7.i, t8.i=-t8.i, t9.i=-t9.i, t10.i=-t10.i, t11.i=-t11.i;
select  * from t1 order by 1;
select  * from t2 order by 1;
select  * from t3 order by 1;
select  * from t4 order by 1;
select  * from t5 order by 1;
select  * from t6 order by 1;
select  * from t7 order by 1;
select  * from t8 order by 1;
select  * from t9 order by 1;
select  * from t10 order by 1;
select  * from t11 order by 1;
select * from t_tr order by 1, 2;

drop table t1;
drop table t2;
drop table t3;
drop table t4;
drop table t5;
drop table t6;
drop table t7;
drop table t8;
drop table t9;
drop table t10;
drop table t11;
drop table t_tr;