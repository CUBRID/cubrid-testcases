drop table if exists t1;
create table t1(a int, b int, c int) PARTITION BY HASH (a) PARTITIONS 4;
insert into t1 values (1, 1, 1);
-- check whether crash for below:
create index i1 on t1(c) with online;

--@queryplan
select * from t1 where c>0;

drop table t1;
