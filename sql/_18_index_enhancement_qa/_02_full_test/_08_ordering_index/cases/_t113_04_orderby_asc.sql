--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b int, c int, d int,e int);

create index i_t_abc on t(a,b,c);
insert into t values (1,1,1,1,1);
insert into t values (2,2,2,2,2);
insert into t values (5,5,5,5,5);
insert into t values (null,null,null,null,null);

select /*+ recompile */ * from t where a>0 order by a,b,c;

select /*+ recompile */ * from t where a>0 order by a,b;

select /*+ recompile */ * from t where a>0 order by a,c;

select /*+ recompile */ * from t where a>0 order by a;

select /*+ recompile */ * from t where a>0 order by 1,2,3;

select /*+ recompile */ * from t where a>0 order by 1,2;

select /*+ recompile */ * from t where a>0 order by 1;

select /*+ recompile */ * from t where a>0 order by 0;

select /*+ recompile */ * from t where a>0 order by 4;

select /*+ recompile */ * from t where a>0 order by 1,3;

select /*+ recompile */ * from t where a>0 order by 1+0;

select /*+ recompile */ * from t where a>0 order by a, b desc;

select /*+ recompile */ * from t where a>0 order by a, a desc;

select /*+ recompile */ * from t where a>0 order by a||a;

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
