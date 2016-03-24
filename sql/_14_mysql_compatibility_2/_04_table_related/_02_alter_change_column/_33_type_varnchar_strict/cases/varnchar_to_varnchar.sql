--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varnchar 1 : precision increase
create table t1 (s1 nchar varying(10));
insert into t1 values (n'123'),(n'1234567890'),(n'abc');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 nchar varying(20);

insert into t1 values (n'12345678901234567890');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 2 : precision decrease
create table t1 (s1 nchar varying(10));
insert into t1 values (n'123'),(n'1234567890'),(n'abc');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 nchar varying(5);
select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';



commit;
--+ holdcas off;
