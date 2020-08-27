--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- type change : to char

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varnchar 1 : 
create table t1 (s1 nchar varying(10));
insert into t1 values (n'123'),(n'1234567890'),(n'abc');

select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 nchar(10);
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varnchar 2 : 
create table t1 (s1 nchar varying(10));
insert into t1 values (n'123'),(n'1234567890'),(n'abc');

select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 nchar(20);

insert into t1 values(n'12345678901234567890');
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varnchar 3 : 
create table t1 (s1 nchar varying(10));
insert into t1 values (n'123'),(n'1234567890'),(n'abc');

select s1, length(s1) from t1 order by 1; 
show columns in t1;

-- should fail
alter table t1 change s1 s1 nchar(9);
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
