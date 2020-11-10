--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : NUMERIC to SHORT
-- constraints : no constraints
-- ordering : no order defined
-- name : 
-- type change to short

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- NUMERIC 1 : ok
create table t1 (n1 numeric(4,0) unique);
insert into t1 values (1234.0),(9999.0),(-1231.0);
-- should fail
insert into t1 values (12345.0);
-- should be ok with trunctation to 9998.0
insert into t1 values (9998.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change n1 sh1 short unique;
-- should be ok
insert into t1 values (-32768);
-- should fail (unique constr)
insert into t1 values (1234);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : prec too big
create table t1 (n1 numeric(5,0) unique);
insert into t1 values (1234.0),(9999.0),(-1231.0);
-- should not fail
insert into t1 values (12345.0);
-- should be OK with trunction to 99998.0
insert into t1 values (99998.1);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 sh1 short unique;
-- should be ok
insert into t1 values (-32768);
-- should fail (unique constr)
insert into t1 values (1234);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- NUMERIC 1 : scale > 0
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (12345.0);
-- should fail
insert into t1 values (999.12);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 sh1 short unique;
-- should be ok
insert into t1 values (-32768);
-- should fail (unique constr)
insert into t1 values (12);

select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
