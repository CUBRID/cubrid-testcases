--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a int, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update b=-99;
select * from t1 order by a asc;
drop table t1;

create table t1(a int primary key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update b=-99;
select * from t1 order by a;
drop table t1;

create table t1(a int unique, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update b=-99;
select * from t1 order by a asc;
drop table t1;

create table t1(b int);
alter table t1 add column a int primary key first;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update b=-99;
select * from t1 order by a asc;
drop table t1;

create table t1(b int);
alter table t1 add column a int unique key first;
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update b=-99;
select * from t1 order by a asc;
drop table t1;

create table t1(a int primary key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update a=1,b=-99;
select * from t1 order by 1,2;
drop table t1;

create table t1(a int primary key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update a=2,b=-99;
select * from t1 order by 1,2;
drop table t1;

create table t1(a int unique key, b int);
insert into t1 values (1,1),(2,2),(3,3),(4,4);
insert into t1 values (1,1) ON DUPLICATE KEY update a=2,b=-99;
select * from t1 order by 1,2;
drop table t1;

create table t1(a varchar(10) unique key, b int);
insert into t1 values ('a',1);
insert into t1 values ('a ',1) ON DUPLICATE KEY update b=-99;
select * from t1 order by 1,2;
drop table t1;

create table t1(a varchar(10) unique key, b int, order_no int);
insert into t1 values ('a',1, 1);
insert into t1 values (' a',1, 2) ON DUPLICATE KEY update b=-99, order_no=2;
insert into t1 values ('a ',1, 3) ON DUPLICATE KEY update b=-99, order_no=3;
insert into t1 values ('a  ',1, 4) ON DUPLICATE KEY update b=-99, order_no=4;
select * from t1 order by order_no asc;
drop table t1;


create table t1(a int auto_increment unique key, b int);
insert into t1 values (null,1);
insert into t1 values (1,1) ON DUPLICATE KEY update b=(a+1)*1000/10;
select * from t1 order by 1,2;
drop table t1;

create table t1(a int unique key, b int);
create table t2(a int, b int);
insert into t2 values (1,1),(2,2),(3,3),(4,4),(5,5);
insert into t1 select * from t2;
update t2 set b=b+10;
insert into t1 select * from t2 on duplicate key update t1.a=t2.a+10, t1.b=t2.b;
select * from t1 order by a;
select * from t2 order by a;
drop table t1;
drop table t2;


create table t1(a int unique key);
create table t2(a int, b int);
insert into t1 values (1),(2);
insert into t2 values (1,11),(2,12);
insert into t1 select a from t2 on duplicate key update t1.a=t2.b;
select * from t1 order by a asc;
select * from t2 order by a asc;
drop table t1;
drop table t2;

set system parameters 'compat_mode=cubrid';
commit;
--+ holdcas off;
