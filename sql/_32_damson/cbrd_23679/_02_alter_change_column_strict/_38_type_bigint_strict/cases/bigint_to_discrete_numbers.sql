--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : BIGINT to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- BIGINT 1 : to short, values in range
create table t1 (b1 bigint);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 sh1 short;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 2 : to short, values out of range
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 sh1 short;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 1 : to int, values out of range
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 i1 int;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 2 : to int, values in range
create table t1 (b1 bigint);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 i1 int;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
