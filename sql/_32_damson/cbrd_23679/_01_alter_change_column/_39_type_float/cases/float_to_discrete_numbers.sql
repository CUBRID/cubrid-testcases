--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : FLOAT to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- FLOAT 1 : to short, values in range
create table t1 (f1 float);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 sh1 short;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- FLOAT 2 : to short, values out of range
create table t1 (f1 float);
insert into t1 values (1),(-100000),(100000),(1.1);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 sh1 short;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- FLOAT 1 : to int
create table t1 (f1 float);
insert into t1 values (1),(-2147483648),(2147483648),(1.1);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 i1 int;
-- should be ok
insert into t1 values (1e20);
select * from t1  order by 1;
show columns in t1;

drop table t1;




-------------- FLOAT 1 : to bigint, out of range
create table t1 (f1 float);
insert into t1 values (1),(-9923372036854775809),(9923372036854775808);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 i1 bigint;
-- should be ok
insert into t1 values (1e20);
select * from t1  order by 1;
show columns in t1;

drop table t1;




commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

