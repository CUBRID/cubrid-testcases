--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to CHAR , enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 char(11);
-- should be ok 
insert into t1 values ('-9999999999');

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to CHAR , enough precision, unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 char(11) unique;
-- should be ok 
insert into t1 values ('2147483648');

insert into t1 values ('abcdef');
-- should fail (unique)
insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 3 : to CHAR , not enough precision, value out of range
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 s1 char(5);
-- should fail
insert into t1 values ('a12345');

select length(s1) from t1 order by 1;

select count(*) from t1 where s1>'z';

select count(*) from t1 where s1<'z';

show columns in t1;

drop table t1;


-------------- INT 4 : to CHAR , not enough precision, values in range
create table t1 (i1 int);
insert into t1 values (1),(-231),(23212);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 s1 char(5);
-- should fail
insert into t1 values ('a12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 1 : to NCHAR , enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 nchar(11);
-- should be ok 
insert into t1 values (n'-9999999999');

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to NCHAR , enough precision, unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 s1 nchar(11) unique;
-- should be ok 
insert into t1 values (n'2147483648');

insert into t1 values (n'abcdef');
-- should fail (unique)
insert into t1 values (n'abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- INT 3 : to CHAR , not enough precision, values out of range
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 s1 nchar(5);
-- should fail
insert into t1 values (n'a12345');

select length(s1) from t1 order by 1;

select count(*) from t1 where s1>n'z';

select count(*) from t1 where s1<n'z';
show columns in t1;

drop table t1;


-------------- INT 4 : to CHAR , not enough precision, values in range
create table t1 (i1 int);
insert into t1 values (1),(-1232),(3422);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should not fail
alter table t1 change i1 s1 nchar(5);
-- should fail
insert into t1 values (n'a12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;
commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

