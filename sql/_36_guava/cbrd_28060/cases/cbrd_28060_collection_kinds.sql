/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  SET, MULTISET and SEQUENCE keys compare across kinds: a SET keeps its elements sorted and once, a MULTISET compares
 *  sorted, a SEQUENCE in its order. A key of two collection kinds hashes in the domain of one, the other converted into
 *  it with its elements, and each hash join must return the pairs of its nested loop join twin. The verification block
 *  after each join prints PASS when the join and its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  SET, MULTISET and SEQUENCE across kinds - hash join of each pair of kinds returns the pairs of the nested
 *             loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- the elements compare with coercion; t_set_int.ca 1, 2 and 4 all hold {1, 2}, as a SET keeps its elements sorted and
-- once
DROP TABLE IF EXISTS t_set_int, t_sequence_int, t_sequence_numeric, t_multiset_int;

CREATE TABLE t_set_int (ca INT, cb SET (INT));

-- ca | cb
-- ---+----------
--  1 | {1, 2}
--  2 | {2, 1}
--  3 | {3}
--  4 | {1, 2, 2}
--  5 | {}
INSERT INTO t_set_int VALUES (1, {1, 2}), (2, {2, 1}), (3, {3}), (4, {1, 2, 2}), (5, {});

CREATE TABLE t_sequence_int (ca INT, cb SEQUENCE (INT));

-- ca | cb
-- ---+----------
-- 11 | {1, 2}
-- 12 | {2, 1}
-- 13 | {3}
-- 14 | {1, 2, 2}
-- 15 | {}
-- 16 | {1, 1, 2}
INSERT INTO t_sequence_int VALUES (11, {1, 2}), (12, {2, 1}), (13, {3}), (14, {1, 2, 2}), (15, {}), (16, {1, 1, 2});

CREATE TABLE t_sequence_numeric (ca INT, cb SEQUENCE (NUMERIC (10, 2)));

-- ca | cb
-- ---+-------------
-- 21 | {1.00, 2.00}
-- 22 | {2.00, 1.00}
-- 23 | {3.00}
-- 24 | {1.50}
INSERT INTO t_sequence_numeric VALUES (21, {1.00, 2.00}), (22, {2.00, 1.00}), (23, {3.00}), (24, {1.50});

CREATE TABLE t_multiset_int (ca INT, cb MULTISET (INT));

-- ca | cb
-- ---+----------
-- 31 | {1, 2}
-- 32 | {2, 1}
-- 33 | {1, 2, 2}
-- 34 | {1, 1, 2}
INSERT INTO t_multiset_int VALUES (31, {1, 2}), (32, {2, 1}), (33, {1, 2, 2}), (34, {1, 1, 2});

UPDATE STATISTICS ON t_set_int, t_sequence_int, t_sequence_numeric, t_multiset_int WITH FULLSCAN;

evaluate 'Case 1: SET, MULTISET and SEQUENCE across kinds - hash join of each pair of kinds returns the pairs of the nested loop join';
-- SET = SEQUENCE
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_sequence_int.ca
FROM t_set_int, t_sequence_int WHERE t_set_int.cb = t_sequence_int.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_sequence_int.ca as t_sequence_int_ca FROM t_set_int, t_sequence_int WHERE t_set_int.cb = t_sequence_int.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_sequence_int.ca as t_sequence_int_ca FROM t_set_int, t_sequence_int WHERE t_set_int.cb = t_sequence_int.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- SET = SEQUENCE (NUMERIC): the elements of two types as well
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_sequence_numeric.ca
FROM t_set_int, t_sequence_numeric WHERE t_set_int.cb = t_sequence_numeric.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_sequence_numeric.ca as t_sequence_numeric_ca FROM t_set_int, t_sequence_numeric WHERE t_set_int.cb = t_sequence_numeric.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_sequence_numeric.ca as t_sequence_numeric_ca FROM t_set_int, t_sequence_numeric WHERE t_set_int.cb = t_sequence_numeric.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- MULTISET = SEQUENCE
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_int.ca, t_sequence_int.ca
FROM t_multiset_int, t_sequence_int WHERE t_multiset_int.cb = t_sequence_int.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_int.ca as t_multiset_int_ca, t_sequence_int.ca as t_sequence_int_ca FROM t_multiset_int, t_sequence_int WHERE t_multiset_int.cb = t_sequence_int.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_int.ca as t_multiset_int_ca, t_sequence_int.ca as t_sequence_int_ca FROM t_multiset_int, t_sequence_int WHERE t_multiset_int.cb = t_sequence_int.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- SET = MULTISET
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_multiset_int.ca
FROM t_set_int, t_multiset_int WHERE t_set_int.cb = t_multiset_int.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_set_int, t_multiset_int WHERE t_set_int.cb = t_multiset_int.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_set_int, t_multiset_int WHERE t_set_int.cb = t_multiset_int.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_set_int, t_sequence_int, t_sequence_numeric, t_multiset_int;

set trace off;
