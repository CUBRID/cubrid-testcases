/**
 *  This test case verifies CBRD-28029 (review of PR #8609, 11-19): #29 an operation not listed in the NULL judge is NULL when any operand is,
 *  so a term whose inner column is a later operand (SUBSTRING ('abc', i.n, 2), ROUND (1.55, i.a)) reduces an outer
 *  join and skips a sort by an index as develop does, an operation whose later operand is an option a NULL leaves
 *  at its default (WEEK (d, NULL), the ESCAPE of LIKE and of its bounds) or, under oracle_style_empty_string, REPLACE
 *  is not, so the row the outer join fills with NULL is kept where the term is TRUE on it (develop loses it).
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP TABLE IF EXISTS t29o, t29i;
CREATE TABLE t29o (id INT PRIMARY KEY);
CREATE TABLE t29i (id INT, n INT, a INT, b INT, s VARCHAR(10));
INSERT INTO t29o VALUES (1), (2), (3), (4);
INSERT INTO t29i VALUES (1, 2, 1, 1, 'x'), (2, 3, 2, 2, 'y'), (3, 0, 3, 3, 'z');
CREATE INDEX i29_ab ON t29i (a, b);
CREATE INDEX i29_id ON t29i (id);
UPDATE STATISTICS ON t29o, t29i WITH FULLSCAN;
-- expected: rows: 1
evaluate 'Case 29-1';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE SUBSTRING ('abcdef', i.n, 2) = 'bc' ORDER BY 1;
-- expected: rows: 1 / 2 / 3
evaluate 'Case 29-2';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE ROUND (1.55, i.n) > 1.5 ORDER BY 1;
-- expected: rows: 2
evaluate 'Case 29-3';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE REPEAT ('a', i.n) = 'aaa' ORDER BY 1;
-- expected: rows: 2
evaluate 'Case 29-4';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE INSTR ('abcabc', 'b', i.n) = 5 ORDER BY 1;
-- expected: rows: 1 / 2 / 3 / 4
evaluate 'Case 29-5';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE WEEK (DATE'2020-03-01', i.n) = 9 ORDER BY 1;
-- expected: rows: 1 / 2 / 3 / 4
evaluate 'Case 29-6';
--@queryplan
SELECT o.id FROM t29o o LEFT JOIN t29i i ON o.id = i.id WHERE LIKE_MATCH_LOWER_BOUND ('a%', i.s) = 'a' ORDER BY 1;
-- expected: rows: 1 / 2 / 3
evaluate 'Case 29-7';
--@queryplan
SELECT a FROM t29i WHERE ROUND (1.55, a) > 1.5 USING INDEX i29_ab ORDER BY a, b;
DROP TABLE t29o, t29i;
