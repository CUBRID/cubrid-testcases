--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to short, values in range
create table t1 (i1 int);
insert into t1 values (1),(-32768),(32767);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 sh1 short;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to short , values out of short range
create table t1 (i1 int);
insert into t1 values (1),(-32768),(32767);

insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 sh1 short;
-- should be ok
insert into t1 values (99999);

insert into t1 values (2100000000);

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- INT 1 : to bigint 
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483649);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 b1 bigint;
-- should be ok
insert into t1 values (2147483649);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 1 : to bigint , unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483649);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 b1 bigint unique;
-- should be ok
insert into t1 values (2147483649);

insert into t1 values (12345678901234);
-- should fail (unique)
insert into t1 values (12345678901234);

select * from t1  order by 1;
show columns in t1;

drop table t1;



commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

