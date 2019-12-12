drop table if exists t;
create table t (d date);
create index idx1 on t (d) where d > 2;
alter table t add index idx1 (d) where d > 2;
drop table if exists t;
