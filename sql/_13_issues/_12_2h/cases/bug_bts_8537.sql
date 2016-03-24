drop table if exists foo;
drop table if exists t1;
drop table if exists t2;
drop table if exists t3;
drop table if exists t4;
drop table if exists t5;

autocommit off;
create table foo(col1 int primary key auto_increment, col2 date default 'abc');
create table foo(col1 int primary key auto_increment, col2 date);
select * from db_serial where name='foo_ai_col1';
rollback;

create table t1(col1 int primary key auto_increment, col2 date default 'abc');
create table t2;
alter table t2 add COLUMN (col1 int primary key auto_increment, col2 date default 'abc');
alter table t2 add COLUMN (col1 int primary key auto_increment default 'abc');
create table t3(col1 int, col2 date);
alter table t3 change COLUMN col1 col1 auto_increment default 'abc';
create table t4(col1 int primary key auto_increment, col2 date default 'abc') PARTITION BY RANGE (col1) (PARTITION p1 VALUES LESS THAN (200));
commit;
select * from db_serial where name='foo_ai_col1';
create table t5(col1 int);
commit;
drop class t5, db_user;
commit;
select class_name from db_class where class_name = 't5';
rollback;
drop t2,t3,t5;
commit;

autocommit on;
create table foo(col1 int primary key auto_increment, col2 date default 'abc');
create table foo(col1 int primary key auto_increment, col2 date);
select * from db_serial where name='foo_ai_col1';

create table t1(col1 int primary key auto_increment, col2 date default 'abc');
create table t2;
alter table t2 add COLUMN (col1 int primary key auto_increment, col2 date default 'abc');
alter table t2 add COLUMN (col1 int primary key auto_increment default 'abc');
create table t3(col1 int, col2 date);
alter table t3 change COLUMN col1 col1 auto_increment default 'abc';
create table t4(col1 int primary key auto_increment, col2 date default 'abc') PARTITION BY RANGE (col1) (PARTITION p1 VALUES LESS THAN (200));
select * from db_serial where name='foo_ai_col1';
create table t5(col1 int);
drop class t5, db_user;
select class_name from db_class where class_name = 't5';
drop t2,t3,t5,foo;
