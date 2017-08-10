--1 column with default, unmatched types for SYSTIMESTAMP

--TEST: error, numeric types
create table create03(col int default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col short default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col bigint default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col numeric(20, 15) default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col float default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col double default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col monetary default SYSTIMESTAMP);
drop table if exists create03;


--TEST: error, date type
create table create03(col date default SYSTIMESTAMP);
desc create03;
show columns in create03;
drop table if exists create03;

--TEST: error, time type
create table create03(col time default SYSTIMESTAMP);
desc create03;
show columns in create03;
drop table if exists create03;

--TEST: timestamp type
create table create03(col timestamp default SYSTIMESTAMP);
desc create03;
show columns in create03;
drop table if exists create03;

--TEST: datetime type
create table create03(col datetime default SYSTIMESTAMP);
desc create03;
show columns in create03;
drop table if exists create03;


--TEST: error, bit strings
create table create03(col bit(20) default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col bit varying(20) default SYSTIMESTAMP);
drop table if exists create03;


--TEST: error, character strings
create table create03(col char(20) default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col char varying(20) default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col string default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col nchar(20) default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col nchar varying(20) default SYSTIMESTAMP);
drop table if exists create03;


--TEST: error, blob/clob types
create table create03(col blob default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col clob default SYSTIMESTAMP);
drop table if exists create03;


--TEST: error, collection types
create table create03(col set default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col multiset default SYSTIMESTAMP);
drop table if exists create03;
create table create03(col list default SYSTIMESTAMP);
drop table if exists create03;








