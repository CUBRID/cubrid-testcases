--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : not NULL
-- ordering : no order defined
-- name : same name
-- type : TIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

-------------- TIME 1 : not change
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');
insert into t1 values (null);

select * from t1 order by 1;
show columns in t1;

alter table t1 change t t time not null;
-- should be ok:
insert into t1 values (time'01:12:13');
insert into t1 values (null);
select * from t1 order by 1;
show columns in t1;

drop table t1;



-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

-------------- TIME 1 : not change
create table t1 (t time);
insert into t1 values (time'11:12:13');
insert into t1 values (time'21:32:43');
insert into t1 values (null);

select * from t1 order by 1;
show columns in t1;

alter table t1 change t t time not null;
-- should be ok:
insert into t1 values (time'01:12:13');
insert into t1 values (null);
select * from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no'; 
set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
