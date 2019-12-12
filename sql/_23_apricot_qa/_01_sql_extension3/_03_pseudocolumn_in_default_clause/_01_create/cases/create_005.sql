--1 column with default, unmatched types for SYSDATETIME

--TEST: error, numeric types
create table create05(col int default SYSDATETIME);
drop table if exists create05;
create table create05(col short default SYSDATETIME);
drop table if exists create05;
create table create05(col bigint default SYSDATETIME);
drop table if exists create05;
create table create05(col numeric(20, 15) default SYSDATETIME);
drop table if exists create05;
create table create05(col float default SYSDATETIME);
drop table if exists create05;
create table create05(col double default SYSDATETIME);
drop table if exists create05;
create table create05(col monetary default SYSDATETIME);
drop table if exists create05;


--TEST: error, date/time types
create table create05(col date default SYSDATETIME);
desc create05;
show columns in create05;
drop table if exists create05;

--TEST: error, time type
create table create05(col time default SYSDATETIME);
desc create05;
show columns in create05;
drop table if exists create05;

--TEST: error, timestamp type
create table create05(col timestamp default SYSDATETIME);
desc create05;
show columns in create05;
drop table if exists create05;

--TEST: datetime type
create table create05(col datetime default SYSDATETIME);
desc create05;
show columns in create05;
drop table if exists create05;


--TEST: error, bit strings
create table create05(col bit(20) default SYSDATETIME);
drop table if exists create05;
create table create05(col bit varying(20) default SYSDATETIME);
drop table if exists create05;


--TEST: error, character strings
create table create05(col char(20) default SYSDATETIME);
drop table if exists create05;
create table create05(col char varying(20) default SYSDATETIME);
drop table if exists create05;
create table create05(col string default SYSDATETIME);
drop table if exists create05;
create table create05(col nchar(20) default SYSDATETIME);
drop table if exists create05;
create table create05(col nchar varying(20) default SYSDATETIME);
drop table if exists create05;


--TEST: error, blob/clob types
create table create05(col blob default SYSDATETIME);
drop table if exists create05;
create table create05(col clob default SYSDATETIME);
drop table if exists create05;


--TEST: error, collection types
create table create05(col set default SYSDATETIME);
drop table if exists create05;
create table create05(col multiset default SYSDATETIME);
drop table if exists create05;
create table create05(col list default SYSDATETIME);
drop table if exists create05;








