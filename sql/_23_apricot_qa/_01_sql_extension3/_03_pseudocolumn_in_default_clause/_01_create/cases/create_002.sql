--1 column with default, unmatched types for UNIX_TIMESTAMP()

--TEST: error, numeric types
create table create02(col int default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col short default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col bigint default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col numeric(10, 0) default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col float default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col double default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col monetary default UNIX_TIMESTAMP());
drop table if exists create02;


--TEST: date/time types
create table create02(col date default UNIX_TIMESTAMP());
desc create02;
show columns in create02;
drop table if exists create02;

create table create02(col time default UNIX_TIMESTAMP());
desc create02;
show columns in create02;
drop table if exists create02;

create table create02(col timestamp default UNIX_TIMESTAMP());
desc create02;
show columns in create02;
drop table if exists create02;

create table create02(col datetime default UNIX_TIMESTAMP());
desc create02;
show columns in create02;
drop table if exists create02;


--TEST: error, bit strings
create table create02(col bit(20) default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col bit varying(20) default UNIX_TIMESTAMP());
drop table if exists create02;


--TEST: error, character strings
create table create02(col char(20) default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col char varying(20) default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col string default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col nchar(20) default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col nchar varying(20) default UNIX_TIMESTAMP());
drop table if exists create02;


--TEST: error, blob/clob types
create table create02(col blob default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col clob default UNIX_TIMESTAMP());
drop table if exists create02;


--TEST: error, collection types
create table create02(col set default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col multiset default UNIX_TIMESTAMP());
drop table if exists create02;
create table create02(col list default UNIX_TIMESTAMP());
drop table if exists create02;








