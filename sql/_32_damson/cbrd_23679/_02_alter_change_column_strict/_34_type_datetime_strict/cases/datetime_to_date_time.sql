---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATETIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';


-------------- DATETIME 1 : change to DATE
create table t1 (dt datetime);
insert into t1 values (datetime'03/04/1999 10:11:12');
insert into t1 values (datetime'11/12/2001 09:04:11');

select * from t1 order by 1;
show columns in t1;

alter table t1 change dt d date;
-- should fail:
insert into t1 values (date'12/11/1996');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- DATETIME 2 : change to DATETIME , UNIQUE
create table t1 (dt datetime unique);
insert into t1 values (datetime'03/04/1999 10:11:13');
insert into t1 values (datetime'11/12/2001 10:12:14');
insert into t1 values (datetime'11/12/2001 04:21:24');

-- should fail
insert into t1 values (datetime'11/12/2001 04:21:24');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change dt d date unique;
-- should be ok:
insert into t1 values (datetime'12/11/1996 11:12:13');

-- should fail (unique):
insert into t1 values (datetime'12/11/1996 11:12:13');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- DATETIME 1 : change to TIME
create table t1 (dt datetime);
insert into t1 values (datetime'03/04/1999 10:11:12');
insert into t1 values (datetime'11/12/2001 09:04:11');

select * from t1 order by 1;
show columns in t1;

alter table t1 change dt t time;
-- should fail:
insert into t1 values (time'11:12:13');
select * from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
