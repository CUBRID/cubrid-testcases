/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  When the build input of a hash join exceeds max_hash_list_scan_size, the hash join splits both inputs into
 *  partitions by the hash. The change makes the serial split and the parallel split pick a partition with one function,
 *  and an OUTER JOIN that fills NULLs keeps NULL keys in the last partition. For each key, the hash join without split,
 *  with the serial split, and with the parallel split must return the counts of the merge join: the verification block
 *  after each hash join prints PASS when the hash join and the merge join return the same rows as a multiset. SHOW
 *  TRACE shows no SPLIT, SPLIT, and SPLIT with parallel workers in HASHJOIN.
 *
 *  Coverage:
 *    Case 1:  INT and BIGINT - hash join without split, with the serial split, and with the parallel split returns the
 *             counts of the merge join
 *    Case 2:  NUMERIC of two scales - hash join without split, with the serial split, and with the parallel split
 *             returns the counts of the merge join
 *    Case 3:  DOUBLE and INT - hash join without split, with the serial split, and with the parallel split returns the
 *             counts of the merge join
 *    Case 4:  utf8_en_ci strings - hash join without split, with the serial split, and with the parallel split returns
 *             the counts of the merge join
 *    Case 5:  two columns - hash join without split, with the serial split, and with the parallel split returns the
 *             counts of the merge join
 *    Case 6:  LEFT OUTER JOIN of INT and BIGINT - hash join without split, with the serial split, and with the parallel
 *             split returns the counts of the merge join
 *    Case 7:  LEFT OUTER JOIN of utf8_en_ci strings - hash join without split, with the serial split, and with the
 *             parallel split returns the counts of the merge join
 *    Case 8:  LEFT OUTER JOIN of two columns - hash join without split, with the serial split, and with the parallel
 *             split returns the counts of the merge join
 *    Case 9:  RIGHT OUTER JOIN of INT and BIGINT - hash join without split, with the serial split, and with the
 *             parallel split returns the counts of the merge join
 *    Case 10: RIGHT OUTER JOIN of utf8_en_ci strings - hash join without split, with the serial split, and with the
 *             parallel split returns the counts of the merge join
 *    Case 11: RIGHT OUTER JOIN of two columns - hash join without split, with the serial split, and with the parallel
 *             split returns the counts of the merge join
 */

set trace on;

-- The cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), to run serially,
-- and parallel(4) to run the parallel split. The trace of parallel(4) holds parallel workers lines.
-- test_mode=yes of CTP lowers the page threshold of a parallel hash join to 2 pages, which the join
-- inputs of this data pass, and parallel(4) needs a server with 3 or more cores

-- 3000 and 2500 rows: with max_hash_list_scan_size=8K the hash join splits the inputs into
-- partitions, and with the default (8M) it does not. Some keys of each table are NULL
DROP TABLE IF EXISTS t_right, t_left;
CREATE TABLE t_left (ca INT, cb NUMERIC(10,1), cc DOUBLE, cd VARCHAR(20) COLLATE utf8_en_ci);
CREATE TABLE t_right (ca BIGINT, cb NUMERIC(12,3), cc INT, cd VARCHAR(20) COLLATE utf8_en_ci);

-- t_left, ROWNUM r = 1 to 3000: the keys repeat every 1500 rows, ca is NULL where r is a multiple of 97,
-- and cd is NULL where r is a multiple of 89
-- r    | ca   | cb    | cc   | cd
-- -----+------+-------+------+-------
-- 1    | 1    | 0.1   | 1    | 'Ab1'
-- 2    | 2    | 0.2   | 2    | 'Ab2'
-- 89   | 89   | 8.9   | 89   | NULL
-- 97   | NULL | 9.7   | 97   | 'Ab97'
-- 1500 | 0    | 0.0   | 0    | 'Ab0'
-- 1501 | 1    | 0.1   | 1    | 'Ab1'
INSERT INTO t_left
SELECT
  CASE WHEN MOD (ROWNUM, 97) = 0 THEN NULL ELSE MOD (ROWNUM, 1500) END,
  CAST (MOD (ROWNUM, 1500) / 10.0 AS NUMERIC(10,1)),
  MOD (ROWNUM, 1500),
  CASE WHEN MOD (ROWNUM, 89) = 0 THEN NULL ELSE 'Ab' || TO_CHAR (MOD (ROWNUM, 1500)) END
FROM db_class a, db_class b, db_class c
LIMIT 3000;

-- t_right, ROWNUM r = 1 to 2500: the keys are MOD (r * 7, 2000) and repeat every 2000 rows, ca is NULL where r is
-- a multiple of 83, and cd is NULL where r is a multiple of 79
-- r    | ca   | cb     | cc   | cd
-- -----+------+--------+------+--------
-- 1    | 7    | 0.700  | 7    | 'aB7'
-- 2    | 14   | 1.400  | 14   | 'aB14'
-- 79   | 553  | 55.300 | 553  | NULL
-- 83   | NULL | 58.100 | 581  | 'aB581'
-- 286  | 2    | 0.200  | 2    | 'aB2'
-- 2001 | 7    | 0.700  | 7    | 'aB7'
INSERT INTO t_right
SELECT
  CASE WHEN MOD (ROWNUM, 83) = 0 THEN NULL ELSE MOD (ROWNUM * 7, 2000) END,
  CAST (MOD (ROWNUM * 7, 2000) / 10.0 AS NUMERIC(12,3)),
  MOD (ROWNUM * 7, 2000),
  CASE WHEN MOD (ROWNUM, 79) = 0 THEN NULL ELSE 'aB' || TO_CHAR (MOD (ROWNUM * 7, 2000)) END
FROM db_class a, db_class b, db_class c
LIMIT 2500;

UPDATE STATISTICS ON t_left, t_right WITH FULLSCAN;

evaluate 'Case 1: INT and BIGINT - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: NUMERIC of two scales - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cb = t_right.cb;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cb = t_right.cb;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cb = t_right.cb;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cb = t_right.cb;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cb = t_right.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: DOUBLE and INT - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cc = t_right.cc;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cc = t_right.cc;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cc = t_right.cc;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cc = t_right.cc;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cc = t_right.cc)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 4: utf8_en_ci strings - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 5: two columns - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left, t_right WHERE t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 6: LEFT OUTER JOIN of INT and BIGINT - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 7: LEFT OUTER JOIN of utf8_en_ci strings - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 8: LEFT OUTER JOIN of two columns - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left LEFT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 9: RIGHT OUTER JOIN of INT and BIGINT - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 10: RIGHT OUTER JOIN of utf8_en_ci strings - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 11: RIGHT OUTER JOIN of two columns - hash join without split, with the serial split, and with the parallel split returns the counts of the merge join';
set system parameters 'max_hash_list_scan_size=default';
select /*+ use_merge parallel(0) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;

select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

set system parameters 'max_hash_list_scan_size=8K';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

select /*+ use_hash parallel(4) */ count(*), count(t_right.ca), count(t_left.ca)
from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd;
show trace;

-- compare with the merge join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash parallel(4) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd),
  merge_rows as (select /*+ use_merge parallel(0) */ count(*) as cnt, count(t_right.ca) as cnt_right_ca, count(t_left.ca) as cnt_left_ca from t_left RIGHT OUTER JOIN t_right ON t_left.ca = t_right.ca AND t_left.cd = t_right.cd)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from merge_rows)
    union all
    (select * from merge_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
set system parameters 'max_hash_list_scan_size=default';

drop table if exists t_left, t_right;

set trace off;
