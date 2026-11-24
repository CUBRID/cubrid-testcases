/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A SET OF a class holds OIDs, which the change hashes as it compares them. The hash join of SET OF a class keys must
 *  return the pairs of its nested loop join twin. The verification block after each join prints PASS when the join and
 *  its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  SET OF a class - hash join returns the pairs of the nested loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- t_set_object_a and t_set_object_b hold a set of one t_object object each:
-- t_set_object_a.ca 1 and t_set_object_b.ca 11 the object of ca 1, 2 and 12 of ca 2
DROP TABLE IF EXISTS t_set_object_a, t_set_object_b, t_object;
CREATE TABLE t_object (ca INT) DONT_REUSE_OID;
INSERT INTO t_object VALUES (1), (2);
CREATE TABLE t_set_object_a (ca INT, cb SET OF t_object);
CREATE TABLE t_set_object_b (ca INT, cb SET OF t_object);
INSERT INTO t_set_object_a SELECT x.ca, {x} FROM t_object x;
INSERT INTO t_set_object_b SELECT x.ca + 10, {x} FROM t_object x;
UPDATE STATISTICS ON t_set_object_a, t_set_object_b WITH FULLSCAN;

evaluate 'Case 1: SET OF a class - hash join returns the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_object_a.ca, t_set_object_b.ca
FROM t_set_object_a, t_set_object_b WHERE t_set_object_a.cb = t_set_object_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_object_a.ca as t_set_object_a_ca, t_set_object_b.ca as t_set_object_b_ca FROM t_set_object_a, t_set_object_b WHERE t_set_object_a.cb = t_set_object_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_object_a.ca as t_set_object_a_ca, t_set_object_b.ca as t_set_object_b_ca FROM t_set_object_a, t_set_object_b WHERE t_set_object_a.cb = t_set_object_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_object, t_set_object_a, t_set_object_b;

set trace off;
