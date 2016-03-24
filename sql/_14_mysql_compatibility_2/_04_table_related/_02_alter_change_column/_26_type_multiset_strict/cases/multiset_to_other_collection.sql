--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : no constraints
-- ordering : no order defined
-- name : same name


set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

-------------- multiset 1 : to set
create table t1 (s1 multiset (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 set (varchar(10),int);
-- should be ok:
insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- multiset 2 : to sequence
create table t1 (s1 multiset (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 s1 sequence (varchar(10), int);

insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- multiset 3 : to sequence, with subtypes changed
create table t1 (s1 multiset (int,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;

alter table t1 change s1 s1 sequence (varchar(10),float);
-- should be ok:
insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;


-------------- multiset 4 : to sequence, with subtypes changed
create table t1 (s1 multiset (float,varchar(10)));
insert into t1 values ({1,'123'}),({'1234567890'}),({'abc',2}),({3});

select * from t1 order by 1;
show columns in t1;


alter table t1 change s1 s1 sequence (varchar(5), int);

insert into t1 values ({123,3.13});
select * from t1 order by 1;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';


commit;
--+ holdcas off;
