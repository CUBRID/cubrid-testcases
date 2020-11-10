--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : NUMERIC to BIGINT
-- constraints : no constraints
-- ordering : no order defined
-- name : 
-- type change to bigint

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- NUMERIC 1 : ok
create table t1 (n1 numeric(18,0) unique);
insert into t1 values (123456789012345678.0),(999999999999999999.0),(-999999999999999999.0);
-- should fail
insert into t1 values (123456789012345678.0);
-- should be ok with trunctation to 523456789012345678.0
insert into t1 values (523456789012345678.1);

select n1,length(to_char(n1)) from t1 order by 1;
show columns in t1;

alter table t1 change n1 b1 bigint unique;
-- should be ok
insert into t1 values (-9223372036854775808);
insert into t1 values (9223372036854775807);

-- should fail (unique constr)
insert into t1 values (123456789012345678);

select b1,length(to_char(b1)) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : prec too big
create table t1 (n1 numeric(19,0) unique);
insert into t1 values (1234567890123456789.0),(999999999999999999.0),(-999999999999999999.0);
-- should not fail
insert into t1 values (9234567890123456789.0);
-- should be OK with trunction to 5234567890123456789.0
insert into t1 values (5234567890123456789.1);

select n1,length(to_char(n1)) from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 n1 bigint unique;
-- should be ok
insert into t1 values (-9223372036854775808);
insert into t1 values (9223372036854775807);

-- should fail (unique constr)
insert into t1 values (123456789);

select n1,length(to_char(n1)) from t1 order by 1;
show columns in t1;

drop table t1;

-------------- NUMERIC 1 : scale > 0
create table t1 (n1 numeric(12,2) unique);
insert into t1 values (1234567890.0),(9999999999.99),(-1234567890.31);
-- should fail
insert into t1 values (1234567890.0);
-- should fail
insert into t1 values (12345678901.12);

select n1,length(to_char(n1)) from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 n1 bigint unique;
-- should fail
insert into t1 values (-9223372036854775808);
-- should fail (unique constr)
insert into t1 values (1234567890);

select n1,length(to_char(n1)) from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
