--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : NUMERIC to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- NUMERIC 1 : prec increase, scale same
create table t1 (n1 numeric(10,2));
insert into t1 values (1.1),(2.2),(3.3);
-- should be ok
insert into t1 values (12345678.12);

insert into t1 values (123456789.12);
select * from t1 order by 1;
show columns in t1;

alter table t1 change n1 n1 numeric(11,2);
-- should be ok
insert into t1 values (123456789.12);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 1 : prec increase, scale decrease
create table t1 (n1 numeric(10,4));
insert into t1 values (1.1),(2.2),(3.3);
-- should be ok
insert into t1 values (123456.1234);
-- should fail
insert into t1 values (1234567.1234);
select * from t1  order by 1;
show columns in t1;


alter table t1 change n1 n1 numeric(11,2);
-- should be ok
insert into t1 values (123456.1234);
-- should fail
insert into t1 values (1234567.1234);
select * from t1  order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'error_log_warning=no';
set system parameters 'error_log_level=syntax';

set system parameters 'allow_truncated_string=no';
