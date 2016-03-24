--+ holdcas on;
---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- type change from int

-- int to short
create table t1 class attribute (c_i integer)  ( i integer ) ;

insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i c_s short;

select class t1.c_s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- int to float
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i c_f float;

select class t1.c_f, i from t1 order by 1,2;

show columns in t1;

drop table t1;




-- int to date
-- unsupported 
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i d date;

select class t1.c_i, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- int to varchar
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i s varchar(10);

select class t1.s, i from t1 order by 1,2;

show columns in t1;

drop table t1;


-- int to varchar, value too big
-- STRICT OR PERMISSIVE ALTER CHANGE MODE should not apply for CLASS ATTRIBUTE
-- this should fail according to cast
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=123456;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i s varchar(5);

select class t1.s, i from t1 order by 1,2;

show columns in t1;

drop table t1;



-- int to varchar, value too big , strict_mode
-- STRICT MODE should not apply for CLASS ATTRIBUTE
set system parameters 'alter_table_change_type_strict=yes';
set system parameters 'error_log_level=warning';
set system parameters 'error_log_warning=yes';


create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=123456;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

alter table t1 change class attribute c_i s varchar(5);

select class t1.s, i from t1 order by 1,2;

show columns in t1;

drop table t1;

set system parameters 'alter_table_change_type_strict=no';

commit;
--+ holdcas off;
