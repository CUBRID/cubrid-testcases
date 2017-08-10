--1 column with default, unmatched types for CURRENT_TIMESTAMP

--TEST: error, numeric types
create table create01(col int default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col short default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col bigint default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col numeric(20, 15) default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col float default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col double default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col monetary default CURRENT_TIMESTAMP);
drop table if exists create01;


--TEST: date type
create table create01(col date default CURRENT_TIMESTAMP);
desc create01;
show columns in create01;
drop table if exists create01;

--TEST: time type
create table create01(col time default CURRENT_TIMESTAMP);
desc create01;
show columns in create01;
drop table if exists create01;

--TEST: timestamp type
create table create01(col timestamp default CURRENT_TIMESTAMP);
desc create01;
show columns in create01;
drop table if exists create01;

--TEST: datetime type
create table create01(col datetime default CURRENT_TIMESTAMP);
desc create01;
show columns in create01;
drop table if exists create01;


--TEST: error, bit strings
create table create01(col bit(20) default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col bit varying(20) default CURRENT_TIMESTAMP);
drop table if exists create01;


--TEST: error, character strings
create table create01(col char(20) default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col char varying(20) default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col string default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col nchar(20) default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col nchar varying(20) default CURRENT_TIMESTAMP);
drop table if exists create01;


--TEST: error, blob/clob types
create table create01(col blob default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col clob default CURRENT_TIMESTAMP);
drop table if exists create01;


--TEST: error, collection types
create table create01(col set default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col multiset default CURRENT_TIMESTAMP);
drop table if exists create01;
create table create01(col list default CURRENT_TIMESTAMP);
drop table if exists create01;








