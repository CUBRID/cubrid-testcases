--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : BIGINT to floating numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- BIGINT 1 : to float , values out of range
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 f1 float;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 2 : to float , values in range
create table t1 (b1 bigint);
insert into t1 values (1),(-2),(2);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 f1 float;
-- should be ok
insert into t1 values (9223372036854775807);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 3 : to double , values in range
create table t1 (b1 bigint);
insert into t1 values (1),(-2),(2);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 d1 double;
-- should be ok
insert into t1 values (9223372036854775807);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 4 : to double , values out of range
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 d1 double;
-- should be ok
insert into t1 values (9223372036854775807);

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 5 : to monetary , values in range
create table t1 (b1 bigint);
insert into t1 values (1),(-2),(2);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 d1 monetary;
-- should fail
insert into t1 values (\9223372036854775807);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 5 : to monetary , values out of range
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 d1 monetary;
-- should fail
insert into t1 values (\9223372036854775807);

select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
