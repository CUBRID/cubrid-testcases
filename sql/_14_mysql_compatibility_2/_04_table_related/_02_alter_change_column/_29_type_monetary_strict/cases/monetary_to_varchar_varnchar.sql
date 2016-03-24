--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : MONETARY to VARCHAR
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- MONETARY 1 : to VARCHAR , enough precision
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1112e1);

select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 s1 varchar(20);

insert into t1 values (\1.123e1);

insert into t1 values ('abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;

-------------- MONETARY 2  : to VARCHAR , not enough precision
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1112e1);

select * from t1 order by 1;
show columns in t1;

 
alter table t1 change m1 s1 varchar(4);
 
insert into t1 values (\1.123e1);

insert into t1 values ('abcdef');

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- MONETARY 2 : to VARCHAR , precision not specified, UNIQUE
create table t1 (m1 monetary unique);
insert into t1 values (\1),(\-1.1),(\1.1112e1);


insert into t1 values (\-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 varchar unique;
 
insert into t1 values ('12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- MONETARY 1 : to VARNCHAR , enough precision
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1112e1);

select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 s1 nchar varying(20);
 
insert into t1 values (\1.123e1);

 
insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 2 : to VARNCHAR , not enough precision
create table t1 (m1 monetary);
insert into t1 values (\1),(\-1.1),(\1.1112e1);

select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 s1 nchar varying(4);
 
insert into t1 values (\1.123e1);

 
insert into t1 values (n'abcdef');
select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- MONETARY 3 : to VARCHAR , precision not specified, UNIQUE
create table t1 (m1 monetary unique);
insert into t1 values (\1),(\-1.1),(\1.1112e1);

-- should fail (unique)
insert into t1 values (\-1.1);

select * from t1 order by 1;
show columns in t1;

alter table t1 change m1 s1 nchar varying unique;

insert into t1 values (n'12345678901234567890');

select * from t1  order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
