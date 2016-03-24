--1 column with SYSDATETIME as default, combined with other constraints

--TEST: error, numeric types
create table create12(col int not null default SYSDATETIME );
drop table if exists create12;
create table create12(col short not null primary key default SYSDATETIME);
drop table if exists create12;
create table create12(col bigint unique default SYSDATETIME);
drop table if exists create12;


--date/time types
create table create12(col date default SYSDATETIME not null);
desc create12;
show columns in create12;
drop table if exists create12;

create table create12(col time default SYSDATETIME unique);
desc create12;
show columns in create12;
drop table if exists create12;

create table create12(col timestamp primary key default SYSDATETIME);
desc create12;
show columns in create12;
drop table if exists create12;

create table create12(col datetime default SYSDATETIME primary key unique not null);
desc create12;
show columns in create12;
drop table if exists create12;

create table poo(col datetime primary key default SYSDATETIME);
desc poo;
show columns in poo;
create table foo(col datetime default SYSDATETIME, 
			constraint fk_col foreign key(col) references poo(col) on delete cascade);
show columns in foo;
show index in foo;
drop table if exists foo;
drop table if exists poo;


--TEST: error, bit strings
create table create12(col bit(20) default SYSDATETIME not null);
drop table if exists create12;


--TEST: error, character strings
create table create12(col char(20) primary key default SYSDATETIME);
drop table if exists create12;
create table create12(col nchar(20) unique not null default SYSDATETIME);
drop table if exists create12;


--TEST: error, blob/clob types
create table create12(col blob unique default SYSDATETIME);
drop table if exists create12;
create table create12(col clob not null default SYSDATETIME);
drop table if exists create12;


--TEST: error, collection types
create table create12(col set default SYSDATETIME unique);
drop table if exists create12;








