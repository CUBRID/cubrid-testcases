--01_if_not_exists_QA_Effort.sql

--clean up
drop table if exists t12366;
drop table if exists t12366_lk;
drop table if exists t12366_lk2;
drop table if exists t12366_as;

--scenario 1: general
drop table if exists t12366;
create table t12366(a varchar(10), b int not null);
drop table t12366;
create table if not exists t12366(a varchar(10), b int not null,c int);
desc t12366;
--run this command again, should success
create table if not exists t12366(a varchar(11), b int not null);
desc t12366;

--create a different table, should keep the old one
create table if not exists t12366(c date default sysdate);
desc t12366;

--scenario 2: create like another table
create table if not exists t12366_lk like t12366;
desc t12366_lk;
create table if not exists t12366_lk like t12366_lk;
desc t12366_lk;

--scenario 3: create like another table with ()
create table if not exists t12366_lk2 (like t12366);
desc t12366_lk2;
--execute it again, should success
create table if not exists t12366_lk2 (like t12366);
desc t12366_lk2;

--scenario 4: create as
insert into t12366 values('lex', 12366);
create table if not exists t12366_as as select a from t12366;
--check table
select * from t12366_as order by 1;
insert into t12366_as values ('bts');

--execute it again, should success
create table if not exists t12366_as as select a from t12366;
--check table
select * from t12366_as order by 1;

--clean up
drop table if exists t12366;
drop table if exists t12366_lk;
drop table if exists t12366_lk2;
drop table if exists t12366_as;


drop view v1;
drop table if exists t1,t2;
create table t1(i int ,j char(10));
insert into t1 values(1,'ab');
insert into t1 values(2,'abc');
insert into t1 values(3,'abcd');
create table t2 (like t1);
insert into t2 values(1,'ab');
insert into t2 values(2,'abc');
insert into t2 values(3,'abcd');
create view v1 as (select * from t1 union all select * from t2);
select * from v1 order by 1,2;
create table if not exists v1(id int default 1);
select * from v1 order by 1,2;
drop v1;
drop table if exists t1,t2;
