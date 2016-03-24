---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : no
-- ordering : change ordering
-- name : change or not
-- type : int , not type change 
-- other :

-- change name + first
create table t1 ( i1 integer, i2 integer );
insert into t1 values (1,11),(2,22),(3,33);
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i0 integer first;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- change name + after
create table t1 ( i1 integer, i2 integer , i3 integer);
insert into t1 values (1,11,111),(2,22,222),(3,33,333);
select * from t1 order by 1,2,3;
show columns in t1;

alter table t1 change i1 i2_b integer after i2;

select * from t1 order by 1,2,3;
show columns in t1;

drop table t1;



-- same  name + first
create table t1 ( i1 integer, i2 integer );
insert into t1 values (1,11),(2,22),(3,33);
select * from t1 order by 1,2;
show columns in t1;

alter table t1 change i2 i2 integer first;

select * from t1 order by 1,2;
show columns in t1;

drop table t1;


-- same name + after
create table t1 ( i1 integer, i2 integer , i3 integer);
insert into t1 values (1,11,111),(2,22,222),(3,33,333);
select * from t1 order by 1,2,3;
show columns in t1;

alter table t1 change i1 i1 integer after i2;

select * from t1 order by 1,2,3;
show columns in t1;

drop table t1;






