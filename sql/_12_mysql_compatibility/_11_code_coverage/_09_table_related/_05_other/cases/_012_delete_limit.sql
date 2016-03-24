-- DELETE  ... LIMIT
create table t1 (i1 integer);

insert into t1 values (1),(2),(3),(2),(2),(6),(7),(3);
select * from t1 order by i1;

delete from t1 where i1=1 limit 1;
select * from t1 order by i1  limit 5;

delete from t1 where i1 > 6 limit 1;
select * from t1 order by i1 limit 5;

delete from t1 where inst_num() < 2 limit 2;
select * from t1 order by i1 limit 5;

delete from t1  where current of a limit 2;
select * from t1 order by i1 limit 5;

drop table t1;
