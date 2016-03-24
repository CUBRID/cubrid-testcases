-- UPDATE  ... SET  =DEFAULT

create table t1 (i1 integer default 0);
insert into t1 values(1),(2),(3);
select * from t1 order by 1;

-- should fail
update into t1 set i1=default;

update t1 set t1.i1=default;

drop table t1;
