
drop table if exists u,t;
--+ holdcas on;

set system parameters 'dont_reuse_heap_file=yes';
create table u (i bigint, j short) partition by hash(i) partitions 3;
insert into u values (1,1), (1,2), (1,3);
insert into u values (2,1), (2,2), (2,3);
insert into u values (3,1), (3,2), (3,3);

create index i_u_i_j on u(i,j);

create table t (i1 bigint, i2 decimal(5,1), i3 decimal(5,1)) partition by hash(i1) partitions 3;
create index idx1  on t(i1, i2 desc);
create index idx2 on t(i1, i2 desc, i3);

insert into t values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);
insert into t values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into t values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into t values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
insert into t values (4, 0, 40), (4, 1, 41), (4, 2, 42), (4, 3, 43), (4, 4, 44);

update statistics on all classes;
select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (1,3) order by t.i2 desc,i3 desc,i limit 3;

update statistics on all classes;
select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (1,3) order by t.i2 desc,i3 desc,i limit 10000000;

update statistics on all classes;
select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (1,3) order by t.i2 ,i3 ,i limit 65536;

update statistics on all classes;
select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (3,1) order by t.i2 ,i3 desc,i limit 5;

update statistics on all classes;
PREPARE st  from
'select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (3,1) order by t.i2 desc ,i3 desc,i limit ?';

EXECUTE st USING 4;  

drop u,t;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
