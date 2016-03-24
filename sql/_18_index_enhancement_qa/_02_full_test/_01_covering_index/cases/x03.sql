--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(c1 int, c2 int, c3 int);
create index i_32 on t1(c3,c2);

insert into t1 values (null, null, null);
insert into t1 values (null, null, null);
insert into t1 values (null, 1, null);
insert into t1 values (null, 1, null);
insert into t1 values (null, 1, 1);
insert into t1 values (null, 1, 1);
insert into t1 values (null, 2, null);
insert into t1 values (null, 2, null);
insert into t1 values (null, 2, 2);
insert into t1 values (null, 2, 2);

--TEST: skipping order by is the best.
select /*+ recompile */ c3,c2 from t1 where c2>0 and c3 is not null order by c3, c2;
select /*+ recompile */ c3,c2 from t1 where c2>0 and c3 is not null;


drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
