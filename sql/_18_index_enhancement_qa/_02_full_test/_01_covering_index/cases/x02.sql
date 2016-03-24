--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(c1 int, c2 int, c3 int);
create index i_2 on t1(c2);
create index i_23 on t1(c2,c3);

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

--TEST: current has no problem.
select /*+ recompile */ c2, count(c1) from t1 where c2>0 group by c2;
select /*+ recompile */ c2, count(c2) from t1 where c2>0 group by c2;
select /*+ recompile */ c2, count(c3) from t1 where c2>0 group by c2;

drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
