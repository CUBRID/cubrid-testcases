/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  Collection elements that compare equal only with coercion, a VARCHAR element 1 and an INT element 1, hash apart, so
 *  the planner leaves the join of a VARCHAR and an INT multiset to the nested loop under a hash join hint, and the join
 *  returns the pairs of its nested loop join twin. SHOW TRACE shows which join runs. The verification block after each
 *  join prints PASS when the join and its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  MULTISET - VARCHAR and INT elements join by nested loop, with the pairs of the nested loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- {'1'} = {1}: the comparison coerces the elements, the element hash tells them apart
DROP TABLE IF EXISTS t_multiset_varchar, t_multiset_int;

CREATE TABLE t_multiset_varchar (ca INT, cb MULTISET (VARCHAR (10)));

-- ca | cb
-- ---+-----------
-- 61 | {'1'}
-- 62 | {'2'}
-- 63 | {'1', '2'}
INSERT INTO t_multiset_varchar VALUES (61, {'1'}), (62, {'2'}), (63, {'1', '2'});

CREATE TABLE t_multiset_int (ca INT, cb MULTISET (INT));

-- ca | cb
-- ---+-------
-- 71 | {1}
-- 72 | {3}
-- 73 | {2, 1}
INSERT INTO t_multiset_int VALUES (71, {1}), (72, {3}), (73, {2, 1});

UPDATE STATISTICS ON t_multiset_varchar, t_multiset_int WITH FULLSCAN;

evaluate 'Case 1: MULTISET - VARCHAR and INT elements join by nested loop, with the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca, t_multiset_int.ca
FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb = t_multiset_int.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb = t_multiset_int.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_multiset_varchar.ca as t_multiset_varchar_ca, t_multiset_int.ca as t_multiset_int_ca FROM t_multiset_varchar, t_multiset_int WHERE t_multiset_varchar.cb = t_multiset_int.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_multiset_varchar, t_multiset_int;

set trace off;
