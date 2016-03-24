---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : new constraints are gained  : UNIQUE KEY
-- ordering : no order defined
-- name : different names


-------------- with unique key :  double to int , data values would cause violation of UK
create table t1 (d1 double unique key);
insert into t1 values (1.112),(1.123);

select * from t1 order by 1;
-- this will fail : Duplicate entry '1' for key i1
alter table t1 change column d1 i1 integer;
select * from t1 order by 1;
drop table t1;


-------------- numbers 2 : with unique key :  double to int , data values would NOT cause violation of UK
create table t1 (d1 double unique key);
insert into t1 values (1.112),(2.123);

select * from t1 order by 1;
-- this is OK: 
alter table t1 change column d1 i1 integer;
select * from t1 order by 1;
drop table t1;

-------------- numbers 3 : with unique key :  int to double , data values would NOT cause violation of UK, UNIQUE is not specified in new definition
create table t1 (i1 int unique key);
insert into t1 values (1),(2);

select * from t1 order by 1;
-- this is OK: 
alter table t1 change column i1 d1 double;
-- should fail
insert into t1 values (1e0);

select * from t1 order by 1;
drop table t1;

-------------- numbers 4 : with unique key :  int to double , data values would NOT cause violation of UK, UNIQUE is specified in new definition
create table t1 (i1 int unique key);
insert into t1 values (1),(2);

select * from t1 order by 1;
-- this is OK: 
alter table t1 change column i1 d1 double unique;
-- should fail
insert into t1 values (1e0);

select * from t1 order by 1;
drop table t1;

