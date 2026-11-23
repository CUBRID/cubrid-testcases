/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  When the build input of a hash join exceeds max_hash_list_scan_size, the hash join splits both
 *  inputs into partitions by the hash. The change makes the serial split and the parallel split
 *  pick a partition with one function, and an OUTER JOIN that fills NULLs keeps NULL keys in the
 *  last partition. For each key, the hash join without split, with the serial split, and with the
 *  parallel split must return the counts of the merge join. SHOW TRACE shows no SPLIT, SPLIT, and
 *  SPLIT with parallel workers in HASHJOIN.
 *
 *  Coverage:
 *    Case 1:  int-bigint - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 2:  num-scale - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 3:  double-int - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 4:  ci-string - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 5:  two-col - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 6:  left-ci - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 7:  right-ci - hash join without split, with serial split, and with parallel split matches merge join
 *    Case 8:  left-2col - hash join without split, with serial split, and with parallel split matches merge join
 */

-- The cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), to run serially,
-- and parallel(4) to run the parallel split. The trace of parallel(4) holds parallel workers lines.
-- test_mode=yes of CTP lowers the page threshold of a parallel hash join to 2 pages, which the join
-- inputs of this data pass, and parallel(4) needs a server with 3 or more cores

-- 3000 and 2500 rows: with max_hash_list_scan_size=8K the hash join splits the inputs into
-- partitions, and with 64M it does not. Some keys of each table are NULL
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb NUMERIC(10,1), cc DOUBLE, cd VARCHAR(20) COLLATE utf8_en_ci);
CREATE TABLE tb (ca BIGINT, cb NUMERIC(12,3), cc INT, cd VARCHAR(20) COLLATE utf8_en_ci);
INSERT INTO ta
SELECT
  CASE WHEN MOD (ROWNUM, 97) = 0 THEN NULL ELSE MOD (ROWNUM, 1500) END,
  CAST (MOD (ROWNUM, 1500) / 10.0 AS NUMERIC(10,1)),
  MOD (ROWNUM, 1500),
  CASE WHEN MOD (ROWNUM, 89) = 0 THEN NULL ELSE 'Ab' || TO_CHAR (MOD (ROWNUM, 1500)) END
FROM db_class a, db_class b, db_class c
LIMIT 3000;
INSERT INTO tb
SELECT
  CASE WHEN MOD (ROWNUM, 83) = 0 THEN NULL ELSE MOD (ROWNUM * 7, 2000) END,
  CAST (MOD (ROWNUM * 7, 2000) / 10.0 AS NUMERIC(12,3)),
  MOD (ROWNUM * 7, 2000),
  CASE WHEN MOD (ROWNUM, 79) = 0 THEN NULL ELSE 'aB' || TO_CHAR (MOD (ROWNUM * 7, 2000)) END
FROM db_class a, db_class b, db_class c
LIMIT 2500;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: int-bigint - hash join without split, with serial split, and with parallel split matches merge join';
-- INT and BIGINT keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca;
show trace;
set trace off;

evaluate 'Case 2: num-scale - hash join without split, with serial split, and with parallel split matches merge join';
-- NUMERIC keys of different scales
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cb = tb.cb;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cb = tb.cb;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cb = tb.cb;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cb = tb.cb;
show trace;
set trace off;

evaluate 'Case 3: double-int - hash join without split, with serial split, and with parallel split matches merge join';
-- DOUBLE and INT keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cc = tb.cc;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cc = tb.cc;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cc = tb.cc;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cc = tb.cc;
show trace;
set trace off;

evaluate 'Case 4: ci-string - hash join without split, with serial split, and with parallel split matches merge join';
-- utf8_en_ci string keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cd = tb.cd;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cd = tb.cd;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cd = tb.cd;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.cd = tb.cd;
show trace;
set trace off;

evaluate 'Case 5: two-col - hash join without split, with serial split, and with parallel split matches merge join';
-- two-column keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca AND ta.cd = tb.cd;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta, tb WHERE ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta, tb WHERE ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta, tb WHERE ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;

evaluate 'Case 6: left-ci - hash join without split, with serial split, and with parallel split matches merge join';
-- LEFT OUTER JOIN on string keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta LEFT OUTER JOIN tb ON ta.cd = tb.cd;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta LEFT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta LEFT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta LEFT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;

evaluate 'Case 7: right-ci - hash join without split, with serial split, and with parallel split matches merge join';
-- RIGHT OUTER JOIN on string keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta RIGHT OUTER JOIN tb ON ta.cd = tb.cd;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta RIGHT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta RIGHT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta RIGHT OUTER JOIN tb ON ta.cd = tb.cd;
show trace;
set trace off;

evaluate 'Case 8: left-2col - hash join without split, with serial split, and with parallel split matches merge join';
-- LEFT OUTER JOIN on two-column keys
set system parameters 'max_hash_list_scan_size=64M';
select /*+ use_merge parallel(0) */ count(*), count(tb.ca), count(ta.ca) from ta LEFT OUTER JOIN tb ON ta.ca = tb.ca AND ta.cd = tb.cd;
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta LEFT OUTER JOIN tb ON ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;
set system parameters 'max_hash_list_scan_size=8K';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(tb.ca), count(ta.ca)
from ta LEFT OUTER JOIN tb ON ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;
set trace on;
select /*+ use_hash parallel(4) */ count(*), count(tb.ca), count(ta.ca) from ta LEFT OUTER JOIN tb ON ta.ca = tb.ca AND ta.cd = tb.cd;
show trace;
set trace off;

-- cleanup
set trace off;
set system parameters 'max_hash_list_scan_size=default';

drop table if exists ta, tb;
