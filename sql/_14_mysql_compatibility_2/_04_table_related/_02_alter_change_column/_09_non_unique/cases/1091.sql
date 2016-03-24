---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : new constraints same as old constraints :  NON-UNIQUE INDEX
-- ordering : no order defined
-- name : same name or different


-------------- compound index , type changes, same name
create table t1 (i1 integer,i2 integer);

insert into t1 values (1,1),(2,2),(3,3);

alter table t1 add index idx (i1,i2);

select * from t1 order by 1,2;
-- MYSQL : OK, CUBRID should fail
alter table t1 change column i2 i2 char(2);

select * from t1 order by 1,2;

drop table t1;


-------------- compound index , type changes , name changes 
create table t1 (i1 integer,i2 integer);

insert into t1 values (1,1),(2,2),(3,3);

alter table t1 add index idx (i1,i2);

select * from t1 order by 1,2;

show columns in t1;
-- MYSQL : OK, CUBRID should fail
alter table t1 change column i2 c2 char(2);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-------------- compound index , type changes, same name
create table t1 (i1 integer,i2 integer);

insert into t1 values (1,1),(2,2),(3,3);

alter table t1 add index idx (i1,i2);

show columns in t1;

select * from t1 order by 1,2;
-- OK: 
alter table t1 change column i2 i2 char(11);

show columns in t1;

select * from t1 order by 1,2;

drop table t1;



