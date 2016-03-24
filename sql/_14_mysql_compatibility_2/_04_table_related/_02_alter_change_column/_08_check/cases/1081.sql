---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : CHECK constraint present : 
-- ordering : no order defined
-- name : same name or different


-------------- check constraints , type changes, same name
create table t1 (i1 integer,i2 integer, check (i1=i2));

insert into t1 values (1,1),(2,2),(3,3),(212,212);
insert into t1 values (7,21);

select * from t1 order by 1,2;

alter table t1 change column i2 i_2 integer;

insert into t1 values(5,5);
insert into t1 values(521,-521);

select * from t1 order by 1,2;

drop table t1;




