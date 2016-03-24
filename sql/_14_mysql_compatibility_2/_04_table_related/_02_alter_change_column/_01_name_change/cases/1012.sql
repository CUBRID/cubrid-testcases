---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : no
-- ordering : no order defined
-- name : change
-- type : int , not type change 
-- other :

-- name collision : with class attribute 
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

-- should be ok
alter table t1 change i c_i integer;

select class t1.c_i, c_i from t1 order by 1,2;
-- incomplete - confusing
show columns in t1;

drop table t1;


-- change a class attribute  
create table t1 class attribute (c_i integer)  ( i integer ) ;
insert into t1 values (1),(2);
update t1 set class t1.c_i=-1;

select class t1.c_i, i from t1 order by 1,2;
show columns in t1;

-- should fail
alter table t1 change c_i i integer;

-- should fail
alter table t1 change class c_i i integer;


-- should fail
alter table t1 change class t1.c_i i integer;

select class t1.c_i, i from t1 order by 1,2;
-- incomplete - confusing
show columns in t1;

drop table t1;






