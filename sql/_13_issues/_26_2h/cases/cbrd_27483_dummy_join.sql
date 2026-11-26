/**
 *  This test case verifies CBRD-27483: Join graph has no edge to the tables that the ON clause of an outer, semi
 *  or anti join depends on, so the query fails or returns a wrong result
 *
 *  The cases need a join edge that no condition of the query makes. The fix adds a dummy join term for it: between
 *  the tables that an ON reads when no join edge connects them, and at a CROSS JOIN or a comma whose two tables a
 *  later join already connects. A dummy join term stands for no condition, so it must not change the join type of an
 *  outer join.
 *  Each case prints the result that its query defines. A case that repeats another case with a hint or in another
 *  form prints the same result.
 *  The SELECT statements with a join that fail or return a wrong result without the fix also print their plan. The
 *  cases with a join order hint print their plan too, which shows whether the planner applied the hint. The queries
 *  with a plan carry RECOMPILE because a plan prints only when the query is compiled. In a plan, the cost picks the
 *  order and the nesting of the tables that no dependency orders, so a change of the cost model or of the
 *  statistics can change those lines.
 *
 *  Coverage:
 *    Case 1:   a LEFT JOIN whose ON reads only its own table, joined after a later CROSS JOIN table that another ON
 *              reads
 *    Case 2:   Case 1 with the ORDERED hint
 *    Case 3:   an INNER JOIN whose ON reads the NULL-padded table of a LEFT JOIN and the table after a CROSS JOIN
 *              in one condition
 *    Case 4:   Case 3 with a second condition that joins the inner table to the table after the CROSS JOIN
 *    Case 5:   Case 3 followed by a LEFT JOIN
 *    Case 6:   Case 3 with a table between the CROSS JOINs that no ON reads
 *    Case 7:   Case 3 with an INNER JOIN in place of the LEFT JOIN
 *    Case 8:   two LEFT JOIN chains around a CROSS JOIN, bridged by a later INNER JOIN and a LEFT JOIN
 *    Case 9:   Case 8 without the last LEFT JOIN
 *    Case 10:  Case 8 with a RIGHT JOIN in place of the last LEFT JOIN
 *    Case 11:  Case 9 with a comma in place of the CROSS JOIN and the condition on tc in the WHERE
 */
-- Cases 1 - 2: no row of tb meets ON tb.ca > tb.cb, and td and tg are empty, so each LEFT JOIN NULL-pads its rows
-- ta, tb and tc are large and te is small, so the planner joins tb after te, ta and tc
-- tb then has one dummy join term to ta for its own LEFT JOIN and one to tc for the ON of td
DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
CREATE TABLE tf (ca INT, cb INT);
CREATE TABLE tg (ca INT, cb INT);
INSERT INTO ta SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
INSERT INTO tb SELECT -ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 500;
INSERT INTO tc SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
INSERT INTO te VALUES (1, 1);
INSERT INTO tf VALUES (1, 1);
CREATE INDEX i_tc_ca ON tc (ca);
CREATE INDEX i_te_ca ON te (ca);
UPDATE STATISTICS ON ta, tb, tc, td, te, tf, tg WITH FULLSCAN;

-- the dummy join term to tc must not turn the LEFT JOIN of tb into an inner join
evaluate 'Case 1: a LEFT JOIN whose ON reads only its own table, joined after a later CROSS JOIN table that another ON reads; result = 1 row';
--@queryplan
SELECT /*+ RECOMPILE */ ta.ca, tb.ca, tc.ca, td.ca, te.ca, tf.ca, tg.ca FROM ta LEFT JOIN tb ON tb.ca > tb.cb CROSS JOIN tc LEFT JOIN td ON td.ca = tb.ca AND td.cb = tc.ca INNER JOIN te ON te.ca = ta.ca AND te.cb = tc.ca CROSS JOIN tf LEFT JOIN tg ON tg.ca = te.ca AND tg.cb = tf.ca ORDER BY 1, 2, 3, 4, 5, 6, 7;

evaluate 'Case 2: Case 1 with the ORDERED hint; result = same row as Case 1';
--@queryplan
SELECT /*+ RECOMPILE ORDERED */ ta.ca, tb.ca, tc.ca, td.ca, te.ca, tf.ca, tg.ca FROM ta LEFT JOIN tb ON tb.ca > tb.cb CROSS JOIN tc LEFT JOIN td ON td.ca = tb.ca AND td.cb = tc.ca INNER JOIN te ON te.ca = ta.ca AND te.cb = tc.ca CROSS JOIN tf LEFT JOIN tg ON tg.ca = te.ca AND tg.cb = tf.ca ORDER BY 1, 2, 3, 4, 5, 6, 7;

DROP TABLE ta, tb, tc, td, te, tf, tg;

