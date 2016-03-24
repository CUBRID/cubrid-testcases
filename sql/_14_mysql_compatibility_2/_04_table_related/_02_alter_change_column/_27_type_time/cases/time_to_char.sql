---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : TIME


-------------- TIME 1 : to char, prec to small
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 char(10);

-- should be ok:
insert into t1 values (time'01:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIME 1 : to char, prec enough
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 char(11);

-- should be ok:
insert into t1 values (time'01:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

