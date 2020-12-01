---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name
-- type : DATETIME
set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';


-------------- DATETIME 1 : to varchar, prec to small
create table t1 (d datetime);
insert into t1 values (datetime'2001-03-04 11:12:13');
insert into t1 values (datetime'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 varchar(25);

-- should be ok:
insert into t1 values (datetime'2001-11-10 03:06:01');
-- should fail
insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATETIME 2 : to varchar, prec enough
create table t1 (d datetime);
insert into t1 values (datetime'2001-03-04 11:12:13');
insert into t1 values (datetime'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 varchar(26);

-- should be ok:
insert into t1 values (datetime'2001-11-10 03:06:01');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- DATETIME 3 : to varchar, prec not specified
create table t1 (d datetime);
insert into t1 values (datetime'2001-03-04 11:12:13');
insert into t1 values (datetime'1999-04-06 09:03:02');

select * from t1 order by 1;
show columns in t1;

alter table t1 change d s1 varchar;

-- should be ok:
insert into t1 values (datetime'2001-11-10 03:06:01');

insert into t1 values ('abc');

select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
