/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A JSON value compares as the SQL value it converts to: 1 equals 1.0, true equals "true", "0x10" equals 16, and an
 *  object compares by its body text. The change hashes a JSON key as it compares, and the hash join compares the key
 *  with coercion as the join term does. Before the change, the hash join missed pairs of equal JSON keys, so each hash
 *  join must return the pairs of its nested loop join twin, and the hash GROUP BY the groups of the sort GROUP BY. SHOW
 *  TRACE shows HASHJOIN. The verification block after each hash query prints PASS when the hash query and its twin
 *  return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  JSON - hash join returns the pairs of the nested loop join
 *    Case 2:  JSON - hash join with the other build side returns the pairs of the nested loop join
 *    Case 3:  JSON - hash GROUP BY returns the groups of the sort GROUP BY
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_json_b, t_json_a;
CREATE TABLE t_json_a (id INT, body JSON);

-- JSON values of t_json_a; t_json_b holds values that compare equal to some of them, and others
-- id | body
-- ---+------------------------------
-- 1  | 1
-- 2  | -0.0
-- 3  | true
-- 4  | "a"
-- 5  | [1, 2]
-- 6  | {"a": 1}
-- 7  | 1.5
-- 8  | 9007199254740993   (2^53 + 1)
-- 9  | 16
-- 10 | 0
-- 11 | null
INSERT INTO t_json_a VALUES
  (1, '1'),
  (2, '-0.0'),
  (3, 'true'),
  (4, '"a"'),
  (5, '[1, 2]'),
  (6, '{"a": 1}'),
  (7, '1.5'),
  (8, '9007199254740993'),
  (9, '16'),
  (10, '0'),
  (11, 'null');

CREATE TABLE t_json_b (id INT, body JSON);

-- id | body
-- ---+------------------------------------------------
-- 11 | 1.0
-- 12 | 0.0
-- 13 | "true"
-- 14 | "a"
-- 15 | [1,2]
-- 16 | {"a":1}
-- 17 | 1
-- 18 | "1.5"
-- 19 | "  1  "               (1 with spaces around it)
-- 20 | 9007199254740992.0   (2^53)
-- 21 | "0x10"               (16 in hexadecimal)
-- 22 | ""                   (the empty string)
-- 23 | "abc"
-- 24 | "A"
-- 25 | null
-- 26 | "[1,2]"              (a string, not an array)
INSERT INTO t_json_b VALUES
  (11, '1.0'),
  (12, '0.0'),
  (13, '"true"'),
  (14, '"a"'),
  (15, '[1,2]'),
  (16, '{"a":1}'),
  (17, '1'),
  (18, '"1.5"'),
  (19, '"  1  "'),
  (20, '9007199254740992.0'),
  (21, '"0x10"'),
  (22, '""'),
  (23, '"abc"'),
  (24, '"A"'),
  (25, 'null'),
  (26, '"[1,2]"');

UPDATE STATISTICS ON t_json_a, t_json_b WITH FULLSCAN;

evaluate 'Case 1: JSON - hash join returns the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id, t_json_b.id
FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_a, t_json_b WHERE t_json_a.body = t_json_b.body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: JSON - hash join with the other build side returns the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id, t_json_b.id
FROM t_json_b, t_json_a WHERE t_json_a.body = t_json_b.body ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_b, t_json_a WHERE t_json_a.body = t_json_b.body),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_json_a.id as t_json_a_id, t_json_b.id as t_json_b_id FROM t_json_b, t_json_a WHERE t_json_a.body = t_json_b.body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: JSON - hash GROUP BY returns the groups of the sort GROUP BY';
-- true and "true" (t_json_a.id 3, t_json_b.id 13) are left out: the sort GROUP BY tells them apart, the hash GROUP BY
-- does not, a difference that this change does not touch
DROP TABLE IF EXISTS t_json_ab;
CREATE TABLE t_json_ab AS SELECT * FROM t_json_a WHERE id <> 3 UNION ALL SELECT * FROM t_json_b WHERE id <> 13;

SELECT /*+ PARALLEL(0) */ MIN (id), COUNT (*)
FROM t_json_ab GROUP BY body ORDER BY 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (SELECT /*+ PARALLEL(0) */ MIN (id) as min_id, COUNT (*) as cnt FROM t_json_ab GROUP BY body),
  sort_rows as (SELECT /*+ NO_HASH_AGGREGATE */ MIN (id) as min_id, COUNT (*) as cnt FROM t_json_ab GROUP BY body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_json_a, t_json_b, t_json_ab;

set trace off;
