---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : TIMESTAMP
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-------------- TIMESTAMP 1 : change to BIGINT
create table t1 (t timestamp);
insert into t1 values (timestamp'03/04/1999 11:12:13');
insert into t1 values (timestamp'11/12/2001 04:05:06');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change t b bigint;
-- should be ok:
insert into t1 values (timestamp'12/11/1996 10:11:12');

insert into t1 values (123456789012);

select * from t1 order by 1;
show columns in t1;

drop table t1;






set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
