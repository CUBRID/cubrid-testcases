--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : FLOAT to other types
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- FLOAT 1 : to date 
create table t1 (f1 float);
insert into t1 values (1),(-2.1),(2e1);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

-- should fail (not supported)
alter table t1 change f1 d date;
-- should be ok
insert into t1 values (1e10);
select * from t1  order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
