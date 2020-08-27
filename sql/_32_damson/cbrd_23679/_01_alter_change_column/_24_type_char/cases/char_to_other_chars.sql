--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- char 1 : to varchar , prec increase
create table t1 (s1 char(10));
insert into t1 values ('1234567'),('abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 varchar(20);

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- char 2 : to varchar , prec decrease , useful chars don't need truncation
create table t1 (s1 char(10));
insert into t1 values ('1234567'),('abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 varchar(7);

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- char 3 : to varchar ,  prec decrease , truncation
create table t1 (s1 char(10));
insert into t1 values ('1234567'),('abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 varchar(5);

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;



-------------- char 4 : to nchar
create table t1 (s1 char(20));
insert into t1 values ('2010-10-10'),('abcde');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 i1 nchar(20);

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;

commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

set system parameters 'allow_truncated_string=no';
