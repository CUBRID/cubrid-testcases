--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : MONETARY to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- MONETARY 1 : to CHAR
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1e10);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 char(200);

insert into t1 values (\1e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 2 : to NCHAR 
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1e10);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 nchar(200);

insert into t1 values (\1e1);

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 3 : to CHAR, not enough precision
create table t1 (m1 monetary);
insert into t1 values (\1100.11),(\-1.1),(\1.1e10),(\-1.1e10);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 char(4);

insert into t1 values (\1e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 4 : to NCHAR , not enough precision
create table t1 (m1 monetary);
insert into t1 values (\1100.11),(\-1.1),(\1.1e10),(\-1.1e10);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 nchar(4);

insert into t1 values (\1e1);

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
