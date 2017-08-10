--1 column with default, unmatched types for CURRENT_USER

--error, numeric types
create table create07(col int default CURRENT_USER);
drop table if exists create07;
create table create07(col short default CURRENT_USER);
drop table if exists create07;
create table create07(col bigint default CURRENT_USER);
drop table if exists create07;
create table create07(col numeric(20, 15) default CURRENT_USER);
drop table if exists create07;
create table create07(col float default CURRENT_USER);
drop table if exists create07;
create table create07(col double default CURRENT_USER);
drop table if exists create07;
create table create07(col monetary default CURRENT_USER);
drop table if exists create07;


--date/time types
create table create07(col date default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col time default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col timestamp default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col datetime default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;


--error, bit strings
create table create07(col bit(20) default CURRENT_USER);
drop table if exists create07;
create table create07(col bit varying(20) default CURRENT_USER);
drop table if exists create07;


--error, character strings
create table create07(col char(20) default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col char varying(20) default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col string default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col nchar(20) default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;

create table create07(col nchar varying(20) default CURRENT_USER);
desc create07;
show columns in create07;
drop table if exists create07;


--error, blob/clob types
create table create07(col blob default CURRENT_USER);
drop table if exists create07;
create table create07(col clob default CURRENT_USER);
drop table if exists create07;


--error, collection types
create table create07(col set default CURRENT_USER);
drop table if exists create07;
create table create07(col multiset default CURRENT_USER);
drop table if exists create07;
create table create07(col list default CURRENT_USER);
drop table if exists create07;








