--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : SHORT to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- SHORT 1 : to NUMERIC , enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 n1 numeric(6,1);
-- should be ok
insert into t1 values (32768);

insert into t1 values (32768.1);
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- SHORT 2 : to NUMERIC , enough precision, unique
create table t1 (sh1 short unique);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change sh1 n1 numeric(6,1) unique;
-- should be ok
insert into t1 values (32768);

insert into t1 values (32768.2);
-- should fail (unique)
insert into t1 values (32768.2);

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- SHORT 3 : to NUMERIC , not enough precision
create table t1 (sh1 short);
insert into t1 values (1),(-32768),(32767);

-- should fail (range)
insert into t1 values (32768);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change sh1 n1 numeric(6,2);
-- should fail
insert into t1 values (32768);

select * from t1  order by 1;
show columns in t1;

drop table t1;



set system parameters 'alter_table_change_type_strict=no';


commit;
--+ holdcas off;