-- Cases 3 - 7 use new data: the LEFT JOIN NULL-pads the row 3 of ta, which tb does not have
DROP TABLE IF EXISTS ta, tb, tc, td, tx;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE tx (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 2);
INSERT INTO tc VALUES (0, 0), (1, 1);
INSERT INTO td VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tx VALUES (1, 1), (2, 2);
UPDATE STATISTICS ON ta, tb, tc, td, tx;

-- Cases 3 - 6: td reads the NULL-padded tb, so it comes after the LEFT JOIN
-- its condition reads three tables and makes no join edge, so tb and tc need a dummy join term
evaluate 'Case 3: an INNER JOIN whose ON reads the NULL-padded table of a LEFT JOIN and the table after a CROSS JOIN in one condition; result = 4, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

evaluate 'Case 4: Case 3 with a second condition that joins the inner table to the table after the CROSS JOIN; result = 2, 2';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.ca = tc.ca + 1 AND td.cb = tb.cb + tc.cb;

evaluate 'Case 5: Case 3 followed by a LEFT JOIN; result = 4, 4, 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca), COUNT(t2.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb LEFT JOIN tb t2 ON t2.ca = td.ca;

-- no ON reads tx, so no dummy join term connects it
evaluate 'Case 6: Case 3 with a table between the CROSS JOINs that no ON reads; result = 8, 8';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tb.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca CROSS JOIN tx CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

-- Case 7 is a control: it returns the same result without the fix
-- unlike Case 3, no outer join NULL-pads tb, so td does not have to come after tb
evaluate 'Case 7: Case 3 with an INNER JOIN in place of the LEFT JOIN; result = 4, 4';
SELECT COUNT(*), COUNT(tb.ca) FROM ta INNER JOIN tb ON tb.ca = ta.ca CROSS JOIN tc INNER JOIN td ON td.cb = tb.cb + tc.cb;

DROP TABLE ta, tb, tc, td, tx;

-- Cases 8 - 11 use new data with rows that the LEFT JOINs NULL-pad
DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg, tx;
CREATE TABLE ta (ca INT, cb INT);
CREATE TABLE tb (ca INT, cb INT);
CREATE TABLE tc (ca INT, cb INT);
CREATE TABLE td (ca INT, cb INT);
CREATE TABLE te (ca INT, cb INT);
CREATE TABLE tf (ca INT, cb INT);
CREATE TABLE tg (ca INT, cb INT);
CREATE TABLE tx (ca INT, cb INT);
INSERT INTO ta VALUES (1, 1), (2, 2), (3, 3);
INSERT INTO tb VALUES (1, 1), (2, 2), (2, 4);
INSERT INTO tc VALUES (1, 1), (2, 2), (4, 4);
INSERT INTO td VALUES (1, 1), (2, 2), (5, 5);
INSERT INTO te VALUES (1, 1), (2, 2), (5, 6);
INSERT INTO tf VALUES (1, 1), (2, 2), (6, 6);
INSERT INTO tg VALUES (1, 1), (2, 2), (2, 1);
INSERT INTO tx VALUES (1, 1), (2, 2), (1, 2);
UPDATE STATISTICS ON ta, tb, tc, td, te, tf, tg, tx;

-- Cases 8 - 11: ta and td each start a LEFT JOIN chain, and tx joins the two chains
-- a join order starts at one table, so the CROSS JOIN between tc and td needs a dummy join term for td to follow tc
evaluate 'Case 8: two LEFT JOIN chains around a CROSS JOIN, bridged by a later INNER JOIN and a LEFT JOIN; result = 4, 3';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tg.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb LEFT JOIN tg ON tg.ca = tc.cb AND tg.cb = tf.cb;

evaluate 'Case 9: Case 8 without the last LEFT JOIN; result = 4, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tx.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb;

evaluate 'Case 10: Case 8 with a RIGHT JOIN in place of the last LEFT JOIN; result = 4, 3, 4';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tc.ca), COUNT(tg.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca CROSS JOIN td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.ca = tc.cb AND tx.cb = tf.cb RIGHT JOIN tg ON tg.ca = tc.cb AND tg.cb = tf.cb;

-- a comma allows a cartesian product as a CROSS JOIN does, so it needs the same dummy join term
-- an ON after the comma cannot read tc, so the condition on tc moves to the WHERE; no outer join follows tx, so the
-- result stays that of Case 9
evaluate 'Case 11: Case 9 with a comma in place of the CROSS JOIN and the condition on tc in the WHERE; result = same counts as Case 9';
--@queryplan
SELECT /*+ RECOMPILE */ COUNT(*), COUNT(tx.ca) FROM ta LEFT JOIN tb ON tb.ca = ta.ca INNER JOIN tc ON tc.ca = tb.ca, td LEFT JOIN te ON te.ca = td.ca INNER JOIN tf ON tf.ca = te.ca INNER JOIN tx ON tx.cb = tf.cb WHERE tx.ca = tc.cb;

DROP TABLE ta, tb, tc, td, te, tf, tg, tx;
