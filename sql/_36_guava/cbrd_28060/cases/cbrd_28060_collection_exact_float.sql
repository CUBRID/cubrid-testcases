/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A collection element compares with coercion. BIGINT and NUMERIC(24,4) elements of one value hash alike, so their
 *  hash join returns the pairs of its nested loop join twin. BIGINT or NUMERIC elements against DOUBLE elements compare
 *  through DOUBLE, which can hash apart from the exact value, so the planner joins them by nested loop under a hash
 *  join hint. SHOW TRACE shows which join runs. The verification block after each join prints PASS when the join and
 *  its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join
 *    Case 2:  MULTISET - BIGINT and DOUBLE elements join by nested loop, with the pairs of the nested loop join
 *    Case 3:  MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with the pairs of the nested loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- one value in three element types; 495038888524330534 has 18 digits, 9007199254740993 is 2^53 + 1
DROP TABLE IF EXISTS t_multiset_double, t_multiset_numeric, t_multiset_bigint;

CREATE TABLE t_multiset_bigint (ca INT, cb MULTISET (BIGINT));

-- ca | cb
-- ---+----------------------
-- 31 | {1}
-- 32 | {495038888524330534}
-- 33 | {9007199254740993}
INSERT INTO t_multiset_bigint VALUES (31, {1}), (32, {495038888524330534}), (33, {9007199254740993});

CREATE TABLE t_multiset_numeric (ca INT, cb MULTISET (NUMERIC (24, 4)));

-- the values of t_multiset_bigint
-- ca | cb
-- ---+---------------------------
-- 41 | {1.0000}
-- 42 | {495038888524330534.0000}
-- 43 | {9007199254740993.0000}
INSERT INTO t_multiset_numeric VALUES (41, {1.0000}), (42, {495038888524330534.0000}), (43, {9007199254740993.0000});

CREATE TABLE t_multiset_double (ca INT, cb MULTISET (DOUBLE));

-- ca 53 holds 2^53, the DOUBLE nearest to 2^53 + 1
-- ca | cb
-- ---+-------------------------
-- 51 | {1.0}
-- 52 | {495038888524330534.0}
-- 53 | {9007199254740992.0}
INSERT INTO t_multiset_double VALUES (51, {1.0}), (52, {495038888524330534.0}), (53, {9007199254740992.0});

UPDATE STATISTICS ON t_multiset_bigint, t_multiset_numeric, t_multiset_double WITH FULLSCAN;

evaluate 'Case 1: MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_bigint.ca, t_multiset_numeric.ca
FROM t_multiset_bigint, t_multiset_numeric WHERE t_multiset_bigint.cb = t_multiset_numeric.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_bigint.ca as t_multiset_bigint_ca, t_multiset_numeric.ca as t_multiset_numeric_ca FROM t_multiset_bigint, t_multiset_numeric WHERE t_multiset_bigint.cb = t_multiset_numeric.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_bigint.ca as t_multiset_bigint_ca, t_multiset_numeric.ca as t_multiset_numeric_ca FROM t_multiset_bigint, t_multiset_numeric WHERE t_multiset_bigint.cb = t_multiset_numeric.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: MULTISET - BIGINT and DOUBLE elements join by nested loop, with the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_bigint.ca, t_multiset_double.ca
FROM t_multiset_bigint, t_multiset_double WHERE t_multiset_bigint.cb = t_multiset_double.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_bigint.ca as t_multiset_bigint_ca, t_multiset_double.ca as t_multiset_double_ca FROM t_multiset_bigint, t_multiset_double WHERE t_multiset_bigint.cb = t_multiset_double.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_bigint.ca as t_multiset_bigint_ca, t_multiset_double.ca as t_multiset_double_ca FROM t_multiset_bigint, t_multiset_double WHERE t_multiset_bigint.cb = t_multiset_double.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_numeric.ca, t_multiset_double.ca
FROM t_multiset_numeric, t_multiset_double WHERE t_multiset_numeric.cb = t_multiset_double.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_numeric.ca as t_multiset_numeric_ca, t_multiset_double.ca as t_multiset_double_ca FROM t_multiset_numeric, t_multiset_double WHERE t_multiset_numeric.cb = t_multiset_double.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_numeric.ca as t_multiset_numeric_ca, t_multiset_double.ca as t_multiset_double_ca FROM t_multiset_numeric, t_multiset_double WHERE t_multiset_numeric.cb = t_multiset_double.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_multiset_bigint, t_multiset_numeric, t_multiset_double;

set trace off;
