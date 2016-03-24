--TEST: Index name of partition table could not been deleted directly. NOT A BUG

drop table if exists t1;

create table t1(a int)
PARTITION BY RANGE (a)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));
create index i_a on t1(a);

--[er]
drop index i_a on t1;
--[er]
drop index i_a on t1__p__before_10;

--succeed
drop index i_a on t1;
drop table t1;
