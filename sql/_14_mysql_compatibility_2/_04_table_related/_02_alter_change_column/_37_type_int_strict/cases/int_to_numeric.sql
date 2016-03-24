--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : INT to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- INT 1 : to NUMERIC , enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 n1 numeric(10,0);
-- should be ok
insert into t1 values (2147483648);

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- INT 2 : to NUMERIC , enough precision, unique
create table t1 (i1 int unique);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change i1 n1 numeric(13,3) unique;
-- should be ok
insert into t1 values (2147483648);

insert into t1 values (2147483648.223);
-- should fail (unique)
insert into t1 values (2147483648.223);

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- INT 3 : to NUMERIC , not enough precision
create table t1 (i1 int);
insert into t1 values (1),(-2147483648),(2147483647);

-- should fail (range)
insert into t1 values (2147483648);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i1 n1 numeric(13,4);
-- should fail
insert into t1 values (2147483648);

select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'alter_table_change_type_strict=no';


commit;
--+ holdcas off;
