--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- SHORT 1 : to CHAR , enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 s1 char(6);
-- should be ok 
insert into t1 values ('-99999');

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 2 : to CHAR , enough precision, unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 s1 char(6) unique;
-- should be ok 
insert into t1 values ('32768');

insert into t1 values ('abcdef');
-- should fail (unique)
insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- SHORT 3 : to CHAR , not enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change sh1 s1 char(5);
-- should fail
insert into t1 values ('12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;





-------------- SHORT 1 : to NCHAR , enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 s1 nchar(6);
-- should be ok 
insert into t1 values (n'-99999');

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 2 : to NCHAR , enough precision, unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 s1 nchar(6) unique;
-- should be ok 
insert into t1 values (n'32768');

insert into t1 values (n'abcdef');
-- should fail (unique)
insert into t1 values (n'abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- SHORT 3 : to CHAR , not enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change sh1 s1 nchar(5);
-- should fail
insert into t1 values (n'12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
