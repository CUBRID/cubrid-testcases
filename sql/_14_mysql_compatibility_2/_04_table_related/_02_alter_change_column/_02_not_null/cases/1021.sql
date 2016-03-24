--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : int , not type change 
-- other :


-- dropping 'not null'
create table t1 ( i integer not null );
insert into t1 values (11),(3112),(1000012),(1002000),(1090000),(21);
select * from t1 order by 1;
show columns in t1;

alter table t1 change i i1 integer;

select * from t1 order by 1;
show columns in t1;

insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';



create table t1 ( i integer );
insert into t1 values (11),(NULL),(1000012),(1002000),(1090000),(21);
select * from t1 order by 1;
show columns in t1;

alter table t1 change i i1 integer not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( i integer );
insert into t1 values (11),(NULL),(1000012),(1002000),(1090000),(21);
select * from t1 order by 1;
show columns in t1;

alter table t1 change i i1 integer not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( i integer );
insert into t1 values (11),(1000012),(1002000),(1090000),(21);
select * from t1 order by 1;
show columns in t1;

alter table t1 change i i1 integer not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;

set system parameters 'error_log_warning=no'; 
set system parameters 'error_log_level=syntax';

commit;
--+ holdcas off;
