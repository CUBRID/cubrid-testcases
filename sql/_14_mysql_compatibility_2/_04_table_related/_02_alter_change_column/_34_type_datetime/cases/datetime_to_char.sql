---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATETIME


-------------- DATETIME 1 : to char, prec to small
create table t1 (d datetime);
insert into t1 values (datetime'2010-01-03 11:12:13');
insert into t1 values (datetime'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 char(25);

-- should be ok:
insert into t1 values (datetime'1996-09-04 11:12:13');

-- should fail
insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATETIME 2 : to char, prec enough
create table t1 (d datetime);
insert into t1 values (datetime'2010-01-03 11:12:13');
insert into t1 values (datetime'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 char(26);

-- should be ok:
insert into t1 values (datetime'1996-09-04 11:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

