--TEST: multiple columns with default values


--TEST: error
create table c15(col1 timestamp default UNIX_TIMESTAMP(), col2 date default CURRENT_TIMESTAMP, col3 datetime default SYSTIMESTAMP);
create view v as select * from c15;
desc c15;
drop table if exists c15;
drop view v;


--TEST: 
create table c15(col1 timestamp default CURRENT_TIMESTAMP, col2 datetime default CURRENT_TIMESTAMP, col3 datetime default SYSTIMESTAMP);
create view v as select * from c15;
show columns in v;
drop table if exists c15;
drop view v;


--TEST:
create table c15(col1 date default SYSDATE, col2 datetime default SYSDATETIME, col3 string default USER, col4 char(20) default CURRENT_USER);
create view v as select * from c15;
desc c15;
drop table if exists c15;
drop view v;


--TEST:
create table c15(col1 timestamp not null default UNIX_TIMESTAMP(), col2 date primary key default CURRENT_TIMESTAMP, col3 datetime unique default SYSTIMESTAMP);
create view v as select * from c15;
show columns in v;
drop table if exists c15;
drop view v;


--TEST:
create table c15(col1 date primary key not null default SYSDATE, col2 datetime default SYSDATETIME unique, col3 string default USER unique not null, col4 char(20) unique default CURRENT_USER not null);
create view v as select * from c15;
desc c15;
drop table if exists c15;
drop view v;


--TEST: foreign key
create table poo(col1 timestamp primary key default CURRENT_TIMESTAMP, col2 timestamp default SYSDATE not null, col3 datetime default SYSDATETIME unique, col4 varchar not null default CURRENT_USER);
create table foo(col1 timestamp primary key default SYSTIMESTAMP, col2 string default USER, col3 int unique, col4 datetime default SYSDATETIME, index i(col3 asc, col2 desc), 
			constraint fk_col1 foreign key(col1) references poo(col1) on update restrict);
desc poo;
show index in foo;
--error
drop table poo;
drop table foo;
drop table if exists poo;


