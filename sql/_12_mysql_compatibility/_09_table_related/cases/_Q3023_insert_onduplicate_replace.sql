--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
replace into t1 values (1,1);
select * from t1 order by a asc;
drop table t1;

create table t1(a int primary key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
replace into t1 values (1,1);
select * from t1 order by a asc;
drop table t1;

create table t1(a int unique key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
replace into t1 values (1,1);
select * from t1 order by a asc;
drop table t1;

create table t1(a int unique key, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2);
insert into t2 values (1,11),(2,12);
replace into t1 select * from t2;
select * from t1 order by a asc;
drop table t1;
drop table t2;

create table t1(a int unique key, b int default 99);
insert into t1 values (1,1);
replace into t1(a) values (1);
select * from t1 order by a asc;
drop table t1;

create table t1(a int unique key, b int default 99);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
replace into t1 set a=1, b=default(b)+1;
select * from t1 order by a asc;
drop table t1;



set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
