/**
 *  This test case verifies CBRD-28029 (found while analysing, fixed here on the user's decision 11-18): debug assertions on paths release lets
 *  through, and what they hide. INDEX_PREFIX of a NULL first operand (the evaluation does not fetch the other
 *  operands), BENCHMARK in a WHERE term (no rank for it), and BENCHMARK of a string or a column, which cleared the value
 *  it only peeked: a constant of the plan, or the value of the row that the select list reads after it.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t18;
CREATE TABLE t18 (id INT, s VARCHAR(10), n INT);
INSERT INTO t18 VALUES (1, NULL, NULL), (2, 'abc', 3);
-- expected: rows: 1 | 1 / 2 | 0
evaluate 'Case 18-1';
SELECT id, INDEX_PREFIX(s, 'abd', 'a') IS NULL AS np FROM t18 ORDER BY id;
-- expected: rows: 1
evaluate 'Case 18-2';
SELECT id FROM t18 WHERE INDEX_PREFIX(s, 'abd', 'a') IS NULL ORDER BY id;
-- expected: rows: 1 | 1 / 2 | 1
evaluate 'Case 18-3';
SELECT id, INDEX_PREFIX(s, NULL, 'a') IS NULL AS np FROM t18 ORDER BY id;
-- expected: rows: 'abd'
evaluate 'Case 18-4';
SELECT INDEX_PREFIX('abc', 'abd', 'a') AS ip FROM db_root;
-- expected: rows: 2
evaluate 'Case 18-5';
SELECT COUNT(*) AS cnt FROM t18 WHERE BENCHMARK(1, n) >= 0;
-- expected: rows: 1 / 2
evaluate 'Case 18-6';
SELECT id FROM t18 WHERE BENCHMARK(2, id) IS NOT NULL ORDER BY id;
-- expected: rows: 1
evaluate 'Case 18-7';
SELECT (BENCHMARK(3, 'x') >= 0) AS ok FROM db_root;
-- expected: rows: 1 | 1 | NULL / 2 | 1 | 'abc'
evaluate 'Case 18-8';
SELECT id, (BENCHMARK(2, s) >= 0) AS ok, s FROM t18 ORDER BY id;
-- expected: rows: 1 | 1 / 2 | 1
evaluate 'Case 18-9';
SELECT id, (BENCHMARK(2, CONCAT(s, 'z')) >= 0) AS ok FROM t18 ORDER BY id;
DROP TABLE t18;
