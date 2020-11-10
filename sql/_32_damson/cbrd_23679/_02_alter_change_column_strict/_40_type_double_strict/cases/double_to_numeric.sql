--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change : DOUBLE to NUMERIC
-- constraints : no constraints
-- ordering : no order defined
-- name : same name or changed


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- DOUBLE 1 : to NUMERIC
create table t1 (d1 double);
insert into t1 values (1),(-1.1),(1e10);


select * from t1 order by 1;
show columns in t1;

alter table t1 change d1 n1 numeric(38,20);


insert into t1 values (1e41);

select * from t1  order by 1;
show columns in t1;

drop table t1;


-------------- DOUBLE 2 : to NUMERIC, overflow
create table t1 (d1 double);
insert into t1 values (-1.131231231e50),(1.131231231e50);



select * from t1 order by 1;
show columns in t1;


alter table t1 change d1 n1 numeric(38,20);

insert into t1 values (1e41);

select * from t1  order by 1;
show columns in t1;

drop table t1;




set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
