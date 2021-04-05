-- check multiple range optimization with more than one column on a sigle table

drop table if exists u,t;
--+ holdcas on;

create table u (i bigint, j bigint) partition by hash(i) partitions 3;
insert into u values (3458901122 ,3458901122), (3458901122 ,3458901122), (3458901122 ,3);
insert into u values (-3458901122,1), (-3458901122,2), (-3458901122,3);
insert into u values (3,1), (3,2), (3,3);

create index i_u_i_j on u(i desc ,j desc);

create table t (i1 bigint, i2 decimal(15,1), i3 decimal(15,1)) partition by hash(i1) partitions 3;
create index idx1  on t(i1 desc , i2 );
create index idx2 on t(i1, i2 desc, i3);

insert into t values (0, 0, 00), (0, 1, 01), (0, 2, 02), (0, 3, 03), (0, 4, 04);
insert into t values (1, 0, 10), (1, 1, 11), (1, 2, 12), (1, 3, 13), (1, 4, 14);
insert into t values (2, 0, 20), (2, 1, 21), (2, 2, 22), (2, 3, 23), (2, 4, 24);
insert into t values (3, 0, 30), (3, 1, 31), (3, 2, 32), (3, 3, 33), (3, 4, 34);
insert into t values (3458901122, 3458901122, 40), (3458901122, 3458901122, 41), (3458901122, 3458901122, 42), (3458901122, 3458901122, 43), (3458901122, 3458901122, 44);

select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (3458901122,1,3) order by t.i2 + i3 + i1 desc,i limit 13;

select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (1,3) order by t.i2 + i3 + i1 asc,i limit 13;

select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (1,3) order by t.i2 ,i3 ,i limit 65536;

select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (3,1) order by t.i2 ,i3 desc,i limit 5;

PREPARE st  from
'select /*+ recompile */ t.i2,t.i3,u.i from t join u on t.i2 = u.i where t.i1 in (3,1) order by t.i2 desc ,i3 desc,i limit ?';

EXECUTE st USING 4;  

drop u,t;

commit;
--+ holdcas off;
