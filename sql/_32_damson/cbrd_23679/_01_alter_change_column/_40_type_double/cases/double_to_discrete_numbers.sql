--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : DOUBLE to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- DOUBLE 1 : to short, values in range
create table t1 (d1 double);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change d1 sh1 short;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- DOUBLE 2 : to short, values out of range
create table t1 (d1 double);
insert into t1 values (1),(-100000),(100000),(1.1);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change d1 sh1 short;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- DOUBLE 1 : to int, values out of range
create table t1 (d1 double);
insert into t1 values (1),(-2147483648),(2147483648),(1.1);

insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change d1 i1 int;
-- should be ok
insert into t1 values (1e20);
select * from t1  order by 1;
show columns in t1;

drop table t1;




-------------- DOUBLE 1 : to bigint
create table t1 (d1 double);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change d1 i1 bigint;
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
