---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATE


-------------- DATE 1 : change to DATETIME
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d datetime;
-- should be ok:
insert into t1 values (datetime'12/11/1996 10:11:12');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- DATE 2 : change to DATETIME , UNIQUE
create table t1 (d date unique);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');

-- should fail
insert into t1 values (date'11/12/2001');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d datetime unique;
-- should be ok:
insert into t1 values (datetime'12/11/1996 11:12:13');

-- should fail (unique):
insert into t1 values (datetime'12/11/1996 11:12:13');

select * from t1 order by 1;
show columns in t1;

drop table t1;



