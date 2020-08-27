--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to floating numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to float , values out of range
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 f1 float;
-- should be ok
insert into t1 values (2147483647);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to float , values in range
create table t1 (i1 int);
insert into t1 values (1),(-2),(2);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 f1 float;
-- should be ok
insert into t1 values (2147483647);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 3 : to double 
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 d1 double;
-- should be ok
insert into t1 values (2147483647);
insert into t1 values (2147483647.21);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 4 : to double , unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 d1 double unique;
-- should be ok
insert into t1 values (2147483648);

insert into t1 values (2147483648.212121);
-- should fail (unique)
insert into t1 values (2147483648.212121);

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 5 : to monetary 
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 d1 monetary;
-- should be ok
insert into t1 values (\2147483647);
insert into t1 values (\2147483647.21);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 6 : to monetary , unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 d1 monetary unique;
-- should be ok
insert into t1 values (\2147483648);

insert into t1 values (\2147483648.212121);
-- should fail (unique)
insert into t1 values (\2147483648.212121);

select * from t1  order by 1;
show columns in t1;

drop table t1;


commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

