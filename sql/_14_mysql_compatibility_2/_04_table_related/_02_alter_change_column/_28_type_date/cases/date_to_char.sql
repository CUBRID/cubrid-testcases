---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATE


-------------- DATE 1 : to char, prec to small
create table t1 (d date);
insert into t1 values (date'2010-01-03');
insert into t1 values (date'1999-02-04');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 char(9);

-- should be ok:
insert into t1 values (date'2000-06-03');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATE 2 : to char, prec enough
create table t1 (d date);
insert into t1 values (date'2010-01-03');
insert into t1 values (date'1999-02-04');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 char(10);


insert into t1 values (date'2000-06-03');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

