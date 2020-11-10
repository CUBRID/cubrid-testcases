--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : BIGINT to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- BIGINT 1 : to NUMERIC , enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 n1 numeric(19,0);
-- should be ok
insert into t1 values (9999992036854775808);

select n1, length(to_char(n1)) from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 2 : to NUMERIC , enough precision, unique
create table t1 (b1 bigint unique);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 n1 numeric(26,7) unique;
-- should be ok
insert into t1 values (9223372036854775808);

insert into t1 values (1234567890123456789.1234567);
-- should fail (unique)
insert into t1 values (1234567890123456789.1234567);

select n1, length(to_char(n1)) from t1  order by 1;
show columns in t1;

drop table t1;



-------------- BIGINT 3 : to NUMERIC , not enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change b1 n1 numeric(26,8);
-- should fail
insert into t1 values (9223372036854775808);

select * from t1  order by 1;
show columns in t1;

drop table t1;




set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
