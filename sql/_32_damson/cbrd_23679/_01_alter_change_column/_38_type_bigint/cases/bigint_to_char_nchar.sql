--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : BIGINT to CHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- BIGINT 1 : to CHAR , enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 s1 char(20);
-- should be ok 
insert into t1 values ('12345678901234567890');

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 2 : to CHAR , enough precision, unique
create table t1 (b1 bigint unique);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 s1 char(20) unique;
-- should be ok 
insert into t1 values ('12345678901234567890');

insert into t1 values ('abcdef');
-- should fail (unique)
insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 3 : to CHAR , not enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should be ok
alter table t1 change b1 s1 char(19);
-- should be ok
insert into t1 values ('a12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;





-------------- BIGINT 1 : to NCHAR , enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 s1 nchar(20);
-- should be ok 
insert into t1 values (n'-12345678901234567890');

insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- BIGINT 2 : to NCHAR , enough precision, unique
create table t1 (b1 bigint unique);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);
-- should fail (unique)
insert into t1 values (1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change b1 s1 nchar(20) unique;
-- should be ok 
insert into t1 values (n'12345678901234567890');

insert into t1 values (n'abcdef');
-- should fail (unique)
insert into t1 values (n'abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- BIGINT 3 : to NCHAR , not enough precision
create table t1 (b1 bigint);
insert into t1 values (1),(-9223372036854775808),(9223372036854775807);

-- should fail (range)
insert into t1 values (9223372036854775808);

select * from t1 order by 1;
show columns in t1;

-- should be ok
alter table t1 change b1 s1 nchar(19);
-- should be ok
insert into t1 values (n'a12345');

select * from t1  order by 1;
show columns in t1;

drop table t1;



commit;
--+ holdcas off;

set system parameters 'allow_truncated_string=no';
set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';
