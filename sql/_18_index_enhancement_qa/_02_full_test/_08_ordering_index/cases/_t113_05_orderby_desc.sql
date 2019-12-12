--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a int, b int, c int, d int,e int);

create index i_t_abc on t(a desc,b desc,c desc);
insert into t values (1,1,1,1,1);
insert into t values (2,2,2,2,2);
insert into t values (5,5,5,5,5);
insert into t values (null,null,null,null,null);

select /*+ recompile */ * from t where a>0 order by a desc,b desc,c desc;

select /*+ recompile */ * from t where a>0 order by a desc,b desc;

select /*+ recompile */ * from t where a>0 order by a desc,c desc;

select /*+ recompile */ * from t where a>0 order by a desc;

select /*+ recompile */ * from t where a>0 order by 1 desc,2 desc,3 desc;

select /*+ recompile */ * from t where a>0 order by 1 desc,2 desc;

select /*+ recompile */ * from t where a>0 order by 1 desc;

select /*+ recompile */ * from t where a>0 order by 0 desc;

select /*+ recompile */ * from t where a>0 order by 4 desc;

select /*+ recompile */ * from t where a>0 order by 1 desc,3 desc;

select /*+ recompile */ * from t where a>0 order by 1+0 desc;

select /*+ recompile */ * from t where a>0 order by a desc, b asc;

select /*+ recompile */ * from t where a>0 order by a desc, a asc;

select /*+ recompile */ * from t where a>0 order by a||a desc;

drop table t;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
