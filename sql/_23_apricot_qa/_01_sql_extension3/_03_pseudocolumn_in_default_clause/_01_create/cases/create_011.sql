--1 column with SYSDATE as default, combined with other constraints

--TEST: error, numeric types
create table create11(col int not null default SYSDATE );
drop table if exists create11;
create table create11(col short not null primary key default SYSDATE);
drop table if exists create11;
create table create11(col bigint unique default SYSDATE);
drop table if exists create11;


--TEST: date/time types
create table create11(col date default SYSDATE not null);
desc create11;
show columns in create11;
drop table if exists create11;

create table create11(col time default SYSDATE unique);
desc create11;
show columns in create11;
drop table if exists create11;

create table create11(col timestamp primary key default SYSDATE);
desc create11;
show columns in create11;
drop table if exists create11;

create table create11(col datetime default SYSDATE primary key unique not null);
desc create11;
show columns in create11;
drop table if exists create11;

create table poo(col timestamp primary key default SYSDATE);
desc poo;
show columns in poo;
create table foo(col timestamp primary key default SYSTIMESTAMP, 
			constraint fk_col foreign key(col) references poo(col) on delete cascade);
desc foo;
show index in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, bit strings
create table create11(col bit(20) default SYSDATE not null);
drop table if exists create11;


--TEST: error, character strings
create table create11(col char(20) primary key default SYSDATE);
drop table if exists create11;
create table create11(col nchar(20) unique not null default SYSDATE);
drop table if exists create11;


--TEST: error, blob/clob types
create table create11(col blob unique default SYSDATE);
drop table if exists create11;
create table create11(col clob not null default SYSDATE);
drop table if exists create11;


--TEST: error, collection types
create table create11(col sequence default SYSDATE unique);
drop table if exists create11;








