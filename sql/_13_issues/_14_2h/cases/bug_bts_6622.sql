drop view if exists gtest;
drop table if exists t1;

create table t1 (id int, name char(5));
insert into t1 values(1,'3'),(3,'aa');
create view gtest as select name from t1;
select * from gtest;
desc gtest;
alter t1 modify column name char(10);
desc t1;
desc gtest;

drop view if exists gtest;
drop table if exists t1;
