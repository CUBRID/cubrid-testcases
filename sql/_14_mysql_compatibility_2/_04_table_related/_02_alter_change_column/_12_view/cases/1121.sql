---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints :
-- ordering : no order defined
-- name : same of different
-- other : the table has VIEW on it 


-------------- column name changes + type changes
create table t1 (i1 integer);
create view v1 as select i1 from t1;

insert into t1 values (1),(2),(3);

select * from t1 order by 1;
select * from v1 order by 1;

alter table t1 change column i1 d1 double;

insert into t1 values (5);

select * from t1 order by 1;
-- FAILS in MYSQL : ERROR 1356 (HY000): View 'db1.v1' references invalid table(s) or column(s) or function(s) or definer/invoker of view lack rights to use them
select * from v1 order by 1;

drop view v1;
drop table t1;




-------------- column name the same , type changes
create table t1 (i1 integer);
create view v1 as select i1 from t1;

insert into t1 values (1),(2),(3);

select * from t1 order by 1;
select * from v1 order by 1;


alter table t1 change column i1 i1 double;

insert into t1 values (5e-11);

select * from t1 order by 1;
-- MYSQL : OK
select * from v1 order by 1;

drop view v1;
drop table t1;




-------------- column name the same , type changes
create table t1 (f1 float);
create view v1 as select f1 from t1;

insert into t1 values (1.1212312312312),(2e-1),(3.1123123);

select * from t1 order by 1;
select * from v1 order by 1;

alter table t1 change column f1 f1 double;

select * from t1 order by 1;
-- MYSQL : values in VIEW result differs after ALTER
-- CUBRID : values in VIEW result are the same after ALTER: the type in view is kept
select * from v1 order by 1;

drop view v1;
drop table t1;


-------------- column name the same , type changes
create table t1 (f1 float);
create view v1 as select length(repeat(f1,1)) lf from t1;

insert into t1 values (1.1212312312312),(2e-1),(3.1123123);

select * from t1 order by 1;
select * from v1 order by 1;

alter table t1 change column f1 f1 double;

select * from t1 order by 1;
-- values in VIEW result differs after ALTER
select * from v1 order by 1;

drop view v1;
drop table t1;


