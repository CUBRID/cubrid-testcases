--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t (a int, b int, c int);
CREATE INDEX idx_ab ON t(a, b);

SELECT /*+ recompile */ a, b FROM t WHERE a = 0 ORDER BY a, b;

SELECT /*+ recompile */ a, b FROM t WHERE a = 0 GROUP BY a, b;

SELECT /*+ recompile */ a, b FROM t WHERE a = 0 ORDER BY 1,2;

SELECT /*+ recompile */ a, b FROM t WHERE a = 0 GROUP BY 1,2;
drop table t;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;


