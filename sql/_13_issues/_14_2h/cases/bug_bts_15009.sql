-- This issue also verifies CBRD-24638.
-- Column default value problem when altering column type.
-- Altering default value column is allowed.

drop table if exists stu;
create table stu(id int,addr varchar(200)) comment 'this table store the student information';
show full columns from stu;
alter table stu add column phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
alter table stu modify phone varchar(2000);
show full columns from stu;
alter table stu modify id int;
show full columns from stu;
alter table stu change column phone phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
drop table stu;


drop table if exists stu;
create table stu(id int comment 'partition key',addr varchar(200)) comment 'this table store the student information' partition by range(id)(partition p0 values less than (10),partition p1 values less than maxvalue);
show full columns from stu;
alter table stu add column phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
alter table stu modify phone varchar(2000);
show full columns from stu;
alter table stu modify id int;
show full columns from stu;
alter table stu change column phone phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
drop table stu;

drop table if exists stu;
create table stu(id int comment 'partition key',addr varchar(200) ) comment 'this table store the student information' ;
show full columns from stu;
alter table stu add column phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
alter table stu modify phone varchar(2000);
show full columns from stu;
alter table stu modify id int;
show full columns from stu;
alter table stu change column phone phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify id int comment 'change world';
show full columns from  stu;
drop table stu;


drop table if exists stu;
create table stu(id int comment 'partition key',addr varchar(200) comment 'non-partition key') comment 'this table store the student information' partition by range(id)(partition p0 values less than (10),partition p1 values less than maxvalue);
show full columns from stu;
alter table stu add column phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify addr int comment 'change world';
show full columns from  stu;
alter table stu modify phone varchar(2000);
show full columns from stu;
alter table stu modify addr int;
show full columns from stu;
alter table stu change column phone phone bigint default 1860000000 comment 'recored the telephone number of students';
show full columns from stu;
alter table stu modify addr int comment 'change world';
show full columns from  stu;
drop table stu;

drop table if exists t;
create table t(i int comment 'auto_increment');
show full columns from t;
create unique index idx1 on t(i) comment 'uuuu';
show index from t;
alter index idx1 on t(i) comment 'aaa' rebuild;
show index from t;
alter table t change i id int;
show full columns from t;
drop t;

drop table if exists t;
create table t(i int auto_increment not null comment 'auto_increment');
show full columns from t;
insert into t values(null);
insert into t values(null);
insert into t values(null);
insert into t values(null);
insert into t values(null);
alter table t change i id int primary key comment 'primary key';
show full columns from t;
alter table t change id i int auto_increment not null comment 'auto_increment';
show full columns from t;
alter table t change id i int  not null comment 'auto increment';
show full columns from t;
alter table t change i i int  not null comment 'auto increment';
show full columns from t;
create unique index idx1 on t(i) comment 'uuuu';
show index from t;
alter index idx1 on t(i) comment 'aaa' rebuild;
show index from t;
alter table t change i id int;
show full columns from t;
alter table t modify id  varchar(100) primary key  comment 'dddd';
show full columns from t;
show index from t;
drop t;

drop table if exists t;
create table t(i int  comment 'auto_increment');
show full columns from t;
alter table t change i i int primary key comment ' primary key';
show full columns from t;
alter table t change i i int;
show full columns from t;
alter table t modify i  varchar(100) primary key  comment 'dddd';
show full columns from t;
show index from t;
alter index pk_t_i  on t(i) rebuild;
show full columns from t;
show index from t;
alter index pk_t_i  on t(i) comment 'abcdefghijklmn' rebuild;
show full columns from t;
show index from t;
drop t;
