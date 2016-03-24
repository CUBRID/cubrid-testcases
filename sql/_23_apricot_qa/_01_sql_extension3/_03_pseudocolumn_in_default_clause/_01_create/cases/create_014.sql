--1 column with CURRENT_USER as default, combined with other constraints

--TEST: error, numeric types
create table create14(col int not null default CURRENT_USER );
drop table if exists create14;
create table create14(col short not null primary key default CURRENT_USER);
drop table if exists create14;
create table create14(col bigint unique default CURRENT_USER);
drop table if exists create14;


--TEST: error, date/time types
create table create14(col date default CURRENT_USER not null);
drop table if exists create14;
create table create14(col time default CURRENT_USER unique);
drop table if exists create14;
create table create14(col timestamp primary key default CURRENT_USER);
drop table if exists create14;
create table create14(col datetime default CURRENT_USER primary key unique not null);
drop table if exists create14;
create table poo(col timestamp primary key default CURRENT_USER);


--TEST: error, bit strings
create table create14(col bit(20) default CURRENT_USER not null);
drop table if exists create14;


--TEST: character strings
create table create14(col char(20) default CURRENT_USER not null);
desc create14;
show columns in create14; 
drop table if exists create14;

create table create14(col char varying default CURRENT_USER unique);
desc create14;
show columns in create14; 
drop table if exists create14;

create table create14(col string primary key default CURRENT_USER);
desc create14;
show columns in create14; 
drop table if exists create14;

create table create14(col nchar(20) default CURRENT_USER primary key unique not null);
desc create14;
show columns in create14; 
drop table if exists create14;

create table poo(col nchar varying primary key default CURRENT_USER);
desc poo;
show columns in poo;
create table foo(col nchar varying primary key default CURRENT_USER,
                        constraint fk_col foreign key(col) references poo(col) on delete cascade);
desc foo;
show columns in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, blob/clob types
create table create14(col blob unique default CURRENT_USER);
drop table if exists create14;
create table create14(col clob not null default CURRENT_USER);
drop table if exists create14;


--TEST: error, collection types
create table create14(col set default CURRENT_USER unique);
drop table if exists create14;








