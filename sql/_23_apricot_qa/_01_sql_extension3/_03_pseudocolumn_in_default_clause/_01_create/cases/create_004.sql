--1 column with default, unmatched types for SYSDATE

--TEST: error, numeric types
create table create04(col int default SYSDATE);
drop table if exists create04;
create table create04(col short default SYSDATE);
drop table if exists create04;
create table create04(col bigint default SYSDATE);
drop table if exists create04;
create table create04(col numeric(20, 15) default SYSDATE);
drop table if exists create04;
create table create04(col float default SYSDATE);
drop table if exists create04;
create table create04(col double default SYSDATE);
drop table if exists create04;
create table create04(col monetary default SYSDATE);
drop table if exists create04;


--TEST: date type
create table create04(col date default SYSDATE);
desc create04;
show columns in create04;
drop table if exists create04;

--TEST: error, time type
create table create04(col time default SYSDATE);
desc create04;
show columns in create04;
drop table if exists create04;

--TEST: timestamp type
create table create04(col timestamp default SYSDATE);
desc create04;
show columns in create04;
drop table if exists create04;

--TEST: datetime type
create table create04(col datetime default SYSDATE);
desc create04;
show columns in create04;
drop table if exists create04;


--TEST: error, bit strings
create table create04(col bit(20) default SYSDATE);
drop table if exists create04;
create table create04(col bit varying(20) default SYSDATE);
drop table if exists create04;


--TEST: error, character strings
create table create04(col char(20) default SYSDATE);
drop table if exists create04;
create table create04(col char varying(20) default SYSDATE);
drop table if exists create04;
create table create04(col string default SYSDATE);
drop table if exists create04;
create table create04(col nchar(20) default SYSDATE);
drop table if exists create04;
create table create04(col nchar varying(20) default SYSDATE);
drop table if exists create04;


--TEST: error, blob/clob types
create table create04(col blob default SYSDATE);
drop table if exists create04;
create table create04(col clob default SYSDATE);
drop table if exists create04;


--TEST: error, collection types
create table create04(col set default SYSDATE);
drop table if exists create04;
create table create04(col multiset default SYSDATE);
drop table if exists create04;
create table create04(col list default SYSDATE);
drop table if exists create04;








