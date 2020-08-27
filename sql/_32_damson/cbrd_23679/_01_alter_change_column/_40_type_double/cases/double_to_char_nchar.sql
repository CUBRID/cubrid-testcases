--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : DOUBLE to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- DOUBLE 1 : to CHAR
create table t1 (d1 double);
insert into t1 values (1),(-1.1),(1.1e10);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change d1 s1 char(200);

insert into t1 values (1e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- DOUBLE 2 : to NCHAR 
create table t1 (d1 double);
insert into t1 values (1),(-1.1),(1.1e10);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change d1 s1 nchar(200);

insert into t1 values (1e1);

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- DOUBLE 3 : to CHAR, not enough precision
create table t1 (d1 double);
insert into t1 values (112.123),(-112.123);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change d1 s1 char(4);

insert into t1 values (1e1);

insert into t1 values ('abcd');
select length(s1) from t1 order by 1;

select count(*) from t1 where s1>'z';

select count(*) from t1 where s1<'z';

show columns in t1;

drop table t1;


-------------- DOUBLE 4 : to NCHAR , not enough precision
create table t1 (d1 double);
insert into t1 values (112.123),(-112.123);

-- should fail (range)
insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;


alter table t1 change d1 s1 nchar(4);

insert into t1 values (1e1);

insert into t1 values (n'abcd');
select length(s1) from t1 order by 1;

select count(*) from t1 where s1>n'z';

select count(*) from t1 where s1<n'z';
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
