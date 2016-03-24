--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : FLOAT to VARCHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- FLOAT 1 : to VARCHAR , enough precision
create table t1 (f1 float);
insert into t1 values (1),(-1.1),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change f1 s1 varchar(20);
-- should be ok 
insert into t1 values (1.123e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- FLOAT 2 : to VARCHAR , precision not specified, UNIQUE
create table t1 (f1 float unique);
insert into t1 values (1),(-1.1),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

-- should fail (unique)
insert into t1 values (-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change f1 s1 varchar unique;
-- should be ok 
insert into t1 values ('12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- FLOAT 3 : to VARCHAR , not enough precision
create table t1 (f1 float);
insert into t1 values (-1.11231),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change f1 s1 varchar(4);
-- should be ok 
insert into t1 values (1.123e1);
 
insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- FLOAT 1 : to VARNCHAR , enough precision
create table t1 (f1 float);
insert into t1 values (1),(-1.1),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change f1 s1 nchar varying(20);
-- should be ok 
insert into t1 values (1.123e1);

 
insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- FLOAT 2 : to VARCHAR , precision not specified, UNIQUE
create table t1 (f1 float unique);
insert into t1 values (1),(-1.1),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

-- should fail (unique)
insert into t1 values (-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change f1 s1 nchar varying unique;
-- should be ok 
insert into t1 values (n'12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- FLOAT 3 : to VARNCHAR , not enough precision
create table t1 (f1 float);
insert into t1 values (-112.1123),(1.1112e1);

-- should fail (range)
insert into t1 values (1e40);

select * from t1 order by 1;
show columns in t1;


alter table t1 change f1 s1 nchar varying(4);
-- should be ok 
insert into t1 values (1.123e1);


insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';



commit;
--+ holdcas off;
