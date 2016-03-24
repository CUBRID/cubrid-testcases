--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined

set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- nchar 1 : to int, contains incompatible chars
create table t1 (s1 nchar(10));
insert into t1 values (n'123'),(n'12345'),(n'abc');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 i1 int;

insert into t1 values (n'123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- nchar 2 : to int, contains only compatible chars
create table t1 (s1 nchar(10));
insert into t1 values (n'123'),(n'12345');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 i1 int;

insert into t1 values (n'123');

select * from t1 order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

