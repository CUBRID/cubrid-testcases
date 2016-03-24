--1 column with UNIX_TIMESTAMP() as default, combined with other constraints

--TEST: error, numeric types
create table create09(col int not null default UNIX_TIMESTAMP() );
drop table if exists create09;
create table create09(col short not null primary key default UNIX_TIMESTAMP());
drop table if exists create09;
create table create09(col bigint unique default UNIX_TIMESTAMP());
drop table if exists create09;


--TEST: error, date type
create table create09(col date default UNIX_TIMESTAMP() not null);
desc create09;
show columns in create09;
drop table if exists create09;

--TEST: error, time type
create table create09(col time default UNIX_TIMESTAMP() unique);
desc create09;
show columns in create09;
drop table if exists create09;

--TEST: timestamp type
create table create09(col timestamp primary key default UNIX_TIMESTAMP());
desc create09;
show columns in create09;
drop table if exists create09;

--TEST: datetime type
create table create09(col datetime default UNIX_TIMESTAMP() primary key unique not null);
desc create09;
show columns in create09;
drop table if exists create09;

--TEST: timestamp, foreign key
create table poo(col timestamp primary key default UNIX_TIMESTAMP());
desc poo;
show columns in poo;
create table foo(col timestamp primary key default SYSTIMESTAMP, 
			constraint fk_col foreign key(col) references poo(col) on delete cascade);
show columns in foo;
show index in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, bit strings
create table create09(col bit(20) default UNIX_TIMESTAMP() not null);
drop table if exists create09;


--TEST: error, character strings
create table create09(col char(20) primary key default UNIX_TIMESTAMP());
drop table if exists create09;
create table create09(col nchar(20) unique not null default UNIX_TIMESTAMP());
drop table if exists create09;


--TEST: error, blob/clob types
create table create09(col blob unique default UNIX_TIMESTAMP());
drop table if exists create09;
create table create09(col clob not null default UNIX_TIMESTAMP());
drop table if exists create09;


--TEST: error, collection types
create table create09(col set default UNIX_TIMESTAMP() unique);
drop table if exists create09;








