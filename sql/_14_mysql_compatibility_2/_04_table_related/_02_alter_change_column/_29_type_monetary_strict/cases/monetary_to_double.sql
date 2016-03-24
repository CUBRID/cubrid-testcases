--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : MONETARY to DOUBLE
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- MONETARY 1 : 
create table t1 (m1 monetary);
insert into t1 values ($4.1),($200.2),(\3.3);
-- should be ok
insert into t1 values (\12345678.12);
select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 d1 double;
-- should be ok
insert into t1 values (12345678.12);
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 1 : unique
create table t1 (m1 monetary unique);
insert into t1 values ($4.1),($200.2),(\3.3);
-- should be ok
insert into t1 values (\12345678.12);
-- should fail (unique)
insert into t1 values (\12345678.12);
select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 d1 double unique;
-- should be ok
insert into t1 values (12345678.22);

-- should fail (unique)
insert into t1 values (12345678.22);

select * from t1  order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
