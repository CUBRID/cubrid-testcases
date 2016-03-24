--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to other types
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to set 
create table t1 (i1 int);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

-- should fail (not supported)
alter table t1 change i1 s1 set(int);
-- should be ok
insert into t1 values (32767);
select * from t1  order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
