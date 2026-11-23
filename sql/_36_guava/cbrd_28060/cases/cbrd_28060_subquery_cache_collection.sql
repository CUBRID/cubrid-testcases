/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A cached result of a correlated subquery keyed by a collection must not answer for another collection that the
 *  comparison finds equal: {1}, {1.0} and {1.00} of a SEQUENCE of no element domain, or of a SET (INT, DOUBLE), compare
 *  equal and hash alike but print apart. A key of a SEQUENCE OF SET column compares its set elements by their own
 *  types. Each query is followed by its NO_SUBQUERY_CACHE twin or by the values read without a subquery.
 *
 *  Coverage:
 *    Case 1:  SEQUENCE - a correlated subquery keyed by a SEQUENCE of no element domain returns the uncached results
 *    Case 2:  SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results
 *    Case 3:  SET of several element types, SEQUENCE OF SET and SEQUENCE of no element type - a correlated subquery
 *             keyed by the column returns the uncached results
 */

evaluate 'Case 1: SEQUENCE - a correlated subquery keyed by a SEQUENCE of no element domain returns the uncached results';
-- {1}, {1.0} and {1.00} compare equal and hash alike, but the subquery returns each as it is
-- ca | cb
-- ---+----------------------------------
-- 81 | {1}
-- 82 | {CAST (1 AS DOUBLE)}
-- 83 | {CAST (1 AS NUMERIC (5, 2))}
-- 84 | {1}
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb SEQUENCE);
INSERT INTO ta VALUES
  (81, {1}),
  (82, {CAST (1 AS DOUBLE)}),
  (83, {CAST (1 AS NUMERIC (5, 2))}),
  (84, {1});
SELECT ta.ca, (SELECT ta.cb FROM db_root) FROM ta ORDER BY 1;
SELECT ta.ca, ta.cb FROM ta ORDER BY 1;

evaluate 'Case 2: SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results';
-- CREATE TABLE AS SELECT makes the columns SEQUENCE OF SET and SEQUENCE OF SEQUENCE; tb.ca 97 holds the key of
-- tb.ca 91 with its set elements in another order; the subquery is keyed by tb.cb
-- tb.ca | tb.cb
-- ------+---------------
--  91   | {{1, 2}}
--  92   | {{3}}
--  96   | {{1, 2}, {3}}
--  97   | {{2, 1}}
-- tc.ca | tc.cb
-- ------+---------------
--  93   | {{1, 2}}
--  94   | {{2, 1}}
--  95   | {{3}}
DROP TABLE IF EXISTS tb, tc;
CREATE TABLE tb AS SELECT 91 ca, {SET {1, 2}} cb FROM db_root;
INSERT INTO tb SELECT 92, {SET {3}} FROM db_root;
INSERT INTO tb SELECT 96, {SET {1, 2}, SET {3}} FROM db_root;
INSERT INTO tb SELECT 97, {SET {2, 1}} FROM db_root;
CREATE TABLE tc AS SELECT 93 ca, {SEQUENCE {1, 2}} cb FROM db_root;
INSERT INTO tc SELECT 94, {SEQUENCE {2, 1}} FROM db_root;
INSERT INTO tc SELECT 95, {SEQUENCE {3}} FROM db_root;
SELECT tb.ca, (SELECT COUNT (*) FROM tc WHERE tc.cb = tb.cb) FROM tb ORDER BY 1;
SELECT tb.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ COUNT (*) FROM tc WHERE tc.cb = tb.cb) FROM tb ORDER BY 1;

evaluate 'Case 3: SET of several element types, SEQUENCE OF SET and SEQUENCE of no element type - a correlated subquery keyed by the column returns the uncached results';
-- {1} and {1.0} of SET (INT, DOUBLE) compare equal and hash alike, but the subquery returns each as it is
-- ca  | cb
-- ----+----------------------
-- 301 | {1}
-- 302 | {CAST (1 AS DOUBLE)}
-- 303 | {1}
DROP TABLE IF EXISTS td, te, tf;
CREATE TABLE td (ca INT, cb SET (INT, DOUBLE));
INSERT INTO td VALUES
  (301, {1}),
  (302, {CAST (1 AS DOUBLE)}),
  (303, {1});
SELECT td.ca, (SELECT td.cb FROM db_root) FROM td ORDER BY 1;
SELECT td.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ td.cb FROM db_root) FROM td ORDER BY 1;
-- CREATE TABLE AS SELECT makes the column SEQUENCE OF SET OF INTEGER: {{1}} and {{1, 2}} keys repeat;
-- the subquery returns whether the key is {{1}}, which the JDBC driver reads (it cannot read a SEQUENCE OF SET,
-- which no CAST turns into a string)
-- ca  | cb
-- ----+---------
-- 311 | {{1}}
-- 312 | {{1, 2}}
-- 313 | {{1}}
-- 314 | {{2, 1}}
CREATE TABLE te AS SELECT 311 ca, {SET {1}} cb FROM db_root;
INSERT INTO te SELECT 312, {SET {1, 2}} FROM db_root;
INSERT INTO te SELECT 313, {SET {1}} FROM db_root;
INSERT INTO te SELECT 314, {SET {2, 1}} FROM db_root;
SELECT te.ca, (SELECT te.cb = {SET {1}} FROM db_root) FROM te ORDER BY 1;
SELECT te.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ te.cb = {SET {1}} FROM db_root) FROM te ORDER BY 1;
-- a SEQUENCE of no element type holds elements of any type: {1}, {1.0} and {1.00} compare equal, but the subquery
-- returns each as it is; the keys {1} and {1.0} repeat
-- ca  | cb
-- ----+--------
-- 321 | {1}
-- 322 | {1.0}
-- 323 | {1.00}
-- 324 | {1}
-- 325 | {1.0}
CREATE TABLE tf (ca INT, cb SEQUENCE);
INSERT INTO tf VALUES
  (321, {1}),
  (322, {1.0}),
  (323, {1.00}),
  (324, {1}),
  (325, {1.0});
SELECT tf.ca, (SELECT tf.cb FROM db_root) FROM tf ORDER BY 1;
SELECT tf.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ tf.cb FROM db_root) FROM tf ORDER BY 1;

-- cleanup

DROP TABLE IF EXISTS ta, tb, tc, td, te, tf;
