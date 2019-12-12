--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t (a INTEGER);
insert into t values(1),(5),(10),(11),(12);
CREATE INDEX filter_t_a ON t (a) WHERE a > 10;
SELECT * FROM t WHERE a > 4 order by 1; 
SELECT * FROM t WHERE a > 11 using index filter_t_a order by 1;
drop table t;



set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
