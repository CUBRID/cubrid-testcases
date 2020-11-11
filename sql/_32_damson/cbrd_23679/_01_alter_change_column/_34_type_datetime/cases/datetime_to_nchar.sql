---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATETIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-------------- DATETIME 1 : to nchar, prec to small
create table t1 (d datetime);
insert into t1 values (datetime'2010-01-03 03:06:02');
insert into t1 values (datetime'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 nchar(25);

-- should be ok:
insert into t1 values (datetime'2000-06-03 10:13:14');

insert into t1 values (n'abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATETIME 2 : to nchar, prec enough
create table t1 (d datetime);
insert into t1 values (datetime'2010-01-03 03:06:02');
insert into t1 values (datetime'1999-02-04 11:12:13');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 nchar(26);


insert into t1 values (datetime'2000-06-03 10:13:14');

insert into t1 values (n'abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
