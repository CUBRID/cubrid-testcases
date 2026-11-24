/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A JSON integer compares with a DOUBLE or a numeric string by their values, so 9007199254740993 (2^53 + 1) no longer
 *  equals 9007199254740992.0 (2^53), and a JSON integer hashes as it compares. Before the change, the integer converted
 *  to DOUBLE, which rounds above 2^53. The hash join of such keys must return the pairs of its nested loop join twin.
 *  The verification block after each join prints PASS when the join and its twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63
 *    Case 2:  JSON - an integer and the string "nan", "inf" or 2^63 compare as through DOUBLE
 *    Case 3:  JSON - hash join of an integer and a DOUBLE or a numeric string returns the pairs of the nested loop join
 *    Case 4:  JSON - hash join of an integer and the string "nan", "inf" or 2^63 returns the pairs of the nested loop
 *             join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_json_a;
CREATE TABLE t_json_a (id INT, left_body JSON, right_body JSON);

-- a JSON integer against a DOUBLE or a numeric string at 2^53 and 2^63, and against a fraction
-- id | left_body            | right_body             | note
-- ---+----------------------+------------------------+---------------------------------------------------
-- 1  | 9007199254740993     | 9007199254740992.0     | 2^53 + 1 and 2^53
-- 2  | 9007199254740992     | 9007199254740992.0     | 2^53 and 2^53
-- 3  | 9007199254740993     | "9007199254740993"     | the string converts to the DOUBLE 2^53
-- 4  | -9007199254740993    | -9007199254740992.0    | -(2^53 + 1) and -2^53
-- 5  | 9223372036854775807  | 9223372036854775807.0  | 2^63 - 1, the greatest BIGINT, and the DOUBLE 2^63
-- 6  | -9223372036854775808 | -9223372036854775808.0 | -2^63, the least BIGINT, and the DOUBLE -2^63
-- 7  | 2                    | 1.5                    | the fraction decides
-- 8  | -2                   | -1.5                   | the fraction decides
INSERT INTO t_json_a VALUES
  (1, '9007199254740993', '9007199254740992.0'),
  (2, '9007199254740992', '9007199254740992.0'),
  (3, '9007199254740993', '"9007199254740993"'),
  (4, '-9007199254740993', '-9007199254740992.0'),
  (5, '9223372036854775807', '9223372036854775807.0'),
  (6, '-9223372036854775808', '-9223372036854775808.0'),
  (7, '2', '1.5'),
  (8, '-2', '-1.5');

DROP TABLE IF EXISTS t_json_b;
CREATE TABLE t_json_b (id INT, left_body JSON, right_body JSON);

-- "nan" reads as the DOUBLE NaN, which has no BIGINT; "inf", "-inf" and 2^63 lie outside the BIGINT range
-- id | left_body            | right_body
-- ---+----------------------+-----------------------
-- 1  | 1                    | "nan"
-- 2  | -9223372036854775808 | "nan"
-- 3  | 9223372036854775807  | "NaN"
-- 4  | 1                    | "inf"
-- 5  | 1                    | "-inf"
-- 6  | 9223372036854775807  | "9223372036854775808"
-- 7  | -9223372036854775808 | "-9223372036854775808"
INSERT INTO t_json_b VALUES
  (1, '1', '"nan"'),
  (2, '-9223372036854775808', '"nan"'),
  (3, '9223372036854775807', '"NaN"'),
  (4, '1', '"inf"'),
  (5, '1', '"-inf"'),
  (6, '9223372036854775807', '"9223372036854775808"'),
  (7, '-9223372036854775808', '"-9223372036854775808"');

evaluate 'Case 1: JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63';
SELECT id,
  CASE WHEN left_body = right_body THEN 'eq' WHEN left_body < right_body THEN 'lt'
    WHEN left_body > right_body THEN 'gt' END cmp
FROM t_json_a ORDER BY 1;

evaluate 'Case 2: JSON - an integer and the string "nan", "inf" or 2^63 compare as through DOUBLE';
SELECT id,
  CASE WHEN left_body = right_body THEN 'eq' WHEN left_body < right_body THEN 'lt'
    WHEN left_body > right_body THEN 'gt' END cmp
FROM t_json_b ORDER BY 1;

evaluate 'Case 3: JSON - hash join of an integer and a DOUBLE or a numeric string returns the pairs of the nested loop join';
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.id, b.id
FROM t_json_a a, t_json_a b WHERE a.left_body = b.right_body ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.id as a_id, b.id as b_id FROM t_json_a a, t_json_a b WHERE a.left_body = b.right_body),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ a.id as a_id, b.id as b_id FROM t_json_a a, t_json_a b WHERE a.left_body = b.right_body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 4: JSON - hash join of an integer and the string "nan", "inf" or 2^63 returns the pairs of the nested loop join';
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.id, b.id
FROM t_json_b a, t_json_b b WHERE a.left_body = b.right_body ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.id as a_id, b.id as b_id FROM t_json_b a, t_json_b b WHERE a.left_body = b.right_body),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ a.id as a_id, b.id as b_id FROM t_json_b a, t_json_b b WHERE a.left_body = b.right_body)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_json_a, t_json_b;

set trace off;
