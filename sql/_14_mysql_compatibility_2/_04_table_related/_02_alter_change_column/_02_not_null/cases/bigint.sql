--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : bigint , not type change 
-- other :


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table t1 ( b bigint );
insert into t1 values (0),(1),(NULL),(-9223372036854775808),(9223372036854775807); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change b b1 bigint not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( b bigint);
insert into t1 values (0),(1),(NULL),(-9223372036854775808),(9223372036854775807); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change b b1 bigint not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( b bigint );
insert into t1 values (11),(0),(-9223372036854775808),(9223372036854775807); 
select * from t1 order by 1;
show columns in t1;

alter table t1 change b b1 bigint not NULL;

select * from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
