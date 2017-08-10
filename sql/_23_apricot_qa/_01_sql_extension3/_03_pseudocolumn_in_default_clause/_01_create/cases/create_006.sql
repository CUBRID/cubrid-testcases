--1 column with default, unmatched types for USER

--TEST: error, numeric types
create table create06(col int default USER);
drop table if exists create06;
create table create06(col short default USER);
drop table if exists create06;
create table create06(col bigint default USER);
drop table if exists create06;
create table create06(col numeric(20, 15) default USER);
drop table if exists create06;
create table create06(col float default USER);
drop table if exists create06;
create table create06(col double default USER);
drop table if exists create06;
create table create06(col monetary default USER);
drop table if exists create06;


--################################## BUG: CUBRIDSUS-6585 ########################################
--TEST: error, date/time types
create table create06(col date default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col time default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col timestamp default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col datetime default USER);
desc create06;
show columns in create06;
drop table if exists create06;


--TEST: error, bit strings
create table create06(col bit(20) default USER);
drop table if exists create06;
create table create06(col bit varying(20) default USER);
drop table if exists create06;


--TEST: error, character strings
--################################## BUG: CUBRIDSUS-6587 ########################################
create table create06(col char(20) default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col char varying(20) default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col string default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col nchar(20) default USER);
desc create06;
show columns in create06;
drop table if exists create06;

create table create06(col nchar varying(20) default USER);
desc create06;
show columns in create06;
drop table if exists create06;


--TEST: error, blob/clob types
create table create06(col blob default USER);
drop table if exists create06;
create table create06(col clob default USER);
drop table if exists create06;


--TEST: error, collection types
create table create06(col set default USER);
drop table if exists create06;
create table create06(col multiset default USER);
drop table if exists create06;
create table create06(col list default USER);
drop table if exists create06;








