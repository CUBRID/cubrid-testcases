--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : MONETARY to numbers
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed

set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


-------------- MONETARY 1 : to float, in range
create table t1 (m1 monetary);
insert into t1 values ($4.1),($200.2),(\3.3);

insert into t1 values (\12345678.12);
select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 f float;

insert into t1 values (12345678.12);
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- MONETARY 2 : to float, out of range 
create table t1 (m1 monetary);
insert into t1 values ($4.1),($200.2),(\3.3);

insert into t1 values (\12345678.12);

insert into t1 values (\2.212122e50);

select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 f float;

insert into t1 values (12345678.12);
select * from t1  order by 1;
show columns in t1;

drop table t1;



-------------- MONETARY 3 : to date
create table t1 (m1 monetary);
insert into t1 values ($4.1),($200.2),(\3.3);

insert into t1 values (\12345678.12);


select * from t1 order by 1;
show columns in t1;


alter table t1 change m1 d date;

insert into t1 values (12345678.12);
select * from t1  order by 1;
show columns in t1;

drop table t1;


set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
