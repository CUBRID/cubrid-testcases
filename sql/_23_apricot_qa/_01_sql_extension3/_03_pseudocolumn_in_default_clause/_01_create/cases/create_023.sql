--create table of multiple columns with default value using 'create table like...' syntax



create table c23(col1 timestamp default CURRENT_TIMESTAMP, col2 time default UNIX_TIMESTAMP(), col3 datetime default SYSTIMESTAMP);
create table clike like c23;
desc clike;
drop table if exists c23;
drop table clike;


create table c23(col1 date default SYSDATE, col2 datetime default SYSDATETIME, col3 string default USER, col4 char(20) default CURRENT_USER);
create table clike like c23;
show columns in clike;
drop table if exists c23;
drop table clike;


create table c23(col1 timestamp not null default CURRENT_TIMESTAMP, col2 time primary key default UNIX_TIMESTAMP(), col3 datetime unique default SYSTIMESTAMP);
create table clike like c23;
desc clike;
drop table clike;
drop table if exists c23;


create table c23(col1 date primary key not null default SYSDATE, col2 datetime default SYSDATETIME unique, col3 string default USER unique not null, col4 char(20) unique default CURRENT_USER not null);
create table clike like c23;
show columns in clike;
drop table if exists c23;
drop table clike;


create table poo(col1 time primary key default CURRENT_TIMESTAMP, col2 timestamp default SYSDATE not null, col3 date unique default SYSDATETIME, col4 char varying not null default CURRENT_USER);
create table foo(col1 time primary key default SYSDATETIME, col2 char(50) default USER, col3 int unique, col4 datetime default SYSDATETIME, index i(col3 asc, col2 desc), 
			constraint fk_col1 foreign key(col1) references poo(col1) on update restrict);

create table plike like poo;
show columns in plike;
show index in plike;

create table flike like foo;
desc flike;
show index in flike;

--error
drop table poo;
drop table foo;
drop table if exists poo;
drop table plike;
drop table flike;
drop table if exists poo;


