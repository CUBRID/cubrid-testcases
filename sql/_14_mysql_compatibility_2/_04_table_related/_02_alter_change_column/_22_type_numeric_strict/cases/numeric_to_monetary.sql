--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : NUMERIC to MONETARY
-- constraints : no constraints
-- ordering : no order defined
-- name : 
-- type change to floating point types

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- NUMERIC 1 : to monetary 
create table t1 (n1 numeric(6,2));
insert into t1 values (1234.0),(9999.99),(-9999.0);
-- should be ok
insert into t1 values (1234.0);
-- should be ok with trunctation to 1234.12
insert into t1 values (1234.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 m1 monetary;
-- should fail (prec)
insert into t1 values (-12345.123);

-- should fail (unique constr)
insert into t1 values (1234);

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : to double + monetary
create table t1 (n1 numeric(11,2) unique);
insert into t1 values (123456789.0),(999999999.99),(-999999999.0);
-- should fail : unique 
insert into t1 values (123456789.0);
-- should be ok with trunctation to 123456789.12
insert into t1 values (123456789.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 m1 monetary unique;
-- should fail : prec
insert into t1 values (-1234567890.123);

-- should fail (unique )
insert into t1 values (123456789);

select * from t1 order by 1;
show columns in t1;

drop table t1;



set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;
