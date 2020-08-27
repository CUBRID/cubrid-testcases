--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to discrete numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- SHORT 1 : to float 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 f1 float;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 2 : to float , unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 f1 float unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (32768.21);
-- should fail (unique)
insert into t1 values (32768.21);

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- SHORT 3 : to double 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 d1 double;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 4 : to double , unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 d1 double unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (32768.212121);
-- should fail (unique)
insert into t1 values (32768.212121);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 5 : to monetary 
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 m1 monetary;
-- should be ok
insert into t1 values (32768);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 6 : to monetary , unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 d1 monetary unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (\32768.212121);
-- should fail (unique)
insert into t1 values (\32768.212121);

select * from t1  order by 1;
show columns in t1;

drop table t1;



commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

