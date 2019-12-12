drop table if exists t__p__p0;
drop table if exists t;
create table t(i int primary key) partition by list(i) (partition p0 values in (1),partition p1 values in (2));
desc t__p__p0;
alter table t promote partition p0;
desc t__p__p0;
drop t__p__p0, t;
