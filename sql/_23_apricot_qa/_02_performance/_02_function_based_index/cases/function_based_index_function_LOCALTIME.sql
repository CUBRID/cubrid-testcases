--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t1 (col1 INTEGER, col2 DATE, col3 DATE);
--Test create index failed;
create index idx_col2 on t1(LOCALTIME());
drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
