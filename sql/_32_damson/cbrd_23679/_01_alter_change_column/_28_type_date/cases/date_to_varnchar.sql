---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATE
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';


-------------- DATE 1 : to varnchar, prec to small
create table t1 (d date);
insert into t1 values (date'2001-03-04');
insert into t1 values (date'1999-04-06');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 nchar varying(9);

-- should be ok:
insert into t1 values (date'2001-11-10');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATE 2 : to varnchar, prec enough
create table t1 (d date);
insert into t1 values (date'2001-03-04');
insert into t1 values (date'1999-04-06');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 nchar varying(10);

-- should be ok:
insert into t1 values (date'2001-11-10');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATE 3 : to varnchar, prec not specified
create table t1 (d date);
insert into t1 values (date'2001-03-04');
insert into t1 values (date'1999-04-06');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 nchar varying;

-- should be ok:
insert into t1 values (date'2001-11-10');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
