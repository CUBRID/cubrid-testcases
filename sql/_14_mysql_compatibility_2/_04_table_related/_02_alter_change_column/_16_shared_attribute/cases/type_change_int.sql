--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- shared attribute
-- type change from int

-- int to short
create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 i_1 short;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- int to float
create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 f_1 float;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;




-- int to time
-- unsupported 
create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 t_1 time;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- int to varchar
create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 s_1 varchar(10);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- int to varchar, value too big
-- STRICT OR PERMISSIVE ALTER CHANGE MODE should not apply for SHARED ATTRIBUTE
-- this should fail according to cast
create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=123456;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 s_1 varchar(5);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- int to varchar, value too big , strict_mode
-- STRICT MODE should not apply for SHARED ATTRIBUTE
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';

create table t1 ( i1 integer shared 0, i2 integer) ;
insert into t1 values (1,1),(2,2);
update t1 set i1=123456;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i1 s_1 varchar(5);

select * from t1 order by 1,2;
show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
