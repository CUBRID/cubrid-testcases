---- ALTER TABLE ...  CHANGE COLUMN  
-- class attribute
-- name change

-- name collision : with a class attribute 
create table t1 class attribute (i1 integer)  ( i1 integer shared 0) ;
update t1 set class t1.i1=-1;
update t1 set t1.i1=-2;

show columns in t1;

alter table t1 change i1 i_1 integer;

show columns in t1;

alter table t1 change i_1 i1 integer;

show columns in t1;

drop table t1;

-- name collision : with a normal attribute 
create table t1 (i1 integer, i2 integer shared -1) ;
insert into t1 set i1=1;
update t1 set t1.i2=-10;

select i1, i2 from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i1 integer;

select i1, i2 from t1 order by 1,2;

show columns in t1;

drop table t1;


