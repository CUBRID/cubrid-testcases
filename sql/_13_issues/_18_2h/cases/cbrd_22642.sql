drop table if exists t1, t2;
CREATE TABLE t1 (i int);
create table t2 under t1(j int);
alter table t1 partition by range(i) (partition p0 values less than(10));
create unique index i1 on t1(i);
--test: cub_server crash for below
drop table t1;
drop table t2;
