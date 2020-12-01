--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- bit 1 : precision increase
create table t1 (s1 BIT(10));
insert into t1 values (b'1101'),(b'1100110011');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 BIT(20);
insert into t1 values (b'11001100111100110011');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- bit 2 : precision decrease
create table t1 (s1 BIT(20));
insert into t1 values (b'11001100111100110011'),(b'1100110011110110');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 BIT(10);
insert into t1 values (b'1100110011');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- bit 3 : to varbit , precision same
create table t1 (s1 BIT(10));
insert into t1 values (b'1101'),(b'1100110011');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 BIT VARYING(10);
insert into t1 values (b'1100110001');
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- bit 4 : to varbit, precision decrease
create table t1 (s1 BIT(20));
insert into t1 values (b'11001100111100110011'),(b'1100110011110110');

select * from t1 order by 1; 
show columns in t1;

alter table t1 change s1 s1 BIT VARYING(10);
insert into t1 values (b'1100110011');
select * from t1 order by 1;
show columns in t1;

drop table t1;

commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
