--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t(a int unique not null,b int);
insert into t values(1,1);
insert into t values(2,2);
--test create index failed
create index my_index on t(a) where b>1;
insert into t values(2,2);
--test create index successfully
create index my_index on t(a desc) where b>1;
update statistics on t;
--TEST: Select using index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+) order by 1 desc;
--TEST: Select using index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+) order by 1;
--TEST: Select without index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+);
--TEST: Select using index u_t_a
SELECT /*+ recompile */ a from t where b>1 order by 1 desc;
--TEST: Select using u_t_a
SELECT /*+ recompile */ a from t where b>0 using index my_index(+),u_t_a order by 1;
Drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
