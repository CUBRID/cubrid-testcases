--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : DOUBLE to other types
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- DOUBLE 1 : to time 
create table t1 (d1 double);
insert into t1 values (1),(-2.1),(2e1);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

-- should fail (not supported)
alter table t1 change d1 t time;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;


commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

