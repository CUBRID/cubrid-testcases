--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , 
-- constraints : no constraints
-- ordering : no order defined
-- name : 
--type change : NUMERIC to VARCHAR, VARNCHAR


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- NUMERIC 1 : scale > 0 ; varchar large enough 
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 varchar(6) unique;
-- should be ok
insert into t1 values (to_char(-32768));
-- should fail (unique constr)
insert into t1 values ('12.00');
insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : scale > 0 ; varchar not large enough 
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 varchar(5) unique;
-- should fail (still numeric)
insert into t1 values (-32768);
-- should fail (unique constr)
insert into t1 values (12.00);

-- should fail
insert into t1 values ('abc');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 3 : scale > 0 ; varchar size infinite
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 varchar unique;
-- should be ok
insert into t1 values (to_char(-32768));
-- should fail (unique constr)
insert into t1 values ('12.00');
insert into t1 values ('abcdef');
insert into t1 values ('abc_123456789012345678901234567890123456789012345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------VARNCHAR

-------------- NUMERIC 1 : scale > 0 ; char large enough 
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 nchar varying(6) unique;
-- should be ok
insert into t1 values (n'-32768');
-- should fail (unique constr)
insert into t1 values (n'12.00');
insert into t1 values (n'abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 2 : scale > 0 ; char not large enough 
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 nchar varying(5) unique;
-- should fail (still numeric)
insert into t1 values (n'-32768');
-- should fail (unique constr)
insert into t1 values (n'12.00');

-- should fail
insert into t1 values (n'abc');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- NUMERIC 3 : scale > 0 ; varchar size infinite
create table t1 (n1 numeric(4,2) unique);
insert into t1 values (12.0),(99.99),(-12.31);
-- should fail
insert into t1 values (123.0);
-- should be ok : rounded to 99.123
insert into t1 values (99.123);

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change n1 c1 nchar varying unique;
-- should be ok
insert into t1 values (n'-32768');
-- should fail (unique constr)
insert into t1 values (n'12.00');
insert into t1 values (n'abcdef');
insert into t1 values (n'abc_123456789012345678901234567890123456789012345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;



set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
