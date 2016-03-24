-- SELECT .. INCR

create table t1 ( i1 integer , i2 integer );

-- should fail
select incr(x);

drop table t1;
