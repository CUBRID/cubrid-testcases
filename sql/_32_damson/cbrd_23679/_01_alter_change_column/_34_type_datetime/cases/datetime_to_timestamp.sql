---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATETIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-------------- DATETIME 1 : change to TIMESTAMP
create table t1 (d datetime);
insert into t1 values (datetime'03/04/1999 11:12:13');
insert into t1 values (datetime'11/12/2001 04:05:06');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d timestamp;
-- should be ok:
insert into t1 values (timestamp'12/11/1996 10:11:12');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- DATETIME 2 : change to TIMESTAMP , UNIQUE
create table t1 (d datetime unique);
insert into t1 values (datetime'03/04/1999 11:12:13');
insert into t1 values (datetime'11/12/2001 04:05:06');

-- should fail
insert into t1 values (datetime'11/12/2001 04:05:06');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d timestamp unique;
-- should be ok:
insert into t1 values (timestamp'12/11/1996 10:11:12');

-- should fail (unique):
insert into t1 values (timestamp'12/11/1996 10:11:12');

select * from t1 order by 1;
show columns in t1;

drop table t1;



set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
