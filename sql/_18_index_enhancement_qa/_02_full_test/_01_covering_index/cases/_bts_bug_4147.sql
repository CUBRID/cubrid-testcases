--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (a int,b int,c int);
create index i_ab on t1(a,b);
create index i_a on t1(a);
insert into t1 select rownum, rownum,rownum from db_class x1, db_class x2 limit 1000;

select /*+ recompile */ count(a) from t1 where a is not null;
--expect  use index i_a
select /*+ recompile */ count(a) from t1 where a>0;
--expect  use index i_a
select /*+ recompile */ count(a) from t1 where a is not null and a>0;
drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
