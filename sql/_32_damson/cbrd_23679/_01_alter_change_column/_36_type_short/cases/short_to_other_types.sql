--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to other types
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed



set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- SHORT 1 : to date 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

-- should fail (not supported)
alter table t1 change sh1 d1 date;
-- should be ok
insert into t1 values (32767);
select * from t1  order by 1;
show columns in t1;

drop table t1;


commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

