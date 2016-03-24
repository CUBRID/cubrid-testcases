--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : datetime , not type change 
-- other :


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table t1 ( dt datetime );
insert into t1 values (datetime'0001-01-01 00:00:00'),(datetime'2001-03-04 11:12:13'),(NULL); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change dt dt1 datetime not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( dt datetime );
insert into t1 values (datetime'0001-01-01 00:00:00'),(datetime'2001-03-04 11:12:13'),(NULL);
select * from t1 order by 1;
show columns in t1;

alter table t1 change dt dt1 datetime not NULL;


select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( dt datetime );
insert into t1 values (datetime'0001-01-01 00:00:00'),(datetime'2001-03-04 11:12:13');
select * from t1 order by 1;
show columns in t1;

alter table t1 change dt dt1 datetime not NULL;


select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
