/**
 *  This test case verifies CBRD-27483: an outer join must come after every table its ON reads. A CROSS JOIN, or a
 *  merged view whose FROM is a comma join, can leave such a table with no join edge to the others. The query must
 *  then still return the right rows and not fail with "Outer join query optimization failed."
 *
 *  Each case is printed by evaluate 'Case <id>' before it, and the comment above it is the expected result
 *  (rows are separated by ' / ' and columns by ' | ').
 */
DROP VIEW IF EXISTS va, vb;
DROP TABLE IF EXISTS ta, tb, tc, td, te;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 9);
INSERT INTO tc VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO td VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO te VALUES (1, 1), (2, 2), (5, 5);
CREATE VIEW va AS SELECT a.ca ca, a.cb cb, b.ca cc FROM ta a, tb b;
CREATE VIEW vb AS SELECT a.ca ca, a.cb cb, b.ca cc FROM ta a JOIN tb b ON b.ca = a.ca;
UPDATE STATISTICS ON ta, tb, tc, td, te;
-- scenarios 1 - 10: a CROSS JOIN or a merged comma-join view leaves a table the ON reads with no join edge
-- expected: rows: 10
evaluate 'Case S1';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb LEFT JOIN tc ON ta.ca = tb.ca;
-- expected: rows: 6
evaluate 'Case S2';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND ta.ca = 1;
-- expected: rows: 7
evaluate 'Case S3';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca;
-- expected: rows: 18
evaluate 'Case S4';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb CROSS JOIN tc LEFT JOIN td ON td.ca = tc.ca AND ta.ca = 1;
-- expected: rows: 4
evaluate 'Case S5';
SELECT /*+ RECOMPILE */ COUNT(*) FROM va JOIN tb ON tb.ca = va.ca LEFT JOIN tc ON tc.ca = va.cc AND va.cb = 1;
-- expected: rows: 12
evaluate 'Case S6';
SELECT /*+ RECOMPILE */ COUNT(*) FROM va CROSS JOIN tb LEFT JOIN tc ON tc.ca = tb.ca AND va.cb = 1;
-- expected: rows: 2
evaluate 'Case S7';
SELECT /*+ RECOMPILE */ COUNT(*) FROM vb JOIN tb ON tb.ca = vb.ca LEFT JOIN tc ON tc.ca = vb.cc AND vb.cb = 1;
-- expected: rows: 18
evaluate 'Case S8';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca CROSS JOIN td LEFT JOIN te ON te.ca = tb.ca AND te.cb = td.cb;
-- expected: rows: 6
evaluate 'Case S9';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb;
-- expected: rows: 6
evaluate 'Case S10';
SELECT /*+ RECOMPILE */ COUNT(*) FROM ta CROSS JOIN tb LEFT OUTER JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb LEFT OUTER JOIN td ON td.ca = ta.ca AND td.cb = tb.cb LEFT OUTER JOIN te ON te.ca = ta.ca AND te.cb = tb.cb;
DROP VIEW IF EXISTS va, vb;
DROP TABLE IF EXISTS ta, tb, tc, td, te;
CREATE TABLE ta (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tb (ca INT PRIMARY KEY, cb INT);
CREATE TABLE tc (ca INT PRIMARY KEY, cb INT);
INSERT INTO ta VALUES (1, 1);
INSERT INTO tb VALUES (2, 1), (3, 1);
INSERT INTO tc VALUES (2, 20), (4, 40);
UPDATE STATISTICS ON ta, tb, tc;
-- scenarios 11 - 13: join order hints must not add a join edge the query does not ask for
-- expected: rows: 1 | 20 / 1 | NULL
evaluate 'Case S11';
SELECT /*+ RECOMPILE */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;
-- expected: rows: 1 | 20 / 1 | NULL
evaluate 'Case S12';
SELECT /*+ RECOMPILE ORDERED */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;
-- expected: rows: 1 | 20 / 1 | NULL
evaluate 'Case S13';
SELECT /*+ RECOMPILE LEADING(ta,tb,tc) */ tb.cb, tc.cb FROM ta, tc RIGHT OUTER JOIN tb ON tc.ca = tb.ca WHERE tb.cb = ta.cb ORDER BY 1, 2;
DROP TABLE IF EXISTS ta, tb, tc;
CREATE TABLE ta (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3), (4, NULL);
CREATE TABLE tb (ca INT, cb INT);
INSERT INTO tb VALUES (1, 1), (2, 2), (3, NULL);
CREATE TABLE tc (ca INT, cb INT);
INSERT INTO tc VALUES (1, 1), (1, 2), (2, 3), (5, 1);
UPDATE STATISTICS ON ta, tb, tc;
-- the ON joins both tables of the CROSS JOIN, alone and with a WHERE on the NULL-padded table; a RIGHT JOIN with a WHERE
-- expected: rows: 1 | 1 | 1 | 1 | 1 | 1 / 1 | 1 | 2 | 2 | 1 | 2 / 1 | 1 | 3 | NULL | NULL | NULL / 2 | 2 | 1 | 1 | NULL | NULL / 2 | 2 | 2 | 2 | NULL | NULL / 2 | 2 | 3 | NULL | NULL | NULL / 3 | 3 | 1 | 1 | NULL | NULL / 3 | 3 | 2 | 2 | NULL | NULL / 3 | 3 | 3 | NULL | NULL | NULL / 4 | NULL | 1 | 1 | NULL | NULL / 4 | NULL | 2 | 2 | NULL | NULL / 4 | NULL | 3 | NULL | NULL | NULL
evaluate 'Case S14';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb ORDER BY 1, 2, 3, 4, 5, 6;
-- expected: rows: 1 | 1 | 3 | NULL | NULL | NULL / 2 | 2 | 1 | 1 | NULL | NULL / 2 | 2 | 2 | 2 | NULL | NULL / 2 | 2 | 3 | NULL | NULL | NULL / 3 | 3 | 1 | 1 | NULL | NULL / 3 | 3 | 2 | 2 | NULL | NULL / 3 | 3 | 3 | NULL | NULL | NULL / 4 | NULL | 1 | 1 | NULL | NULL / 4 | NULL | 2 | 2 | NULL | NULL / 4 | NULL | 3 | NULL | NULL | NULL
evaluate 'Case S15';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE tc.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;
-- expected: rows: 1 | 1 | 1 | 1 | 1 | 1 / 1 | 1 | 3 | NULL | NULL | NULL / 2 | 2 | 1 | 1 | NULL | NULL / 2 | 2 | 2 | 2 | NULL | NULL / 2 | 2 | 3 | NULL | NULL | NULL / 3 | 3 | 1 | 1 | NULL | NULL / 3 | 3 | 2 | 2 | NULL | NULL / 3 | 3 | 3 | NULL | NULL | NULL / 4 | NULL | 1 | 1 | NULL | NULL / 4 | NULL | 2 | 2 | NULL | NULL / 4 | NULL | 3 | NULL | NULL | NULL
evaluate 'Case S16';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb LEFT JOIN tc ON tc.ca = ta.ca AND tc.cb = tb.cb WHERE NVL (tc.ca, tb.ca) = tb.ca ORDER BY 1, 2, 3, 4, 5, 6;
-- expected: rows: 1 | 1 | 1 | 1 | 1 | 1 / 2 | 2 | 1 | 1 | 1 | 2 / 3 | 3 | 2 | 2 | 2 | 3 / 4 | NULL | 1 | 1 | 1 | 1 / 4 | NULL | 1 | 1 | 1 | 2 / 4 | NULL | 2 | 2 | 2 | 3 / NULL | NULL | NULL | NULL | 5 | 1
evaluate 'Case S17';
SELECT /*+ RECOMPILE */ ta.ca, ta.cb, tb.ca, tb.cb, tc.ca, tc.cb FROM ta CROSS JOIN tb RIGHT JOIN tc ON tb.ca = tc.ca WHERE ta.cb = tc.cb OR ta.cb IS NULL ORDER BY 1, 2, 3, 4, 5, 6;
DROP TABLE ta, tb, tc;
