--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name


set system parameters 'allow_truncated_string=yes';
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- sequence 1 : to sequence
create table t1 (s1 set (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 sequence (varchar(10),int);
-- should be ok:
insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- set 2 : to multiset
create table t1 (s1 set (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 ms1 multiset (varchar(10), int);

insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- set 3 : to sequence, with subtypes changed
create table t1 (s1 set (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 sequence (varchar(10),float);
-- should be ok:
insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- set 4 : to multiset, with subtypes changed
create table t1 (s1 set (float,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 ms1 multiset (varchar(5), int);

insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;




set system parameters 'allow_truncated_string=no';
set system parameters 'alter_table_change_type_strict=yes';
commit;
--+ holdcas off;
