-- UPDATE  ... LIMIT
create table t1 (i1 integer);

insert into t1 values (1),(2),(3),(2),(2), (5), (5), (6), (7);

select * from t1 order by 1;

update t1 set i1=0 where i1<7 limit 1;

update t1 set i1=0 where i1>6 limit 1;

update t1 set i1=0 where inst_num() < 2 limit 2;  

update t1 set i1=0 where current of a limit 2;

--should fail
update t1 set i1=0 where i1 <3 group by i1 limit 2;


drop table t1;
