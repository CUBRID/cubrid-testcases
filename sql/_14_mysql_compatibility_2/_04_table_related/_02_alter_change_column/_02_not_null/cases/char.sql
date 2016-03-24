--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : testing add/drop : NOT NULL, 
-- ordering : no order defined
-- name : same of different
-- type : char , not type change 
-- other :


-- adding 'not null'  : strict mode
set system parameters 'alter_table_change_type_strict=yes';


create table t1 ( s1 char(10) );
insert into t1 values ('1234567890'),(''),(NULL),('123'),('12 ');
select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s char(11) not NULL;

select s1, length(s1) from t1 order by 1;

show columns in t1;

-- should fail:
insert into t1 values (NULL);

insert into t1 values ('12345678901');

drop table t1;


-- adding 'not null'  : permissive mode
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( s1 char(10) );
insert into t1 values ('1234567890'),(''),(NULL),('123'),('12 ');
select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s char(11) not NULL;

select s, length(s) from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

insert into t1 values ('12345678901');

drop table t1;



-- adding 'not null'  : permissive mode , but no existing NULL -> no warning
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes'; 

create table t1 ( s1 char(10) );
insert into t1 values ('1234567890'),(''),('123'),('12 ');
select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s char(11) not NULL;

select s, length(s) from t1 order by 1;
show columns in t1;

-- should fail:
insert into t1 values (NULL);

insert into t1 values ('12345678901');

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
