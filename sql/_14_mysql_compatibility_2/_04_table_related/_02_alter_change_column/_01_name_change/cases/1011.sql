---- ALTER TABLE ...  CHANGE COLUMN  
-- constraints : no
-- ordering : no order defined
-- name : change
-- type : int , not type change 
-- other :

-- no name collision 
create table t1 ( i integer );
insert into t1 values (11),(3112),(1000012),(1002000),(1090000),(21);
select * from t1 order by 1;
show columns in t1;

alter table t1 change i i1 integer;

select * from t1 order by 1;
show columns in t1;

drop table t1;



--name collision 
create table t1 ( i integer , i1 integer);
insert into t1 values (11,2),(3112,3),(1000012,5),(1002000,213),(1090000,12),(21,3);
select * from t1 order by 1;
show columns in t1;

-- should fail
alter table t1 change i i1 integer;

select * from t1 order by 1,2;
show columns in t1;


drop table t1;







