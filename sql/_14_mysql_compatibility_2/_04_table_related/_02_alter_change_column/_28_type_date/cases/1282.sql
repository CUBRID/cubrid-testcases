--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : not NULL
-- ordering : no order defined
-- name : same name
-- type : DATE


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

-------------- DATE 1 : not change
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');
insert into t1 values (null);

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d date not null;
-- should be ok:
insert into t1 values (date'12/11/1996');
-- should fail
insert into t1 values (null);
select * from t1 order by 1;
show columns in t1;

drop table t1;



-- adding 'not null'  : permissive  mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 


-------------- DATE 1 : not change
create table t1 (d date);
insert into t1 values (date'03/04/1999');
insert into t1 values (date'11/12/2001');
insert into t1 values (null);

select * from t1 order by 1;
show columns in t1;

alter table t1 change d d date not null;
-- should be ok:
insert into t1 values (date'12/11/1996');
-- should fail
insert into t1 values (null);
select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';
commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no'; 
