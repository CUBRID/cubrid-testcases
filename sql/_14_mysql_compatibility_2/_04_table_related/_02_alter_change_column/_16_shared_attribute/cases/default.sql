--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- changing default
-- DEFAULT value should be ignored

-- no default at creation (NULL)
create table t1 (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer default 5;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;

-- with default at creation + change
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer default 5;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- with default at creation + no default after change + type change
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 s1 varchar(10);

insert into t1 set i2=3;

select t1.s1, i2 from t1 order by 2;

show columns in t1;

drop table t1;

-- with no default at creation (NULL) + no default after change + type change
create table t1 (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 s1 varchar(10);

insert into t1 set i2=3;

select t1.s1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- with no default at creation (NULL) + no default after change + type change
-- STRICT MODE
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';
create table t1 (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 s1 varchar(10);

insert into t1 set i2=3;

select t1.s1, i2 from t1 order by 2;

show columns in t1;

drop table t1;
set system parameters 'alter_table_change_type_strict=no';




-- with no default at creation (NULL) + with  default after change + type change
create table t1 (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 s1 varchar(10) default 'abc';

insert into t1 set i2=3;

select t1.s1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- with no default at creation (NULL) + no default after change + type change
-- STRICT MODE
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';
create table t1 (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 s1 varchar(10) default 'abc';

insert into t1 set i2=3;

select t1.s1, i2 from t1 order by 2;

show columns in t1;

drop table t1;
set system parameters 'alter_table_change_type_strict=no';



commit;
--+ holdcas off;
