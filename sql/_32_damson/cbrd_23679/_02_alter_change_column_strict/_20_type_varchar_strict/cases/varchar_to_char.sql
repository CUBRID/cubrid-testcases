--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- type change : to char
-- permissive conversion

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- varchar 1 : prec same
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 char(10);
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 2 : prec increase 
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select s1, length(s1) from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 char(20);

insert into t1 values('12345678901234567890');
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;


-------------- varchar 3 : prec decrease, value in range
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('123456789'),('abc');

select s1, length(s1) from t1 order by 1; 
show columns in t1;

-- should fail
alter table t1 change s1 s1 char(9);
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;

-------------- varchar 4 : prec decrease, value out of range
create table t1 (s1 varchar(10));
insert into t1 values ('123'),('1234567890'),('abc');

select s1, length(s1) from t1 order by 1; 
show columns in t1;

-- should fail
alter table t1 change s1 s1 char(9);
select s1, length(s1) from t1 order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
