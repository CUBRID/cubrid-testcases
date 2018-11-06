drop table if exists t;

drop table if exists a;

create table t(i int, j int, k int) partition by hash (i) partitions 3;

create unique index u_t_i on t(i) with online;

create unique index u_t_j_k on t(i,j, k) with online;

insert into t select rownum, rownum, rownum from _db_class limit 15;

create table a (i int, s varchar(255));

insert into a select rownum, rownum from _db_class limit 15;

insert into t (j, k) select i+10, s from a on duplicate key update i = a.s+10, k = k+1, j = i;

drop a;

drop t;
