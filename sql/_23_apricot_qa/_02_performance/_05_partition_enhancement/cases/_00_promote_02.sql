drop table if exists t;
drop table if exists temp;
drop table if exists t__p__p2;

create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
create table temp(t timestamp);
insert into temp values('1970-3-10'),('1971-2-01'),('1972-2-19');
insert into t select t,NULL,cast(t as varchar) from temp;
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 

create index idx on t(t);
alter table t promote partition p2;
drop t;

-- test
truncate table t__p__p2;

drop t__p__p2;
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t select t,NULL,cast(t as varchar) from temp;
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 

create index idx on t(t);
alter table t promote partition p2;
drop t;

 -- test
drop t__p__p2;

create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t select t,NULL,cast(t as varchar) from temp;
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 

create index idx on t(t);
alter table t promote partition p2;
drop t;

-- test
update t__p__p2 set t=NULL where t='1972-2-19'; 
insert into t__p__p2(t) values('1972-2-19');
 
drop t__p__p2;
create table t(t timestamp,id int auto_increment(2,3),v varchar(100)) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));
insert into t select t,NULL,cast(t as varchar) from temp;
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 
insert into t select * from t; 

create index idx on t(t);
alter table t promote partition p2;
drop t;

-- test
delete from t__p__p2; 
insert into t__p__p2(t) values('1972-2-19');
 
drop t__p__p2;
drop temp;
