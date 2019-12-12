--case1: test drop view if exists ...
create table t (a int);
create view v as select * from t;
drop view if exists v;
select * from v;
select * from t;
drop t;

--case2: test drop if exists ...
create table t (a int);
create view v as select * from t;
drop if exists v;
select * from v;
select * from t;
drop t;

--case3: test drop if exists table, v
create table t (a int);
create view v as select * from t;
drop if exists t, v;

--case4: test error 
create table t (a int);
create view v as select * from t;
drop view if exists t;
drop table if exists v;

drop view if exists v;
drop table if exists t;

--case5: view does not exist
create table t (a int);
create view v as select * from t;
drop table t;
drop if exists v;
