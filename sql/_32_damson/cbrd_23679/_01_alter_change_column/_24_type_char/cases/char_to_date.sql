--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- char 1 : to date, contains incompatible chars
create table t1 (s1 char(20));
insert into t1 values ('2010-10-10'),('abc');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 d1 date;

insert into t1 values ('123');

--select * from t1 order by 1;
select substring(d1,1,5) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- char 2 : to date, contains only compatible chars
create table t1 (s1 char(20));
insert into t1 values ('2010-10-10'),('2000-03-01');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 d1 date;

insert into t1 values ('123');

--select * from t1 order by 1;
select substring(d1,1,5) from t1 order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
set system parameters 'allow_truncated_string=no';
