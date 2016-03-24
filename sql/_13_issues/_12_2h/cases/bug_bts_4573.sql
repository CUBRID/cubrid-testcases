--TEST:  Hint use_desc_idx doesn't work well in partition table. NOT A BUG

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

select /*+ recompile use_desc_idx */ * from t1 where a is not null order by 1 desc;


drop table t1;
