--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- permissive conversion

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varchar 1 : to date, contains incompatible chars
create table t1 (s1 varchar(20));
insert into t1 values ('2010-10-10'),('abc');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 d1 date;

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 2 : to date, contains only compatible chars
create table t1 (s1 varchar(20));
insert into t1 values ('2010-10-10'),('2000-03-01');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 d1 date;

insert into t1 values ('123');
select substring(d1,1,5) from t1 order by 1;
--select * from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
