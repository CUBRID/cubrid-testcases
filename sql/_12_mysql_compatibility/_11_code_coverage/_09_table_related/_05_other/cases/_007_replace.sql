-- REPLACE  ... set 

create table t1 (i1 integer);

select * from t1;

replace t1 set i1=1;

-- should fail
replace t1 set i1_1=1;

select * from t1;

drop table t1;

