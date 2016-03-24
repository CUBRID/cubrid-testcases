---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATE


-------------- DATE 1 : not change
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d date;
-- should be ok:
insert into t1 values (date'12/11/1996');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- DATE 2 : change to DATETIME
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d datetime;
-- should be ok:
insert into t1 values (date'12/11/1996');
select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATE 3 : change to BIGINT
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d bigint;
-- should be ok:
insert into t1 values (date'12/11/1996');
select * from t1 order by 1;
show columns in t1;

drop table t1;


