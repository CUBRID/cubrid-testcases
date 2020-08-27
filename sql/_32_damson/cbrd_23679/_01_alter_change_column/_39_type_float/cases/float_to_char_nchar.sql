--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : FLOAT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- FLOAT 1 : to CHAR
create table t1 (f1 float);
insert into t1 values (1),(-1.1),(1.1e10);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 s1 char(200);

insert into t1 values (1e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- FLOAT 2 : to NCHAR 
create table t1 (f1 float);
insert into t1 values (1),(-1.1),(1.1e10);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 s1 nchar(200);

insert into t1 values (1e1);

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- FLOAT 1 : to CHAR, not enough precision
create table t1 (f1 float);
insert into t1 values (1),(-11213.1123),(1.1e10);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 s1 char(6);

insert into t1 values (1e1);

insert into t1 values ('abcdef');

select length(s1) from t1 order by 1;

select count(*) from t1 where s1>'z';

select count(*) from t1 where s1<'z';

show columns in t1;

drop table t1;

commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

