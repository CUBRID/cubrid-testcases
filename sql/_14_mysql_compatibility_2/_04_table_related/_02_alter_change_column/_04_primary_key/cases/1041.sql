---- ALTER TABLE ...  CHANGE COLUMN  , type change
-- constraints : constraints  : PRIMARY KEY
-- ordering : no order defined
-- name : same or different
-- type : same or different

--------------------- PRIMARY key
------- type the same,  PRIMARY not maintained
--- PK kept
create table t1 (d1 double primary key);
insert into t1 values (1.112),(1.123);

-- should fail
insert into t1 values (1.112);

select * from t1 order by 1;
show columns in t1;
-- should be OK
alter table t1 change d1 d1 double;

-- should fail
insert into t1 values (1.112);
select * from t1 order by 1;
show columns in t1;

drop table t1;




