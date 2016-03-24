--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : timestamp , not type change 
-- other :


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table t1 ( ts timestamp );
insert into t1 values (timestamp'00:00:00 PM 01/01/1970'),(timestamp'11:12:13 PM 03/04/1999'),(NULL); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change ts ts1 timestamp not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( ts timestamp );
insert into t1 values (timestamp'00:00:00 PM 01/01/1970'),(timestamp'11:12:13 PM 03/04/1999'),(NULL); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change ts ts1 timestamp not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( ts timestamp );
insert into t1 values (timestamp'00:00:00 PM 01/01/1970'),(timestamp'11:12:13 PM 03/04/1999'); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change ts ts1 timestamp not NULL;
select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
