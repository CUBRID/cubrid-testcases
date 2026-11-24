/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A NUMERIC element without a precision keeps the scale of its value. Elements of one value and other scales ({1.5}
 *  and {1.50}) compare equal and must hash alike, so the hash join returns the pairs of its nested loop join twin. The
 *  verification block after each join prints PASS when the join and its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested
 *             loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_set_numeric_b, t_set_numeric_a;

CREATE TABLE t_set_numeric_a (ca INT, cb SET (NUMERIC));

-- t_set_numeric_a.ca | t_set_numeric_a.cb | t_set_numeric_b.ca | t_set_numeric_b.cb
-- -------------------+--------------------+--------------------+-------------------
-- 1                  | {1.5}              | 11                 | {1.50}
-- 2                  | {2}                | 12                 | {2.000}
INSERT INTO t_set_numeric_a VALUES (1, {1.5}), (2, {2});
CREATE TABLE t_set_numeric_b (ca INT, cb SET (NUMERIC));
INSERT INTO t_set_numeric_b VALUES (11, {1.50}), (12, {2.000});

evaluate 'Case 1: SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested loop join';
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_numeric_a.ca, t_set_numeric_b.ca
FROM t_set_numeric_a, t_set_numeric_b WHERE t_set_numeric_a.cb = t_set_numeric_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_numeric_a.ca as t_set_numeric_a_ca, t_set_numeric_b.ca as t_set_numeric_b_ca FROM t_set_numeric_a, t_set_numeric_b WHERE t_set_numeric_a.cb = t_set_numeric_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_numeric_a.ca as t_set_numeric_a_ca, t_set_numeric_b.ca as t_set_numeric_b_ca FROM t_set_numeric_a, t_set_numeric_b WHERE t_set_numeric_a.cb = t_set_numeric_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_set_numeric_a, t_set_numeric_b;

set trace off;
