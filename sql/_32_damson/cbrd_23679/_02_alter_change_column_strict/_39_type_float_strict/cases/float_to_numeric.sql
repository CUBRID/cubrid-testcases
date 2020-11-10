--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : FLOAT to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- FLOAT 1 : to NUMERIC
create table t1 (f1 float);
insert into t1 values (1),(-1.1),(1e10);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 n1 numeric(38,20);
-- should be ok
insert into t1 values (1e21);

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- FLOAT 1 : to NUMERIC, out of range
create table t1 (f1 float);
insert into t1 values (-2e37),(2e37);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 n1 numeric(38,20);
-- should be ok
insert into t1 values (1e21);

select * from t1  order by 1;
show columns in t1;

drop table t1;




set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
