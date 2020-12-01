--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- permissive conversion

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varchar 1 : precision increase
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 varchar(200);
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 2 : precision decrease
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 varchar(5);
select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- varchar 3 : to set : incompatbile
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 set(varchar(10));
select * from t1 order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
