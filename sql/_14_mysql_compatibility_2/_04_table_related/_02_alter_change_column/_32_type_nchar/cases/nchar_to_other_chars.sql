--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined


set system parameters 'alter_table_change_type_strict=no';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- nchar 1 : to varnchar , prec increase
create table t1 (s1 nchar(10));
insert into t1 values (n'1234567'),(n'abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 nchar varying(20);

insert into t1 values (n'12345678901234567890');

select * from t1 order by 1;
show columns in t1;

drop table t1;

-------------- nchar 2 : to varchar , prec decrease , useful chars don't need truncation
create table t1 (s1 nchar(10));
insert into t1 values (n'1234567'),(n'abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 nchar varying(7);

insert into t1 values (n'123');

select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- nchar 3 : to varnchar ,  prec decrease , truncation
create table t1 (s1 nchar(10));
insert into t1 values (n'1234567'),(n'abc');

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 sv1 nchar varying(5);

insert into t1 values (n'123');

select * from t1 order by 1;
show columns in t1;

drop table t1;



-------------- nchar 4 : to char, contains only compatible chars
create table t1 (s1 nchar(20));
insert into t1 values ('10:11:12'),('abcde');

select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change s1 i1 char(20);

insert into t1 values ('123');

select * from t1 order by 1;
show columns in t1;

drop table t1;

commit;
--+ holdcas off;

set system parameters 'error_log_level=syntax';
set system parameters 'error_log_warning=no';

