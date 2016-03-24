--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : DOUBLE to VARCHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- DOUBLE 1 : to VARCHAR , enough precision
create table t1 (d1 double);
insert into t1 values (1),(-1.1),(1.1112e1);


insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change d1 s1 varchar(20);
 
insert into t1 values (1.123e1);

 
insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- DOUBLE 2 : to VARCHAR , precision not specified, UNIQUE
create table t1 (d1 double unique);
insert into t1 values (1),(-1.1),(1.1112e1);


insert into t1 values (1e200);


insert into t1 values (-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change d1 s1 varchar unique;
 
insert into t1 values ('12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- DOUBLE 3 : to VARCHAR , not enough precision
create table t1 (d1 double);
insert into t1 values (123123.123123),(-123123.123123);


insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change d1 s1 varchar(4);
 
insert into t1 values (1.123e1);

 
insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- DOUBLE 1 : to VARNCHAR , enough precision
create table t1 (d1 double);
insert into t1 values (1),(-1.1),(1.1112e1);


insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change d1 s1 nchar varying(20);
 
insert into t1 values (1.123e1);

 
insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- DOUBLE 2 : to VARCHAR , precision not specified, UNIQUE
create table t1 (d1 double unique);
insert into t1 values (1),(-1.1),(1.1112e1);


insert into t1 values (1e200);


insert into t1 values (-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change d1 s1 nchar varying unique;
 
insert into t1 values (n'12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- DOUBLE 3 : to VARNCHAR , not enough precision
create table t1 (d1 double);
insert into t1 values (1231.434),(-1231.434);


insert into t1 values (1e200);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change d1 s1 nchar varying(4);
 
insert into t1 values (1.123e1);

 
insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

