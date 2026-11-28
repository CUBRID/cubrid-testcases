/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A collection element compares with coercion. BIGINT and NUMERIC(24,4) elements of one value hash alike, so their
 *  hash join returns the pairs of its nested loop join twin. BIGINT or NUMERIC elements against DOUBLE elements compare
 *  through DOUBLE, which can hash apart from the exact value, so the planner joins them by nested loop under a hash
 *  join hint. SHOW TRACE shows which join runs. The verification block after each join prints PASS when the join and
 *  its twin return the same rows as a multiset.
 *
 *  Cases 4 and 5 run CONNECT BY NOCYCLE PRIOR id = pid, where id holds BIGINT elements and pid holds NUMERIC(24,4) or
 *  DOUBLE elements of the same values. The CONNECT BY follows these comparisons: it reaches every row and marks the
 *  cycle. The verification block prints PASS when it returns the rows of its twin without the hash list scan.
 *
 *  Coverage:
 *    Case 1:  MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join
 *    Case 2:  MULTISET - BIGINT and DOUBLE elements join by nested loop under a hash join hint, with the pairs of the
 *             nested loop join
 *    Case 3:  MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop under a hash join hint, with the pairs
 *             of the nested loop join
 *    Case 4:  MULTISET - CONNECT BY NOCYCLE of BIGINT and NUMERIC(24,4) elements returns the rows of the CONNECT BY
 *             without the hash list scan
 *    Case 5:  MULTISET - CONNECT BY NOCYCLE of BIGINT and DOUBLE elements returns the rows of the CONNECT BY without
 *             the hash list scan
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

evaluate 'Case 2: MULTISET - BIGINT and DOUBLE elements join by nested loop under a hash join hint, with the pairs of the nested loop join';
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

evaluate 'Case 3: MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop under a hash join hint, with the pairs of the nested loop join';
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

-- Cases 4 and 5 run CONNECT BY NOCYCLE PRIOR id = pid on a tree whose id holds BIGINT elements and whose pid holds
-- NUMERIC(24,4) or DOUBLE elements of the same values. Row 4 holds the id of row 1, so the children of row 4 are those
-- of row 1, and row 2 under row 4 is a cycle
DROP TABLE IF EXISTS t_multiset_tree_numeric, t_multiset_tree_double;
CREATE TABLE t_multiset_tree_numeric (ca INT, id MULTISET (BIGINT), pid MULTISET (NUMERIC (24, 4)));

-- ca | id                   | pid
-- ---+----------------------+---------------------------
--  1 | {1, 2}               | NULL
--  2 | {3}                  | {2.0000, 1.0000}
--  3 | {495038888524330534} | {3.0000}
--  4 | {1, 2}               | {495038888524330534.0000}
--  5 | {5}                  | {1.0000, 2.0000}
--  6 | {6}                  | {495038888524330534.0000}
INSERT INTO t_multiset_tree_numeric VALUES
  (1, {1, 2}, NULL),
  (2, {3}, {2.0000, 1.0000}),
  (3, {495038888524330534}, {3.0000}),
  (4, {1, 2}, {495038888524330534.0000}),
  (5, {5}, {1.0000, 2.0000}),
  (6, {6}, {495038888524330534.0000});

CREATE TABLE t_multiset_tree_double (ca INT, id MULTISET (BIGINT), pid MULTISET (DOUBLE));

-- the tree of t_multiset_tree_numeric with 2^53 + 1 in row 3: pid 2^53, the DOUBLE nearest to it, compares equal
-- ca | id                 | pid
-- ---+--------------------+-----------------------
--  1 | {1, 2}             | NULL
--  2 | {3}                | {2.0, 1.0}
--  3 | {9007199254740993} | {3.0}
--  4 | {1, 2}             | {9007199254740992.0}
--  5 | {5}                | {1.0, 2.0}
--  6 | {6}                | {9007199254740992.0}
INSERT INTO t_multiset_tree_double VALUES
  (1, {1, 2}, NULL),
  (2, {3}, {2.0, 1.0}),
  (3, {9007199254740993}, {3.0}),
  (4, {1, 2}, {9007199254740992.0}),
  (5, {5}, {1.0, 2.0}),
  (6, {6}, {9007199254740992.0});

UPDATE STATISTICS ON t_multiset_tree_numeric, t_multiset_tree_double WITH FULLSCAN;

evaluate 'Case 4: MULTISET - CONNECT BY NOCYCLE of BIGINT and NUMERIC(24,4) elements returns the rows of the CONNECT BY without the hash list scan';
SELECT ca, id, LEVEL, CONNECT_BY_ISCYCLE
FROM t_multiset_tree_numeric START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid ORDER BY 3, 1;
show trace;

-- compare with the CONNECT BY without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT ca, LEVEL as lvl, CONNECT_BY_ISCYCLE as cyc FROM t_multiset_tree_numeric START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid),
  listscan_rows as (SELECT /*+ NO_HASH_LIST_SCAN */ ca, LEVEL as lvl, CONNECT_BY_ISCYCLE as cyc FROM t_multiset_tree_numeric START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

evaluate 'Case 5: MULTISET - CONNECT BY NOCYCLE of BIGINT and DOUBLE elements returns the rows of the CONNECT BY without the hash list scan';
SELECT ca, id, LEVEL, CONNECT_BY_ISCYCLE
FROM t_multiset_tree_double START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid ORDER BY 3, 1;
show trace;

-- compare with the CONNECT BY without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT ca, LEVEL as lvl, CONNECT_BY_ISCYCLE as cyc FROM t_multiset_tree_double START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid),
  listscan_rows as (SELECT /*+ NO_HASH_LIST_SCAN */ ca, LEVEL as lvl, CONNECT_BY_ISCYCLE as cyc FROM t_multiset_tree_double START WITH ca = 1 CONNECT BY NOCYCLE PRIOR id = pid)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_multiset_bigint, t_multiset_numeric, t_multiset_double, t_multiset_tree_numeric,
  t_multiset_tree_double;

set trace off;
