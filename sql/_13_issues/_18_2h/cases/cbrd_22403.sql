drop table if exists t1;
create table t1(a int)
PARTITION BY RANGE (a)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));
create index i_a on t1(a);
insert into t1 values (null);
insert into t1 values (7);
insert into t1 values (9);
insert into t1 values (8);
insert into t1 values (17);
insert into t1 values (19);
insert into t1 values (18);
create table foo1 as WITH cte AS 
(
select /*+ recompile */ * from t1 where a is not null order by 1
)
select * from cte;

create table foo2 as WITH cte AS 
(
select /*+ recompile */ * from t1 where a is null and a is not null order by 1
)
select * from cte;
select * from foo1 order by 1;
select * from foo2 order by 1;
describe foo1;
describe foo2;

drop table if exists t1,foo1,foo2;
