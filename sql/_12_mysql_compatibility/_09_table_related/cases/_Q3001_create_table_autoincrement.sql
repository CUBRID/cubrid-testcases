--+ holdcas on;
set system parameters 'compat_mode=mysql';

create table t1(a CHAR(10) AUTO_INCREMENT);
create table t2(a VARCHAR(10) AUTO_INCREMENT);
create table t3(a NCHAR(10) AUTO_INCREMENT);
create table t4(a NCHAR VARYING(10) AUTO_INCREMENT);
create table t5(a BIT(10) AUTO_INCREMENT);
create table t7(a BIT VARYING(10) AUTO_INCREMENT);
create table t12(a MONETARY AUTO_INCREMENT);
create table t13(a FLOAT AUTO_INCREMENT);
create table t14(a REAL AUTO_INCREMENT);
create table t15(a DOUBLE PRECISION AUTO_INCREMENT);
create table t16(a TIME AUTO_INCREMENT);
create table t17(a TIMESTAMP AUTO_INCREMENT);
create table t18(a NUMERIC ,b DECIMAL, c INTEGER, d TIMESTAMP AUTO_INCREMENT);
create table t19(a NUMERIC ,b DECIMAL, c INTEGER, d FLOAT AUTO_INCREMENT);
create table t20(a NUMERIC ,b DECIMAL, c INTEGER, d CHAR(1) AUTO_INCREMENT);
create table t21(a NUMERIC ,b DECIMAL, c CHAR(1) AUTO_INCREMENT, d INTEGER);

create table t8(a NUMERIC AUTO_INCREMENT);
drop table t8;
create table t9(a DECIMAL AUTO_INCREMENT);
drop table t9;
create table t10(a INTEGER AUTO_INCREMENT);
drop table t10;
create table t11(a SMALLINT AUTO_INCREMENT);
drop table t11;

create table t30(a NUMERIC AUTO_INCREMENT,b DECIMAL AUTO_INCREMENT, c INTEGER AUTO_INCREMENT, d SMALLINT AUTO_INCREMENT);
drop table t30;
create table t31(a NUMERIC ,b DECIMAL AUTO_INCREMENT, c INTEGER AUTO_INCREMENT, d SMALLINT AUTO_INCREMENT);
drop table t31;
create table t32(a NUMERIC ,b DECIMAL, c INTEGER AUTO_INCREMENT, d SMALLINT AUTO_INCREMENT);
drop table t32;
create table t33(a NUMERIC ,b DECIMAL, c INTEGER, d SMALLINT AUTO_INCREMENT);
drop table t33;
create table t36(a NUMERIC ,b DECIMAL AUTO_INCREMENT, c INTEGER, d SMALLINT);
drop table t36;
create table t37(a SMALLINT AUTO_INCREMENT,b SMALLINT AUTO_INCREMENT, c SMALLINT AUTO_INCREMENT, d SMALLINT AUTO_INCREMENT);
drop table t37;
create table t38(a VARCHAR(1),b CHAR(1), c NCHAR(1), d NCHAR VARYING, e BIT(1), f BIT VARYING(1), g NUMERIC AUTO_INCREMENT, h DECIMAL AUTO_INCREMENT, i INTEGER AUTO_INCREMENT,j SMALLINT AUTO_INCREMENT,k MONETARY,l FLOAT,m REAL,n DOUBLE PRECISION,o DATE,p TIME,q TIMESTAMP);
drop table t38;

create table s1(a INT AUTO_INCREMENT);
insert into s1 values ();
insert into s1 values (NULL);
insert into s1 values (3);
insert into s1 values (3);
insert into s1 values (4);
insert into s1 values (NULL);
insert into s1 values ();
insert into s1 values (), (null), (NULL),(), (Null), (1), (10), ();
select * from s1 order by 1;
drop table s1;

create table s2(a INT auto_increment, b SMALLINT);
insert into s2 values ();
update s2 set b=1 where a=1;
insert into s2 values (),(null, 3),(NULL, 4),(NUll, 5),(4, 6),(NULL, 7);
update s2 set b=2 where a=2;
insert into s2 values(, 8);
select * from s2 order by b asc;
drop table s2;

CREATE TABLE t1 (id int AUTO_INCREMENT primary key) AUTO_INCREMENT = 10;
drop table t1;


set system parameters 'compat_mode=cubrid';commit;
--+ holdcas off;
