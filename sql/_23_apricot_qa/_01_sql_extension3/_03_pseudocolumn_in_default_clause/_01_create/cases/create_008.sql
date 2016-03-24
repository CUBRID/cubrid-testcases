--1 column with CURRENT_TIMESTAMP as default, combined with other constraints

--TEST: error, numeric types
create table create08(col int not null default CURRENT_TIMESTAMP );
drop table if exists create08;
create table create08(col short not null primary key default CURRENT_TIMESTAMP);
drop table if exists create08;
create table create08(col bigint unique default CURRENT_TIMESTAMP);
drop table if exists create08;


--TEST: date type
create table create08(col date default CURRENT_TIMESTAMP not null);
desc create08;
show columns in create08;
drop table if exists create08;

--TEST: time type
create table create08(col time default CURRENT_TIMESTAMP unique);
desc create08;
show columns in create08;
drop table if exists create08;

--TEST: timestamp type
create table create08(col timestamp primary key default CURRENT_TIMESTAMP);
desc create08;
show columns in create08;
drop table if exists create08;

--TEST: datetime type
create table create08(col datetime default CURRENT_TIMESTAMP primary key unique not null);
desc create08;
show columns in create08;
drop table if exists create08;

--TEST: timestamp type, foreign key
create table poo(col timestamp primary key default CURRENT_TIMESTAMP);
desc poo;
show columns in poo;
create table foo(col timestamp primary key default SYSTIMESTAMP, 
			constraint fk_col foreign key(col) references poo(col) on delete cascade);
desc foo;
show index in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, bit strings
create table create08(col bit(20) default CURRENT_TIMESTAMP not null);
drop table if exists create08;


--TEST: error, character strings
create table create08(col char(20) primary key default CURRENT_TIMESTAMP);
drop table if exists create08;
create table create08(col nchar(20) unique not null default CURRENT_TIMESTAMP);
drop table if exists create08;


--TEST: error, blob/clob types
create table create08(col blob unique default CURRENT_TIMESTAMP);
drop table if exists create08;
create table create08(col clob not null default CURRENT_TIMESTAMP);
drop table if exists create08;


--TEST: error, collection types
create table create08(col set default CURRENT_TIMESTAMP unique);
drop table if exists create08;








