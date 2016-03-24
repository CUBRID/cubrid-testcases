--1 column with SYSTIMESTAMP as default, combined with other constraints

--TEST: error, numeric types
create table create10(col int not null default SYSTIMESTAMP );
drop table if exists create10;
create table create10(col short not null primary key default SYSTIMESTAMP);
drop table if exists create10;
create table create10(col bigint unique default SYSTIMESTAMP);
drop table if exists create10;


--TEST: error, date type
create table create10(col date default SYSTIMESTAMP not null);
desc create10;
show columns in create10;
drop table if exists create10;

--TEST: error, time type
create table create10(col time default SYSTIMESTAMP unique);
desc create10;
show columns in create10;
drop table if exists create10;

--TEST: timestamp type
create table create10(col timestamp primary key default SYSTIMESTAMP);
desc create10;
show columns in create10;
drop table if exists create10;

--TEST: timestamp type
create table create10(col datetime default SYSTIMESTAMP primary key unique not null);
desc create10;
show columns in create10;
drop table if exists create10;

--TEST: timestamp + foreign key
create table poo(col timestamp primary key default SYSTIMESTAMP);
desc poo;
show columns in poo;
create table foo(col timestamp primary key default SYSTIMESTAMP, 
			constraint fk_col foreign key(col) references poo(col) on delete cascade);
desc foo;
show index in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, bit strings
create table create10(col bit(20) default SYSTIMESTAMP not null);
drop table if exists create10;


--TEST: error, character strings
create table create10(col char(20) primary key default SYSTIMESTAMP);
drop table if exists create10;
create table create10(col nchar(20) unique not null default SYSTIMESTAMP);
drop table if exists create10;


--TEST: error, blob/clob types
create table create10(col blob unique default SYSTIMESTAMP);
drop table if exists create10;
create table create10(col clob not null default SYSTIMESTAMP);
drop table if exists create10;


--TEST: error, collection types
create table create10(col multiset default SYSTIMESTAMP unique);
drop table if exists create10;








