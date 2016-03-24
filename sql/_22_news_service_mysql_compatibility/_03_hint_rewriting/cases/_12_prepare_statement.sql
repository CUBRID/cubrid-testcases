create table t1 (a int, b int, c int, d int);
create index i1_a on t1(a);
create index i1_ab on t1(a, b);

insert into t1 values (1,1,1,1), (2,2,2,2);

PREPARE st FROM 'select /*+ recompile */ * from t1 use index (i1_a) where a>?';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;


PREPARE st FROM 'select /*+ recompile */ * from t1 force index (i1_a) where a>?';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;


PREPARE st FROM 'select /*+ recompile */ * from t1 ignore index (i1_a) where a>?';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;


PREPARE st FROM 'select /*+ recompile */ * from t1 use index (i1_a) where a>? using index i1_a';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;


PREPARE st FROM 'select /*+ recompile */ * from t1 force index (i1_a) where a>? using index i1_a';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;


PREPARE st FROM 'select /*+ recompile */ * from t1 ignore index (i1_a) where a>? using index i1_a';
EXECUTE st USING 0;
EXECUTE st USING 1;
DEALLOCATE PREPARE st;

drop table t1;



