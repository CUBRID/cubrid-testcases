--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- permissive conversion

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varchar 1 : to int, contains incompatible chars
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('12345'),('abc');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 i1 int;

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 2 : to int, contains only compatible chars
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('12345');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 i1 int;

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- varchar 3 : to short, out of range for short
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('123456789');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 sh1 short;

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 4 : to float, exponential notation
create table t1 (s1 varchar(10));
insert into t1 values ('1.2e1'),('-1.31e-1');

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 f1 float;

insert into t1 values (1.0121e1);

select * from t1 order by 1;
show columns in t1;

drop table t1;



set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
