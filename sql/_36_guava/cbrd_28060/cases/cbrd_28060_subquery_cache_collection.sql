/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A cached result of a correlated subquery keyed by a collection must not answer for another collection that the
 *  comparison finds equal: {1}, {1.0} and {1.00} of a SEQUENCE without an element type, or of a SET (INT, DOUBLE),
 *  compare equal and hash alike but print apart. A key of a SEQUENCE OF SET column compares its set elements by their
 *  own types. Each query is followed by its NO_SUBQUERY_CACHE twin or by the values read without a subquery. The
 *  verification block after a query that returns a count or a comparison prints PASS when the query and its twin return
 *  the same rows as a multiset; the twin of a query that returns the collection prints it, since DIFFERENCE finds {1}
 *  and {1.0} equal.
 *
 *  Coverage:
 *    Case 1:  SEQUENCE - a correlated subquery keyed by a SEQUENCE without an element type returns the uncached results
 *    Case 2:  SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results
 *    Case 3:  SET of several element types, SEQUENCE OF SET and SEQUENCE without an element type - a correlated
 *             subquery keyed by the column returns the uncached results
 */

evaluate 'Case 1: SEQUENCE - a correlated subquery keyed by a SEQUENCE without an element type returns the uncached results';
DROP TABLE IF EXISTS t_sequence_a;
CREATE TABLE t_sequence_a (ca INT, cb SEQUENCE);

-- {1}, {1.0} and {1.00} compare equal and hash alike, but the subquery returns each as it is
-- ca | cb
-- ---+----------------------------------
-- 81 | {1}
-- 82 | {CAST (1 AS DOUBLE)}
-- 83 | {CAST (1 AS NUMERIC (5, 2))}
-- 84 | {1}
INSERT INTO t_sequence_a VALUES (81, {1}), (82, {CAST (1 AS DOUBLE)}), (83, {CAST (1 AS NUMERIC (5, 2))}), (84, {1});

SELECT t_sequence_a.ca, (SELECT t_sequence_a.cb FROM db_root)
FROM t_sequence_a ORDER BY 1;

SELECT t_sequence_a.ca, t_sequence_a.cb
FROM t_sequence_a ORDER BY 1;

evaluate 'Case 2: SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results';
DROP TABLE IF EXISTS t_sequence_set_a, t_sequence_sequence;

-- CREATE TABLE AS SELECT makes the columns SEQUENCE OF SET and SEQUENCE OF SEQUENCE; t_sequence_set_a.ca 97 holds the
-- key of t_sequence_set_a.ca 91 with its set elements in another order; the subquery is keyed by t_sequence_set_a.cb
-- t_sequence_set_a
-- ca | cb
-- ---+--------------
-- 91 | {{1, 2}}
-- 92 | {{3}}
-- 96 | {{1, 2}, {3}}
-- 97 | {{2, 1}}
CREATE TABLE t_sequence_set_a AS SELECT 91 ca, {SET {1, 2}} cb FROM db_root;
INSERT INTO t_sequence_set_a SELECT 92, {SET {3}} FROM db_root;
INSERT INTO t_sequence_set_a SELECT 96, {SET {1, 2}, SET {3}} FROM db_root;
INSERT INTO t_sequence_set_a SELECT 97, {SET {2, 1}} FROM db_root;

-- t_sequence_sequence
-- ca | cb
-- ---+---------
-- 93 | {{1, 2}}
-- 94 | {{2, 1}}
-- 95 | {{3}}
CREATE TABLE t_sequence_sequence AS SELECT 93 ca, {SEQUENCE {1, 2}} cb FROM db_root;
INSERT INTO t_sequence_sequence SELECT 94, {SEQUENCE {2, 1}} FROM db_root;
INSERT INTO t_sequence_sequence SELECT 95, {SEQUENCE {3}} FROM db_root;

SELECT t_sequence_set_a.ca,
  (SELECT COUNT (*) FROM t_sequence_sequence WHERE t_sequence_sequence.cb = t_sequence_set_a.cb)
