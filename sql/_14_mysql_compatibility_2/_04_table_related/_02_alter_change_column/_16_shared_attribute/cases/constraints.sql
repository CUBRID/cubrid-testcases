--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- shared attribute
-- changing (adding) constraints :  NOT NULL , UNIQUE, PRIMARY KEY, AUTO_INCREMENT



-- NOT NULL
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer NOT NULL;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- NOT NULL with type change
create table t1  (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 bigint NOT NULL;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- adding NOT NULL with type change initial SHARED value is NULL
create table t1  (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 bigint NOT NULL;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;

-- STRICT MODE applies for SHARED ATTRIBUTE
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';
create table t1  (i1 integer shared NULL, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 bigint NOT NULL;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;
set system parameters 'alter_table_change_type_strict=no';

-- UNIQUE
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer UNIQUE;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;

-- PRIMARY KEY
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer primary key;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;


-- auto_increment
create table t1 (i1 integer shared 0, i2 integer) ;
insert into t1 set i2=1;
insert into t1 set i2=2;
update t1 set t1.i1=-1;

select t1.i1, i2 from t1 order by 2;
show columns in t1;

alter table t1 change i1 i1 integer auto_increment;

insert into t1 set i2=3;

select t1.i1, i2 from t1 order by 2;

show columns in t1;

drop table t1;
commit;
--+ holdcas off;
