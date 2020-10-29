--create table of multiple columns with default value using 'create table as select' syntax

--+ holdcas on;
create table c27(col1 timestamp default CURRENT_TIMESTAMP, col2 timestamp default UNIX_TIMESTAMP(), col3 datetime default SYSTIMESTAMP);
insert into c27 values default;
insert into c27 values default;
create table a27 as select * from c27;
insert into a27 values default;
select SYSTIMESTAMP >= col1 , col1=col2, col2=col3 from a27 order by col1;
desc a27;
drop table if exists c27;
drop table if exists a27;


create table c27(col1 date default SYSDATE, col2 datetime default SYSDATETIME, col3 string default USER, col4 char(20) default CURRENT_USER);
insert into c27 values default;
insert into c27 values default;
create table a27 as select * from c27;
select SYSDATE >= col1, SYSDATETIME >= col2 , col3 = USER from a27 order by 1;
insert into a27 values default;
select SYSDATE >= col1, SYSDATETIME >= col2,  col3 = USER from a27 order by col2 desc limit 1;
show columns in a27;
drop table if exists c27;
drop table if exists a27;


create table c27(col1 datetime not null default CURRENT_TIMESTAMP, col2 timestamp primary key default UNIX_TIMESTAMP(), col3 datetime unique default SYSTIMESTAMP);
insert into c27 values default;
create table a27 as select col1, col2, col3 from c27;
select SYSTIMESTAMP>=col1 , col1=col2 , col2=col3 from a27 order by 1;
insert into a27 values default;
select SYSTIMESTAMP>=col1 , col1=col2 , col2=col3 from a27 order by col1 desc limit 1;
desc a27;
drop table if exists a27;
drop table if exists c27;


create table c27(col1 date primary key not null default SYSDATE, col2 datetime default SYSDATETIME unique, col3 string default USER unique not null, col4 varchar(20) unique default CURRENT_USER not null);
insert into c27 values default;
create table a27 as select col1, col2, col4 from c27;
select SYSDATE>=col1, SYSDATETIME>=col2, col4=USER from a27 order by 1;
insert into a27 values default;
select SYSDATE>=col1, SYSDATETIME>=col2, col4=CURRENT_USER from a27 order by col2 desc limit 1;
show columns in a27;
drop table if exists c27;
drop table if exists a27;


create table poo(col1 timestamp primary key default CURRENT_TIMESTAMP, col2 timestamp default SYSDATE not null, col3 datetime unique default SYSDATETIME, col4 char varying not null default CURRENT_USER);
create table foo(col1 timestamp primary key default SYSDATETIME, col2 char(50) default USER, col3 int unique, col4 datetime default SYSDATETIME, index i(col3 asc, col2 desc), 
			constraint fk_col1 foreign key(col1) references poo(col1) on update restrict);
insert into poo values default;
insert into foo(col1) select col1 from poo;
create table pas as select * from poo;
show columns in pas;
show index in pas;
create table fas as select * from foo;
desc fas;
show index in fas;


--error
drop table poo;
drop table foo;
drop table if exists poo;
drop table if exists pas;
drop table if exists fas;

commit;
--+ holdcas off;