FROM t_sequence_set_a ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT t_sequence_set_a.ca AS t_sequence_set_a_ca, (SELECT COUNT (*) FROM t_sequence_sequence WHERE t_sequence_sequence.cb = t_sequence_set_a.cb) AS cnt FROM t_sequence_set_a),
  nocache_rows as (SELECT t_sequence_set_a.ca AS t_sequence_set_a_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ COUNT (*) FROM t_sequence_sequence WHERE t_sequence_sequence.cb = t_sequence_set_a.cb) AS cnt FROM t_sequence_set_a)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

evaluate 'Case 3: SET of several element types, SEQUENCE OF SET and SEQUENCE without an element type - a correlated subquery keyed by the column returns the uncached results';
DROP TABLE IF EXISTS t_set_int_double, t_sequence_set_b, t_sequence_b;
CREATE TABLE t_set_int_double (ca INT, cb SET (INT, DOUBLE));

-- {1} and {1.0} of SET (INT, DOUBLE) compare equal and hash alike, but the subquery returns each as it is
-- ca  | cb
-- ----+----------------------
-- 301 | {1}
-- 302 | {CAST (1 AS DOUBLE)}
-- 303 | {1}
INSERT INTO t_set_int_double VALUES (301, {1}), (302, {CAST (1 AS DOUBLE)}), (303, {1});

SELECT t_set_int_double.ca, (SELECT t_set_int_double.cb FROM db_root)
FROM t_set_int_double ORDER BY 1;

SELECT t_set_int_double.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ t_set_int_double.cb FROM db_root)
FROM t_set_int_double ORDER BY 1;

-- CREATE TABLE AS SELECT makes the column SEQUENCE OF SET OF INTEGER: {{1}} and {{1, 2}} keys repeat;
-- the subquery returns whether the key is {{1}}, which the JDBC driver reads (it cannot read a SEQUENCE OF SET,
-- which no CAST turns into a string)
-- ca  | cb
-- ----+---------
-- 311 | {{1}}
-- 312 | {{1, 2}}
-- 313 | {{1}}
-- 314 | {{2, 1}}
CREATE TABLE t_sequence_set_b AS SELECT 311 ca, {SET {1}} cb FROM db_root;
INSERT INTO t_sequence_set_b SELECT 312, {SET {1, 2}} FROM db_root;
INSERT INTO t_sequence_set_b SELECT 313, {SET {1}} FROM db_root;
INSERT INTO t_sequence_set_b SELECT 314, {SET {2, 1}} FROM db_root;

SELECT t_sequence_set_b.ca, (SELECT t_sequence_set_b.cb = {SET {1}} FROM db_root)
FROM t_sequence_set_b ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT t_sequence_set_b.ca AS t_sequence_set_b_ca, (SELECT t_sequence_set_b.cb = {SET {1}} FROM db_root) AS eq_one FROM t_sequence_set_b),
  nocache_rows as (SELECT t_sequence_set_b.ca AS t_sequence_set_b_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ t_sequence_set_b.cb = {SET {1}} FROM db_root) AS eq_one FROM t_sequence_set_b)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

CREATE TABLE t_sequence_b (ca INT, cb SEQUENCE);

-- a SEQUENCE without an element type holds elements of any type: {1}, {1.0} and {1.00} compare equal, but the subquery
-- returns each as it is; the keys {1} and {1.0} repeat
-- ca  | cb
-- ----+--------
-- 321 | {1}
-- 322 | {1.0}
-- 323 | {1.00}
-- 324 | {1}
-- 325 | {1.0}
INSERT INTO t_sequence_b VALUES (321, {1}), (322, {1.0}), (323, {1.00}), (324, {1}), (325, {1.0});

SELECT t_sequence_b.ca, (SELECT t_sequence_b.cb FROM db_root)
FROM t_sequence_b ORDER BY 1;

SELECT t_sequence_b.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ t_sequence_b.cb FROM db_root)
FROM t_sequence_b ORDER BY 1;

-- cleanup
DROP TABLE IF EXISTS
  t_sequence_a, t_sequence_set_a, t_sequence_sequence, t_set_int_double, t_sequence_set_b, t_sequence_b;
