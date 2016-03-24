drop table if exists t1;

create table t1 (a int primary key, b int) partition by hash(a) partitions 2;
insert into t1 values(1,1),(2,2);
truncate t1;

drop table if exists t1;
