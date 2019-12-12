create table t(i int) partition by hash(i) partitions 5;

alter table t partition (p0) add primary key pk_t_i (i);

create index i_t_i on t partition (p0) (i);

drop table t partition (p0);

alter table t partition (p0) partition by hash (i) partitions 3;

update statistics on t partition (p0);

drop table t;