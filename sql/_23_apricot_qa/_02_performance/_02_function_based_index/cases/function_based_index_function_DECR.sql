--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (i int, col2 DATE, col3 DATE);
--Test create index failed;
create index idx_col1 on t1(DECR(col1));
drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
