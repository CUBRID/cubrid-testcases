/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A JSON integer compares with a DOUBLE or a numeric string by their values, so 9007199254740993 (2^53 + 1) no longer
 *  equals 9007199254740992.0 (2^53), and a JSON integer hashes as it compares. Before the change, the integer converted
 *  to DOUBLE, which rounds above 2^53. The hash join of such keys must return the pairs of its nested loop join twin.
 *
 *  Coverage:
 *    Case 1:  JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63
 *    Case 2:  JSON - hash join of an integer and a DOUBLE or a numeric string returns the pairs of the nested loop join
 *    Case 3:  JSON - an integer and the string "nan", "inf" or 2^63 compare as through DOUBLE
 *    Case 4:  JSON - hash join of an integer and the string "nan", "inf" or 2^63 returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- before the change the integer converted to DOUBLE, which rounds above 2^53
-- ca | cb                   | cc                     | note
-- ---+----------------------+------------------------+---------------------------------------------------
--  1 | 9007199254740993     | 9007199254740992.0     | 2^53 + 1 and 2^53
--  2 | 9007199254740992     | 9007199254740992.0     | 2^53 and 2^53
--  3 | 9007199254740993     | "9007199254740993"     | the string converts to the DOUBLE 2^53
--  4 | -9007199254740993    | -9007199254740992.0    | -(2^53 + 1) and -2^53
--  5 | 9223372036854775807  | 9223372036854775807.0  | 2^63 - 1, the greatest BIGINT, and the DOUBLE 2^63
--  6 | -9223372036854775808 | -9223372036854775808.0 | -2^63, the least BIGINT, and the DOUBLE -2^63
--  7 | 2                    | 1.5                    | the fraction decides
--  8 | -2                   | -1.5                   | the fraction decides
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb JSON, cc JSON);
INSERT INTO ta VALUES
  (1, '9007199254740993', '9007199254740992.0'),
  (2, '9007199254740992', '9007199254740992.0'),
  (3, '9007199254740993', '"9007199254740993"'),
  (4, '-9007199254740993', '-9007199254740992.0'),
  (5, '9223372036854775807', '9223372036854775807.0'),
  (6, '-9223372036854775808', '-9223372036854775808.0'),
  (7, '2', '1.5'),
  (8, '-2', '-1.5');

evaluate 'Case 1: JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63';
SELECT
  ca,
  CASE WHEN cb = cc THEN 'eq' WHEN cb < cc THEN 'lt' WHEN cb > cc THEN 'gt' END cmp
FROM ta
ORDER BY 1;

evaluate 'Case 2: JSON - hash join of an integer and a DOUBLE or a numeric string returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.ca, b.ca FROM ta a, ta b WHERE a.cb = b.cc ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ a.ca, b.ca FROM ta a, ta b WHERE a.cb = b.cc ORDER BY 1, 2;

-- "nan" reads as the DOUBLE NaN, which has no BIGINT; "inf", "-inf" and 2^63 lie outside the BIGINT range
-- ca | cb                   | cc
-- ---+----------------------+------------------------
--  1 | 1                    | "nan"
--  2 | -9223372036854775808 | "nan"
--  3 | 9223372036854775807  | "NaN"
--  4 | 1                    | "inf"
--  5 | 1                    | "-inf"
--  6 | 9223372036854775807  | "9223372036854775808"
--  7 | -9223372036854775808 | "-9223372036854775808"
DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb JSON, cc JSON);
INSERT INTO tb VALUES
  (1, '1', '"nan"'),
  (2, '-9223372036854775808', '"nan"'),
  (3, '9223372036854775807', '"NaN"'),
  (4, '1', '"inf"'),
  (5, '1', '"-inf"'),
  (6, '9223372036854775807', '"9223372036854775808"'),
  (7, '-9223372036854775808', '"-9223372036854775808"');

evaluate 'Case 3: JSON - an integer and the string "nan", "inf" or 2^63 compare as through DOUBLE';
SELECT
  ca,
  CASE WHEN cb = cc THEN 'eq' WHEN cb < cc THEN 'lt' WHEN cb > cc THEN 'gt' END cmp
FROM tb
ORDER BY 1;

evaluate 'Case 4: JSON - hash join of an integer and the string "nan", "inf" or 2^63 returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.ca, b.ca FROM tb a, tb b WHERE a.cb = b.cc ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ a.ca, b.ca FROM tb a, tb b WHERE a.cb = b.cc ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta;
DROP TABLE IF EXISTS tb;
