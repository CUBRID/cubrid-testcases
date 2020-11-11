---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : TIMESTAMP
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';


-------------- TIMESTAMP 1 : to varchar, prec to small
create table t1 (t timestamp);
insert into t1 values (timestamp'2001-03-04 11:12:13');
insert into t1 values (timestamp'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 nchar varying(21);

-- should be ok:
insert into t1 values (timestamp'2001-11-10 03:06:01');
-- should fail
insert into t1 values (n'abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIMESTAMP 2 : to varnchar, prec enough
create table t1 (t timestamp);
insert into t1 values (timestamp'2001-03-04 11:12:13');
insert into t1 values (timestamp'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 nchar varying(22);

-- should be ok:
insert into t1 values (timestamp'2001-11-10 03:06:01');

insert into t1 values (n'abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- TIMESTAMP 3 : to varnchar, prec not specified
create table t1 (t timestamp);
insert into t1 values (timestamp'2001-03-04 11:12:13');
insert into t1 values (timestamp'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change t s1 nchar varying;

-- should be ok:
insert into t1 values (timestamp'2001-11-10 03:06:01');

insert into t1 values (n'abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
