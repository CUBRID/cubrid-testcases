--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- char 1 : to int, contains incompatible chars
create table t1 (s1 char(10));
insert into t1 values ('123'),('12345'),('abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 i1 int;

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- char 2 : to int, contains only compatible chars
create table t1 (s1 char(5));
insert into t1 values ('12301'),('12345');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 i1 int;

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
