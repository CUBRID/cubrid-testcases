--SERVER
create table t1(i int);
insert into t1 values (1), (2), (3), (4), (5);
create table t11 under t1(j int);
insert into t11 select i + 10, i + 10 from t1;
create table t111 under t11(k int);
insert into t111 select i + 20, i + 20, i + 20 from t1;
create table t12 under t1(j int);
insert into t12 select i + 30, i + 30 from t1;
create table t121 under t12(k int);
insert into t121 select i + 40, i + 40, i + 40 from t1;
create table t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

update t2, all t1 (except t11), all t11 (except t111) set t2.i=-t2.i, t1.i=-t1.i, t11.i=-t11.i;
select * from t1 order by 1;
select * from t11 order by 1;
select * from t111 order by 1;
select * from t12 order by 1;
select * from t121 order by 1;
select * from t2 order by 1;

drop table t1;
drop table t11;
drop table t111;
drop table t12;
drop table t121;
drop table t2;