--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : float , not type change 
-- other :


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table t1 ( f float );
insert into t1 values (12.123123),(0),(NULL),(2e30),(-2e30);
select * from t1 order by 1;
show columns in t1;

alter table t1 change f f1 float not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( f float );
insert into t1 values (12.123123),(0),(NULL),(2e30),(-2e30);
select * from t1 order by 1;
show columns in t1;

alter table t1 change f f1 float not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( f float );
insert into t1 values (12.123123),(0),(2e30),(-2e30);
select * from t1 order by 1;
show columns in t1;

alter table t1 change f f1 float not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
