--TEST: [FilteredIndex] "create index on t1 (a) where NOT A IS NULL" should not be created successfully

drop table if exists t1;
create table t1(a int, b int);
--should fail
create index i1 on t1 (a) where a is null;


drop table if exists t2;
create table t2(a int, b int);
--test: should succeed
create index i2 on t2 (a) where not a is null;

drop table if exists t3;
create table t3(a int, b int);
--should succeed
create index i3 on t3 (a) where a is not null;

drop table if exists t4;
create table t4(a int, b int);
--test: should fail
create index i4 on t4 (a) where not a is not null;


drop table t1, t2, t3, t4;
