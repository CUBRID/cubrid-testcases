---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : TIMESTAMP
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-------------- TIMESTAMP 1 : to char, prec to small
create table t1 (t timestamp);
insert into t1 values (timestamp'2010-01-03 11:12:13');
insert into t1 values (timestamp'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 char(21);

-- should be ok:
insert into t1 values (timestamp'1996-09-04 11:12:13');

-- should fail
insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIMESTAMP 2 : to char, prec enough
create table t1 (t timestamp);
insert into t1 values (timestamp'2010-01-03 11:12:13');
insert into t1 values (timestamp'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 char(22);

-- should be ok:
insert into t1 values (timestamp'1996-09-04 11:12:13');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
