--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t(a int not null,b int);
insert into t values(1,1);
insert into t values(2,2);
create index my_index on t(a) where b>1;
--TEST: Select using index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+) order by 1 desc;
--TEST: Select using index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+) order by 1;
--TEST: Select with index my_index
SELECT /*+ recompile */ a from t where b>1 using index my_index(+);
--TEST: Select without index my_index
SELECT /*+ recompile */ a from t where b>1 order by 1 desc;
Drop table t;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
