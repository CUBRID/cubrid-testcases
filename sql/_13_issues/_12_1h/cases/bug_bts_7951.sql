create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19');
alter table t promote partition p2;
drop t;
truncate table t__p__p2;
drop t__p__p2;
 
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19');
alter table t promote partition p2;
drop t;
drop table t__p__p2;
 
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19');
alter table t promote partition p2;
drop t;
update t__p__p2 set t=NULL where t='1972-2-19';
drop table t__p__p2;
 
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19');
alter table t promote partition p2;
drop t;
insert into t__p__p2(t) values('1972-2-19');
drop table t__p__p2;
  
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t(t) values('1970-3-10'),('1971-2-01'),('1972-2-19');
alter table t promote partition p2;
drop t;
delete from t__p__p2;
drop table t__p__p2;
  
 