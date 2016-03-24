---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : new constraints are gained  : UNIQUE KEY
-- ordering : no order defined
-- name : different names


------- type the same, gain UNIQUE, change name
create table t1 (d1 double);
insert into t1 values (1.112),(1.123);

-- should be OK
insert into t1 values (1.112);

select * from t1 order by 1;
show columns in t1;
-- should fail
alter table t1 change d1 d_1 double unique key;
-- should be OK
insert into t1 values (1.112);
select * from t1 order by 1;

show columns in t1;

drop table t1;



