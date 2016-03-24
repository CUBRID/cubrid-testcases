--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : NUMERIC to INT
-- constraints : no constraints
-- ordering : no order defined
-- name : 
-- type change to int



set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- NUMERIC 1 : ok
create table t1 (n1 numeric(9,0) unique);
insert into t1 values (123456789.0),(999999999.0),(-123456789.0);
-- should fail
insert into t1 values (1234567890.0);
-- should be ok with trunctation to 12345679.0
insert into t1 values (12345679.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change n1 i1 int unique;
-- should be ok
insert into t1 values (2147483647);
insert into t1 values (-2147483648);

-- should fail (unique constr)
insert into t1 values (123456789);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : prec too big
create table t1 (n1 numeric(10,0) unique);
insert into t1 values (1234567890.0),(9999999999.0),(-1234567890.0);
-- should not fail
insert into t1 values (9234567890.0);
-- should be OK with trunction to 323456789.0
insert into t1 values (323456789.1);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 i1 int unique;
-- should be ok
insert into t1 values (2147483647);
insert into t1 values (-2147483648);

-- should fail (unique constr)
insert into t1 values (123456789);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- NUMERIC 1 : scale > 0
create table t1 (n1 numeric(6,2) unique);
insert into t1 values (1234.0),(9999.99),(-1234.31);
-- should fail
insert into t1 values (123456.0);
-- should fail
insert into t1 values (12345.12);

select * from t1 order by 1;
show columns in t1;


alter table t1 change n1 i1 int unique;

insert into t1 values (2147483647);
insert into t1 values (-2147483648);

-- should fail (unique constr)
insert into t1 values (1234);

select * from t1  order by 1;
show columns in t1;

drop table t1;

commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

