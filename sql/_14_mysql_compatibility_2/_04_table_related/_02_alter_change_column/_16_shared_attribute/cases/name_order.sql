---- ALTER TABLE ...  CHANGE COLUMN  
-- ordering : change ordering
-- name : change or not

-- change name + first
create table t1 (i1 integer, i2 integer shared -1);
insert into t1 values (1,10),(2,20);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i_1 integer first;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- change name + after
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i_1 integer after i3;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;



-- same  name + first
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i2 integer first;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- same name + after
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i2 integer after i3;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


------ ERROR cases : 

-- change name + after  : name of class attribute
create table t1 class attribute( i1 integer)  (i2 integer shared -1, i3 integer);
insert into t1 values (10,1),(20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i2 integer after i1;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- change name + after  : old name
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i_2 integer after i2;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- same name + after  : same attribute name
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i2 integer after i2;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;




-- MODIFY : same name + after  : same attribute name
create table t1 (i1 integer, i2 integer shared -1, i3 integer);
insert into t1 values (1,10,1),(2,20,2);
update t1 set t1.i2=-10;

select * from t1 order by 1,2;
show columns in t1;

-- should fail
alter table t1 modify i2 integer after i2;

select * from t1 order by 1,2;
show columns in t1;

drop table t1; 


 