--1 column with USER as default, combined with other constraints

--TEST: error, numeric types
create table create13(col int not null default USER );
drop table if exists create13;
create table create13(col short not null primary key default USER);
drop table if exists create13;
create table create13(col bigint unique default USER);
drop table if exists create13;


--TEST: error, date/time types
create table create13(col date default USER not null);
drop table if exists create13;
create table create13(col time default USER unique);
drop table if exists create13;
create table create13(col timestamp primary key default USER);
drop table if exists create13;
create table create13(col datetime default USER primary key unique not null);
drop table if exists create13;
create table poo(col timestamp primary key default USER);


--TEST: error, bit strings
create table create13(col bit(20) default USER not null);
drop table if exists create13;


--TEST: character strings
create table create13(col char(20) default USER not null);
desc create13;
show columns in create13; 
drop table if exists create13;

create table create13(col char varying default USER unique);
desc create13;
show columns in create13; 
drop table if exists create13;

create table create13(col string primary key default USER);
desc create13;
show columns in create13; 
drop table if exists create13;

create table create13(col nchar(20) default USER primary key unique not null);
desc create13;
show columns in create13; 
drop table if exists create13;

create table poo(col nchar varying primary key default USER);
desc poo;
show columns in poo;
create table foo(col nchar varying primary key default USER,
                        constraint fk_col foreign key(col) references poo(col) on delete cascade);
desc foo;
show columns in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, blob/clob types
create table create13(col blob unique default USER);
drop table if exists create13;
create table create13(col clob not null default USER);
drop table if exists create13;


--TEST: error, collection types
create table create13(col set default USER unique);
drop table if exists create13;








