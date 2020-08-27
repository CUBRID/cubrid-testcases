--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- SHORT 1 : to int 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 i1 int;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 1 : to int , unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 i1 int unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (2100000000);
-- should fail (unique)
insert into t1 values (2100000000);

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- SHORT 1 : to bigint 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 b1 bigint;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 1 : to bigint , unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 b1 bigint unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (12345678901234);
-- should fail (unique)
insert into t1 values (12345678901234);

select * from t1  order by 1;
show columns in t1;

drop table t1;



commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

