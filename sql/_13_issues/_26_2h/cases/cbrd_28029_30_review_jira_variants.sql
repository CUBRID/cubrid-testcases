/**
 *  This test case verifies CBRD-28029 (JIRA comments of 11-19 by shpark, after the review of PR #8609): #30 three variants of items 12 and 5.
 *  30-1..30-3: NOT BETWEEN over a BIGINT column with bound integer bounds compares as BIGINT (develop cast the column
 *  to DOUBLE, so values past 2^53 left the result), as BETWEEN does and as the literal form does.
 *  30-4..30-5: NULLIF (outer column, inner column) is the outer column when the NULL-padded column is NULL, so the
 *  term does not reject that row and the LEFT JOIN is kept (develop reduced it to an inner join and lost the rows).
 *  30-6..30-7: a correlated scalar subquery that reads the NULL-padded column only inside an OR has a value for the
 *  padded rows (the other branch is TRUE), so the outer join is kept, LEFT or RIGHT.
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t30b, t30o, t30i;
CREATE TABLE t30b (g BIGINT);
INSERT INTO t30b VALUES (1), (9223372036854775806), (9223372036854775807);
CREATE TABLE t30o (x INT);
CREATE TABLE t30i (a INT);
INSERT INTO t30o VALUES (1), (2);
INSERT INTO t30i VALUES (5);
PREPARE s30 FROM 'SELECT COUNT(*) FROM t30b WHERE NOT (g BETWEEN ? AND ?)';
-- expected: rows: 3
evaluate 'Case 30-1';
EXECUTE s30 USING 40, 9223372036854775805;
DEALLOCATE PREPARE s30;
PREPARE s30 FROM 'SELECT COUNT(*) FROM t30b WHERE g NOT BETWEEN ? AND ?';
-- expected: rows: 3
evaluate 'Case 30-2';
EXECUTE s30 USING 40, 9223372036854775805;
DEALLOCATE PREPARE s30;
-- expected: rows: 3
evaluate 'Case 30-3';
SELECT COUNT(*) FROM t30b WHERE NOT (g BETWEEN 40 AND 9223372036854775805);
-- expected: rows: 2
evaluate 'Case 30-4';
--@queryplan
SELECT COUNT(*) FROM t30o o LEFT OUTER JOIN t30i i ON i.a = -1 WHERE 0 <> NULLIF (o.x, i.a);
-- expected: rows: 2
evaluate 'Case 30-5';
--@queryplan
SELECT COUNT(*) FROM t30o o LEFT OUTER JOIN t30i i ON i.a = -1 WHERE NULLIF (o.x, i.a) > 0;
-- expected: rows: 2
evaluate 'Case 30-6';
SELECT COUNT(*) FROM t30o o LEFT JOIN t30i i ON i.a = -1 WHERE o.x <> (SELECT MAX (s.a) FROM t30i s WHERE i.a > s.a OR s.a > 0);
-- expected: rows: 2
evaluate 'Case 30-7';
SELECT COUNT(*) FROM t30i i RIGHT JOIN t30o o ON i.a = -1 WHERE o.x <> (SELECT MAX (s.a) FROM t30i s WHERE i.a > s.a OR s.a > 0);
DROP TABLE t30b, t30o, t30i;
