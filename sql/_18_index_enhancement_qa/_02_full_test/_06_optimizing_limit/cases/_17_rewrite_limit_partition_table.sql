--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
CREATE TABLE t (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
(PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
 
INSERT INTO t VALUES (1987, 'NZL', 3, 2, 8);
INSERT INTO t VALUES (1988, 'CAN', 3, 2, 5);
INSERT INTO t VALUES (1996, 'KOR', 7, 15, 5);
INSERT INTO t VALUES (2000, 'RUS', 32, 28, 28);
INSERT INTO t VALUES (2004, 'JPN', 16, 9, 12);

create index i_t_a on t(host_year);

set system parameters 'xasl_debug_dump=yes';

--should rewrite limit to keylimit
select /*+ recompile */ host_year from t where host_year>0 limit 1;

set system parameters 'xasl_debug_dump=no';

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
