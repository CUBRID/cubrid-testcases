/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A JSON object or array hashes as its body text, so keys of one body written with other spaces ({"a": 1} and {"a":1})
 *  get one hash, and a key of another body ({"a":1.0}) another. The verification blocks after the hash join and the
 *  hash GROUP BY print PASS when the hash query and its nested loop join or sort GROUP BY twin return the same rows as
 *  a multiset.
 *
 *  Coverage:
 *    Case 1:  JSON - hash join of t_json_a and t_json_b returns the pairs of the nested loop join
 *    Case 2:  JSON - hash GROUP BY on t_json_a returns the groups of the sort GROUP BY
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

DROP TABLE IF EXISTS t_json_b, t_json_a;
CREATE TABLE t_json_a (id INT, body JSON);

-- JSON keys of one table: equal texts, {"a": 1} and {"a":1} of one body, {"a":1.0} of another
-- id | body
-- ---+----------
-- 1  | {"a":1}
-- 2  | {"a":1}
-- 3  | [1,2]
-- 4  | "x"
-- 5  | "x"
-- 6  | true
-- 7  | NULL
-- 8  | {"a": 1}
-- 9  | {"a":1.0}
INSERT INTO t_json_a VALUES
  (1, '{"a":1}'),
  (2, '{"a":1}'),
  (3, '[1,2]'),
  (4, '"x"'),
  (5, '"x"'),
  (6, 'true'),
  (7, NULL),
  (8, '{"a": 1}'),
  (9, '{"a":1.0}');
CREATE TABLE t_json_b AS SELECT * FROM t_json_a;

UPDATE STATISTICS ON t_json_a, t_json_b WITH FULLSCAN;

evaluate 'Case 1: JSON - hash join of t_json_a and t_json_b returns the pairs of the nested loop join';
SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id, t_json_b.id
FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body AND t_json_a.id < t_json_b.id ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body AND t_json_a.id < t_json_b.id),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body AND t_json_a.id < t_json_b.id)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: JSON - hash GROUP BY on t_json_a returns the groups of the sort GROUP BY';
select min(id), count(*)
from t_json_a group by body order by 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select min(id) as min_id, count(*) as cnt from t_json_a group by body),
  sort_rows as (select /*+ no_hash_aggregate */ min(id) as min_id, count(*) as cnt from t_json_a group by body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- cleanup
set system parameters 'agg_hash_respect_order=default';

DROP TABLE IF EXISTS t_json_a, t_json_b;

set trace off;
