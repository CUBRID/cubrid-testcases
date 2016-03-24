---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : no
-- ordering : change ordering
-- name : change or not
-- type : int , not type change 
-- other :



-- change name + after  : old name
create table t1 ( i1 integer, i2 integer , i3 integer);
insert into t1 values (1,11,111),(2,22,222),(3,33,333);
select * from t1 order by 1,2,3;
show columns in t1;

-- should fail
alter table t1 change i1 i2_b integer after i1;

select * from t1 order by 1,2,3;
show columns in t1;

drop table t1;


-- same name + after  : same attribute name
create table t1 ( i1 integer, i2 integer , i3 integer);
insert into t1 values (1,11,111),(2,22,222),(3,33,333);
select * from t1 order by 1,2,3;
show columns in t1;

-- should fail
alter table t1 change i1 i1 integer after i1;

select * from t1 order by 1,2,3;
show columns in t1;

drop table t1;



-- same name + after  : same attribute name
create table t1 ( i1 integer, i2 integer , i3 integer);
insert into t1 values (1,11,111),(2,22,222),(3,33,333);
select * from t1 order by 1,2,3;
show columns in t1;

-- should fail
alter table t1 modify i1 integer after i1;

select * from t1 order by 1,2,3;
show columns in t1;

drop table t1;




