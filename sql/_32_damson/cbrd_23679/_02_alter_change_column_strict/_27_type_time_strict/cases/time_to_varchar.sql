---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : TIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';


-------------- TIME 1 : to varchar, prec to small
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 varchar(10);

-- should be ok:
insert into t1 values (time'01:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIME 2 : to varchar, prec enough
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 varchar(11);

-- should be ok:
insert into t1 values (time'01:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIME 3 : to varchar, prec not specified
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 varchar;

-- should be ok:
insert into t1 values (time'01:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
