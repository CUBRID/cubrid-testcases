/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A JSON value compares as the SQL value it converts to: 1 equals 1.0, true equals "true", "0x10"
 *  equals 16, and an object compares by its body text. A JSON integer compares with a DOUBLE or a
 *  numeric string by their values, so 9007199254740993 (2^53 + 1) no longer equals 9007199254740992.0.
 *  A multiset compares sorted, whatever the
 *  order of its elements, and its elements compare with coercion (1 equals 1.0). The change hashes
 *  both as they compare, and the hash join compares a JSON or collection key with coercion as the
 *  join term does. Before the change, the hash join missed pairs of equal JSON and collection keys,
 *  so each hash join must return the pairs of its nested loop join twin. SHOW TRACE shows HASHJOIN.
 *  A NUMERIC with 16 or more digits and a scale converted to DOUBLE through two roundings, so
 *  NUMERIC(24,4) 495038888524330534.0000 and BIGINT 495038888524330534 became two DOUBLEs; the
 *  change rounds once. A NUMERIC or a string converted to FLOAT through DOUBLE as well, and now rounds once to FLOAT.
 *  A string of a subnormal DOUBLE ('1e-310') was an overflow error, and now converts to the DOUBLE.
 *  Collection elements that compare equal only with coercion ('1' and 1) hash apart, so
 *  such a pair of element types is not hashed: the planner leaves its join to the nested loop. A cached result keyed by a JSON value (the subquery cache) must not answer
 *  for another value the comparison finds equal: JSON_TYPE of 1 and of 1.0 differ. The same holds for a collection
 *  key: {1} and {1.0} of a SEQUENCE of no element domain compare equal but print apart. A collection element that is
 *  itself a collection compares equal to one of another collection type ({SET {1, 2}} = {SEQUENCE {1, 2}}), but the
 *  planner sees a column of SEQUENCE OF SET as a SEQUENCE OF INTEGER, so the hash join of such columns returned no
 *  pair (before the change too), and the subquery cache keyed by such a column stopped on an assertion during the
 *  change. A collection element now hashes by the sum of its elements' hashes, whatever its collection type, and
 *  a cached key compares its elements by their own types. A collection declared with several element types hashes
 *  when all of them share one element hash type (exact numbers, DOUBLE and MONETARY, or strings of one
 *  collation); one that mixes two (INT and VARCHAR, INT and FLOAT, BIGINT and DOUBLE) is joined by the nested
 *  loop, as is a join of exact and floating elements across two columns: an element of two such types compares
 *  through DOUBLE.
 *  A key built of a collection column ({ta.cb}) keeps the nested domain, which a hash join or a hash list scan
 *  hashes when its leaf element types do.
 *  A cached result keyed by a NUMERIC or a MONETARY must not answer for one of another scale (1.0 and 1.00) or
 *  currency ($1.00 and \1.00), or by a -0 for a 0 or a -NaN for a NaN (DOUBLE, FLOAT, MONETARY) either: they
 *  compare equal and hash alike but print apart. A memoized inner scan of a nested loop join keyed by -0 and 0
 *  must not answer for the other key either.
 *
 *  Coverage:
 *    Case 1:  JSON - hash join returns the pairs of the nested loop join
 *    Case 2:  JSON - hash join with the other build side returns the pairs of the nested loop join
 *    Case 3:  JSON - hash GROUP BY returns the groups of the sort GROUP BY
 *    Case 4:  JSON - a correlated subquery keyed by a JSON value returns the uncached results
 *    Case 5:  MULTISET - hash join of unsorted multisets returns the pairs of the nested loop join
 *    Case 6:  MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join
 *    Case 7:  MULTISET - BIGINT and DOUBLE elements join by nested loop, with its pairs
 *    Case 8:  MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with its pairs
 *    Case 9:  NUMERIC to DOUBLE - one value converts to one DOUBLE whatever its type and scale
 *    Case 10: MULTISET - VARCHAR and INT elements ({'1'} = {1}) join by nested loop, with its pairs
 *    Case 11: SEQUENCE - a correlated subquery keyed by a SEQUENCE of no element domain returns the uncached results
 *    Case 12: SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join returns the pairs of the nested loop join
 *    Case 13: SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results
 *    Case 14: SET of several element types of one hash type - hash join returns the pairs of the nested loop join
 *    Case 15: SET of element types of two hash types - joins by nested loop, with its pairs
 *    Case 16: SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join
 *    Case 17: SEQUENCE of a SET column - hash list scan of nested keys returns the rows of the nested loop scan
 *    Case 18: NUMERIC and MONETARY - a correlated subquery keyed by one value of two scales or currencies returns
 *             the uncached results
 *    Case 19: DOUBLE, FLOAT and MONETARY - a correlated subquery keyed by -0 and 0, or by -NaN and NaN, returns the
 *             uncached results
 *    Case 20: DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize
 *    Case 21: SET OF a class - hash join returns the pairs of the nested loop join (its elements are OIDs)
 *    Case 22: SET of several element types, SEQUENCE OF SET and SEQUENCE of no element type - a correlated subquery
 *             keyed by the column returns the uncached results
 *    Case 23: NUMERIC and string to FLOAT - a value just off the midpoint of two FLOATs converts to the nearest one
 *    Case 24: SET, MULTISET and SEQUENCE across kinds - hash join returns the pairs of the nested loop join
 *    Case 25: JSON - CONNECT BY by a hash list scan returns the rows of the single-table plan
 *    Case 26: SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested loop join
 *    Case 27: string to DOUBLE - a subnormal value converts to it, not to an overflow error
 *    Case 28: JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63, and
 *             hash join returns the pairs of the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- JSON values that compare equal in pairs across ta and tb
-- ta.ca | ta.cb            | tb.ca that equal it
-- ------+------------------+------------------------------
--   1   | 1                | 11 (1.0), 17 (1), 19 ("  1  ")
--   2   | -0.0             | 12 (0.0), 22 ("")
--   3   | true             | 13 ("true")
--   4   | "a"              | 14 ("a")
--   5   | [1, 2]           | 15 ([1,2])
--   6   | {"a": 1}         | 16 ({"a":1})
--   7   | 1.5              | 18 ("1.5")
--   8   | 9007199254740993 | none: 20 (9007199254740992.0) is 2^53, one less
--   9   | 16               | 21 ("0x10")
--  10   | 0                | 12 (0.0), 22 ("")
--  11   | null             | none
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb JSON);
INSERT INTO ta VALUES (1, '1'), (2, '-0.0'), (3, 'true'), (4, '"a"'), (5, '[1, 2]'), (6, '{"a": 1}'), (7, '1.5'), (8, '9007199254740993'), (9, '16'), (10, '0'), (11, 'null');
CREATE TABLE tb (ca INT, cb JSON);
INSERT INTO tb VALUES (11, '1.0'), (12, '0.0'), (13, '"true"'), (14, '"a"'), (15, '[1,2]'), (16, '{"a":1}'), (17, '1'), (18, '"1.5"'), (19, '"  1  "'), (20, '9007199254740992.0'), (21, '"0x10"'), (22, '""'), (23, '"abc"'), (24, '"A"'), (25, 'null'), (26, '"[1,2]"');

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: JSON - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

evaluate 'Case 2: JSON - hash join with the other build side returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM tb, ta WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM tb, ta WHERE ta.cb = tb.cb ORDER BY 1, 2;

evaluate 'Case 3: JSON - hash GROUP BY returns the groups of the sort GROUP BY';
-- true and "true" (ta.ca 3, tb.ca 13) are left out: the sort GROUP BY tells them apart, the hash GROUP BY does not,
-- before the change as after it
DROP TABLE IF EXISTS tc;
CREATE TABLE tc AS SELECT * FROM ta WHERE ca <> 3 UNION ALL SELECT * FROM tb WHERE ca <> 13;
set trace on;
SELECT /*+ PARALLEL(0) */ MIN (ca), COUNT (*) FROM tc GROUP BY cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_HASH_AGGREGATE */ MIN (ca), COUNT (*) FROM tc GROUP BY cb ORDER BY 1, 2;

evaluate 'Case 4: JSON - a correlated subquery keyed by a JSON value returns the uncached results';
-- 1 and 1.0, true and "true", 1 and "1" compare equal and hash alike, but JSON_TYPE tells them apart
DROP TABLE IF EXISTS td;
CREATE TABLE td (ca INT, cb JSON);
INSERT INTO td VALUES (1, '1'), (2, '1.0'), (3, 'true'), (4, '"true"'), (5, '"1"'), (6, '{"a": 1}'), (7, '{"a":1.0}'), (8, '1'), (9, '1.0');
SELECT td.ca, (SELECT JSON_TYPE (td.cb) FROM db_root) FROM td ORDER BY 1;
SELECT td.ca, JSON_TYPE (td.cb) FROM td ORDER BY 1;

-- tm.ca 1 holds 200 elements inserted out of order, which leaves the multiset unsorted
-- tm.ca 2 and 3 hold one element twice; tn holds the same multisets and others of the same elements
DROP TABLE IF EXISTS tn, tm;
CREATE TABLE tm (ca INT, cb MULTISET (INT));
INSERT INTO tm VALUES (1, {200,199,198,197,196,195,194,193,192,191,190,189,188,187,186,185,184,183,182,181,180,179,178,177,176,175,174,173,172,171,170,169,168,167,166,165,164,163,162,161,160,159,158,157,156,155,154,153,152,151,150,149,148,147,146,145,144,143,142,141,140,139,138,137,136,135,134,133,132,131,130,129,128,127,126,125,124,123,122,121,120,119,118,117,116,115,114,113,112,111,110,109,108,107,106,105,104,103,102,101,100,99,98,97,96,95,94,93,92,91,90,89,88,87,86,85,84,83,82,81,80,79,78,77,76,75,74,73,72,71,70,69,68,67,66,65,64,63,62,61,60,59,58,57,56,55,54,53,52,51,50,49,48,47,46,45,44,43,42,41,40,39,38,37,36,35,34,33,32,31,30,29,28,27,26,25,24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1});
INSERT INTO tm VALUES (2, {1, 1, 2}), (3, {1, 2, 2});
CREATE TABLE tn (ca INT, cb MULTISET (INT));
INSERT INTO tn SELECT ca + 10, cb FROM tm;
INSERT INTO tn VALUES (14, {2, 1, 1}), (15, {2, 2, 1}), (16, {1, 2});

UPDATE STATISTICS ON tm, tn WITH FULLSCAN;

evaluate 'Case 5: MULTISET - hash join of unsorted multisets returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tm.ca, tn.ca FROM tm, tn WHERE tm.cb = tn.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tm.ca, tn.ca FROM tm, tn WHERE tm.cb = tn.cb ORDER BY 1, 2;

-- one value in three element types; 495038888524330534 has 18 digits, 9007199254740993 is 2^53 + 1
-- te holds BIGINT, tf NUMERIC(24,4), tg DOUBLE elements; tg.ca 53 holds 2^53, the DOUBLE nearest to 2^53 + 1
DROP TABLE IF EXISTS tg, tf, te;
CREATE TABLE te (ca INT, cb MULTISET (BIGINT));
INSERT INTO te VALUES (31, {1}), (32, {495038888524330534}), (33, {9007199254740993});
CREATE TABLE tf (ca INT, cb MULTISET (NUMERIC (24, 4)));
INSERT INTO tf VALUES (41, {1.0000}), (42, {495038888524330534.0000}), (43, {9007199254740993.0000});
CREATE TABLE tg (ca INT, cb MULTISET (DOUBLE));
INSERT INTO tg VALUES (51, {1.0}), (52, {495038888524330534.0}), (53, {9007199254740992.0});

UPDATE STATISTICS ON te, tf, tg WITH FULLSCAN;

evaluate 'Case 6: MULTISET - hash join of BIGINT and NUMERIC(24,4) elements returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ te.ca, tf.ca FROM te, tf WHERE te.cb = tf.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ te.ca, tf.ca FROM te, tf WHERE te.cb = tf.cb ORDER BY 1, 2;

evaluate 'Case 7: MULTISET - BIGINT and DOUBLE elements join by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ te.ca, tg.ca FROM te, tg WHERE te.cb = tg.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ te.ca, tg.ca FROM te, tg WHERE te.cb = tg.cb ORDER BY 1, 2;

evaluate 'Case 8: MULTISET - NUMERIC(24,4) and DOUBLE elements join by nested loop, with its pairs';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tf.ca, tg.ca FROM tf, tg WHERE tf.cb = tg.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tf.ca, tg.ca FROM tf, tg WHERE tf.cb = tg.cb ORDER BY 1, 2;

evaluate 'Case 9: NUMERIC to DOUBLE - one value converts to one DOUBLE whatever its type and scale';
-- the DOUBLE nearest to 495038888524330534 is 495038888524330560; two roundings gave 495038888524330496
SELECT CASE WHEN CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE) = CAST (CAST (495038888524330534 AS BIGINT) AS DOUBLE)
             AND CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE) = CAST (CAST (495038888524330534 AS NUMERIC (18, 0)) AS DOUBLE)
             AND CAST (CAST (0.1 AS NUMERIC (38, 30)) AS DOUBLE) = CAST (0.1 AS DOUBLE)
            THEN 'PASS' ELSE 'FAIL' END res;
SELECT TO_CHAR (CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE), '999999999999999999');

evaluate 'Case 10: MULTISET - VARCHAR and INT elements ({''1''} = {1}) join by nested loop, with its pairs';
DROP TABLE IF EXISTS tv, tw;
CREATE TABLE tv (ca INT, cb MULTISET (VARCHAR (10)));
INSERT INTO tv VALUES (61, {'1'}), (62, {'2'}), (63, {'1', '2'});
CREATE TABLE tw (ca INT, cb MULTISET (INT));
INSERT INTO tw VALUES (71, {1}), (72, {3}), (73, {2, 1});
UPDATE STATISTICS ON tv, tw WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tv.ca, tw.ca FROM tv, tw WHERE tv.cb = tw.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tv.ca, tw.ca FROM tv, tw WHERE tv.cb = tw.cb ORDER BY 1, 2;

evaluate 'Case 11: SEQUENCE - a correlated subquery keyed by a SEQUENCE of no element domain returns the uncached results';
-- {1}, {1.0} and {1.00} compare equal and hash alike, but the subquery returns each as it is
DROP TABLE IF EXISTS ts;
CREATE TABLE ts (ca INT, cb SEQUENCE);
INSERT INTO ts VALUES (81, {1}), (82, {CAST (1 AS DOUBLE)}), (83, {CAST (1 AS NUMERIC (5, 2))}), (84, {1});
SELECT ts.ca, (SELECT ts.cb FROM db_root) FROM ts ORDER BY 1;
SELECT ts.ca, ts.cb FROM ts ORDER BY 1;

evaluate 'Case 12: SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join returns the pairs of the nested loop join';
-- CREATE TABLE AS SELECT makes the columns SEQUENCE OF SET and SEQUENCE OF SEQUENCE
-- tx.ca | tx.cb         | ty.ca that equal it
-- ------+---------------+--------------------
--  91   | {{1, 2}}      | 93 ({{1, 2}})
--  92   | {{3}}         | 95 ({{3}})
--  96   | {{1, 2}, {3}} | none
DROP TABLE IF EXISTS tx, ty;
CREATE TABLE tx AS SELECT 91 ca, {SET {1, 2}} cb FROM db_root;
INSERT INTO tx SELECT 92, {SET {3}} FROM db_root;
INSERT INTO tx SELECT 96, {SET {1, 2}, SET {3}} FROM db_root;
CREATE TABLE ty AS SELECT 93 ca, {SEQUENCE {1, 2}} cb FROM db_root;
INSERT INTO ty SELECT 94, {SEQUENCE {2, 1}} FROM db_root;
INSERT INTO ty SELECT 95, {SEQUENCE {3}} FROM db_root;
UPDATE STATISTICS ON tx, ty WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tx.ca, ty.ca FROM tx, ty WHERE tx.cb = ty.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tx.ca, ty.ca FROM tx, ty WHERE tx.cb = ty.cb ORDER BY 1, 2;

evaluate 'Case 13: SEQUENCE OF SET - a correlated subquery keyed by the column returns the uncached results';
-- tx.ca 97 holds the key of tx.ca 91 with its set elements in another order; the subquery is keyed by tx.cb
INSERT INTO tx SELECT 97, {SET {2, 1}} FROM db_root;
SELECT tx.ca, (SELECT COUNT (*) FROM ty WHERE ty.cb = tx.cb) FROM tx ORDER BY 1;
SELECT tx.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ COUNT (*) FROM ty WHERE ty.cb = tx.cb) FROM tx ORDER BY 1;

evaluate 'Case 14: SET of several element types of one hash type - hash join returns the pairs of the nested loop join';
-- th and ti hold INT, BIGINT and NUMERIC(10,2) elements, which hash as the DOUBLE they equal;
-- tj and tk hold VARCHAR and CHAR elements of one collation, which hash without the trailing pad;
-- tl and tu hold INT and DOUBLE elements, which hash as the DOUBLE they equal
DROP TABLE IF EXISTS th, ti, tj, tk, tl, tu;
CREATE TABLE th (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));
INSERT INTO th VALUES (101, {1, 2}), (102, {3}), (103, {CAST (5 AS BIGINT)});
CREATE TABLE ti (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));
INSERT INTO ti VALUES (111, {CAST (1 AS BIGINT), 2.00}), (112, {3.00}), (113, {5}), (114, {4});
CREATE TABLE tj (ca INT, cb SET (VARCHAR (10), CHAR (5)));
INSERT INTO tj VALUES (121, {'a'}), (122, {'b', 'c'});
CREATE TABLE tk (ca INT, cb SET (VARCHAR (10), CHAR (5)));
INSERT INTO tk VALUES (131, {CAST ('a' AS CHAR (5))}), (132, {'c', CAST ('b' AS CHAR (5))}), (133, {'d'});
CREATE TABLE tl (ca INT, cb SET (INT, DOUBLE));
INSERT INTO tl VALUES (181, {1, 2.5e0}), (182, {3});
CREATE TABLE tu (ca INT, cb SET (INT, DOUBLE));
INSERT INTO tu VALUES (191, {CAST (1 AS DOUBLE), 2.5e0}), (192, {CAST (3 AS DOUBLE)}), (193, {4});
UPDATE STATISTICS ON th, ti, tj, tk, tl, tu WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ th.ca, ti.ca FROM th, ti WHERE th.cb = ti.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tj.ca, tk.ca FROM tj, tk WHERE tj.cb = tk.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tl.ca, tu.ca FROM tl, tu WHERE tl.cb = tu.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ th.ca, ti.ca FROM th, ti WHERE th.cb = ti.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tj.ca, tk.ca FROM tj, tk WHERE tj.cb = tk.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tl.ca, tu.ca FROM tl, tu WHERE tl.cb = tu.cb ORDER BY 1, 2;

evaluate 'Case 15: SET of element types of two hash types - joins by nested loop, with its pairs';
-- {1} = {'1'} in tp and tq, and INT 16777217 = FLOAT 16777216 in tr and tt: the comparison coerces the elements,
-- the element hash tells them apart
DROP TABLE IF EXISTS tp, tq, tr, tt;
CREATE TABLE tp (ca INT, cb SET (INT, VARCHAR (10)));
INSERT INTO tp VALUES (141, {1}), (142, {'x'});
CREATE TABLE tq (ca INT, cb SET (INT, VARCHAR (10)));
INSERT INTO tq VALUES (151, {'1'}), (152, {1}), (153, {'x'});
CREATE TABLE tr (ca INT, cb SET (INT, FLOAT));
INSERT INTO tr VALUES (161, {16777217});
CREATE TABLE tt (ca INT, cb SET (INT, FLOAT));
INSERT INTO tt VALUES (171, {CAST (16777216 AS FLOAT)}), (172, {16777217});
UPDATE STATISTICS ON tp, tq, tr, tt WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tp.ca, tq.ca FROM tp, tq WHERE tp.cb = tq.cb ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tr.ca, tt.ca FROM tr, tt WHERE tr.cb = tt.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tp.ca, tq.ca FROM tp, tq WHERE tp.cb = tq.cb ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tr.ca, tt.ca FROM tr, tt WHERE tr.cb = tt.cb ORDER BY 1, 2;

evaluate 'Case 16: SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join';
-- {tza.cb} is a SEQUENCE OF SET OF INTEGER: against SET (INT) or SEQUENCE (INT) elements it hashes;
-- against SET (VARCHAR) elements ({{1}} = {{'1'}}), or with a leaf beside the set ({tza.cb, tza.ca}),
-- it joins by nested loop
DROP TABLE IF EXISTS tza, tzb;
CREATE TABLE tza (ca INT, cb SET (INT));
INSERT INTO tza VALUES (201, {1, 2}), (202, {3});
CREATE TABLE tzb (ca INT, cb SET (INT), cc SET (VARCHAR (10)), cd SEQUENCE (INT));
INSERT INTO tzb VALUES (211, {2, 1}, {'1', '2'}, {1, 2}), (212, {3}, {'3'}, {3}), (213, {4}, {'x'}, {2, 1});
UPDATE STATISTICS ON tza, tzb WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cb} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cd} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cc} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb, tza.ca + 10} = {tzb.cb, tzb.ca} ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cb} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cd} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb} = {tzb.cc} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tza.ca, tzb.ca FROM tza, tzb WHERE {tza.cb, tza.ca + 10} = {tzb.cb, tzb.ca} ORDER BY 1, 2;

evaluate 'Case 17: SEQUENCE of a SET column - hash list scan of nested keys returns the rows of the nested loop scan';
-- y reads tzb with NO_MERGE, the build side of the hash list scan; {tza.cb} against {cb} or {cd} hashes;
-- against {cc} ({{3}} = {{'3'}}, which the hash list scan missed before the change), or with a leaf beside the set
-- ({cb, ca}), the scan reads y by nested loop
set trace on;
SELECT /*+ ORDERED PARALLEL(0) */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb, tza.ca + 10} = y.c ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tza.ca, y.ca FROM tza, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM tzb WHERE ca >= 1) y WHERE {tza.cb, tza.ca + 10} = y.c ORDER BY 1, 2;

evaluate 'Case 18: NUMERIC and MONETARY - a correlated subquery keyed by one value of two scales or currencies returns the uncached results';
-- d.cb holds each value as its branch of the UNION ALL gives it; the subquery is keyed by d.cb
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 221 ca, CAST (1 AS NUMERIC (5, 1)) cb FROM db_root UNION ALL SELECT 222, CAST (1 AS NUMERIC (5, 2)) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 221 ca, CAST (1 AS NUMERIC (5, 1)) cb FROM db_root UNION ALL SELECT 222, CAST (1 AS NUMERIC (5, 2)) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 231 ca, $1.00 cb FROM db_root UNION ALL SELECT 232, \1.00 FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 231 ca, $1.00 cb FROM db_root UNION ALL SELECT 232, \1.00 FROM db_root) d ORDER BY 1;

evaluate 'Case 19: DOUBLE, FLOAT and MONETARY - a correlated subquery keyed by -0 and 0, or by -NaN and NaN, returns the uncached results';
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 241 ca, CAST (0 AS DOUBLE) cb FROM db_root UNION ALL SELECT 242, -CAST (0 AS DOUBLE) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 241 ca, CAST (0 AS DOUBLE) cb FROM db_root UNION ALL SELECT 242, -CAST (0 AS DOUBLE) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 251 ca, CAST (0 AS FLOAT) cb FROM db_root UNION ALL SELECT 252, -CAST (0 AS FLOAT) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 251 ca, CAST (0 AS FLOAT) cb FROM db_root UNION ALL SELECT 252, -CAST (0 AS FLOAT) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 271 ca, CAST ('nan' AS DOUBLE) cb FROM db_root UNION ALL SELECT 272, -CAST ('nan' AS DOUBLE) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 271 ca, CAST ('nan' AS DOUBLE) cb FROM db_root UNION ALL SELECT 272, -CAST ('nan' AS DOUBLE) FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT d.cb || '' FROM db_root) FROM (SELECT 261 ca, $0.00 cb FROM db_root UNION ALL SELECT 262, -$0.00 FROM db_root) d ORDER BY 1;
SELECT d.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) FROM (SELECT 261 ca, $0.00 cb FROM db_root UNION ALL SELECT 262, -$0.00 FROM db_root) d ORDER BY 1;

evaluate 'Case 20: DOUBLE - a nested loop join memoized by -0 and 0 returns the rows of the join without memoize; 50 100 100';
DROP TABLE IF EXISTS tzc, tzd;
CREATE TABLE tzc (ca INT, cb DOUBLE);
CREATE TABLE tzd (ca VARCHAR (10), cb INT);
INSERT INTO tzc SELECT ROWNUM, CASE WHEN ROWNUM <= 50 THEN CAST (0 AS DOUBLE) ELSE -CAST (0 AS DOUBLE) END FROM db_class a, db_class b LIMIT 100;
INSERT INTO tzd VALUES ('0', 1), ('-0', 2);
UPDATE STATISTICS ON tzc, tzd WITH FULLSCAN;
set system parameters 'memoize_memory_limit=64M';
SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(tzd) */ SUM (CASE WHEN tzc.ca <= 50 THEN tzd.cb ELSE 0 END), SUM (CASE WHEN tzc.ca > 50 THEN tzd.cb ELSE 0 END), COUNT (*) FROM tzc INNER JOIN tzd ON tzd.ca = tzc.cb || '';
set system parameters 'memoize_memory_limit=0';
SELECT /*+ RECOMPILE PARALLEL(0) ORDERED USE_NL(tzd) */ SUM (CASE WHEN tzc.ca <= 50 THEN tzd.cb ELSE 0 END), SUM (CASE WHEN tzc.ca > 50 THEN tzd.cb ELSE 0 END), COUNT (*) FROM tzc INNER JOIN tzd ON tzd.ca = tzc.cb || '';
set system parameters 'memoize_memory_limit=default';

evaluate 'Case 21: SET OF a class - hash join returns the pairs of the nested loop join';
DROP TABLE IF EXISTS tze, tzf, tzg;
CREATE TABLE tzg (ca INT) DONT_REUSE_OID;
INSERT INTO tzg VALUES (1), (2);
CREATE TABLE tze (ca INT, cb SET OF tzg);
CREATE TABLE tzf (ca INT, cb SET OF tzg);
INSERT INTO tze SELECT x.ca, {x} FROM tzg x;
INSERT INTO tzf SELECT x.ca + 10, {x} FROM tzg x;
UPDATE STATISTICS ON tze, tzf WITH FULLSCAN;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tze.ca, tzf.ca FROM tze, tzf WHERE tze.cb = tzf.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tze.ca, tzf.ca FROM tze, tzf WHERE tze.cb = tzf.cb ORDER BY 1, 2;

evaluate 'Case 22: SET of several element types, SEQUENCE OF SET and SEQUENCE of no element type - a correlated subquery keyed by the column returns the uncached results';
-- {1} and {1.0} of SET (INT, DOUBLE) compare equal and hash alike, but the subquery returns each as it is
DROP TABLE IF EXISTS tzh, tzi, tzj;
CREATE TABLE tzh (ca INT, cb SET (INT, DOUBLE));
INSERT INTO tzh VALUES (301, {1}), (302, {CAST (1 AS DOUBLE)}), (303, {1});
SELECT tzh.ca, (SELECT tzh.cb FROM db_root) FROM tzh ORDER BY 1;
SELECT tzh.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ tzh.cb FROM db_root) FROM tzh ORDER BY 1;
-- CREATE TABLE AS SELECT makes the column SEQUENCE OF SET OF INTEGER: {{1}} and {{1, 2}} keys repeat;
-- the subquery returns whether the key is {{1}}, which the JDBC driver reads (it cannot read a SEQUENCE OF SET,
-- which no CAST turns into a string)
CREATE TABLE tzi AS SELECT 311 ca, {SET {1}} cb FROM db_root;
INSERT INTO tzi SELECT 312, {SET {1, 2}} FROM db_root;
INSERT INTO tzi SELECT 313, {SET {1}} FROM db_root;
INSERT INTO tzi SELECT 314, {SET {2, 1}} FROM db_root;
SELECT tzi.ca, (SELECT tzi.cb = {SET {1}} FROM db_root) FROM tzi ORDER BY 1;
SELECT tzi.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ tzi.cb = {SET {1}} FROM db_root) FROM tzi ORDER BY 1;
-- a SEQUENCE of no element type holds elements of any type: {1}, {1.0} and {1.00} compare equal, but the subquery
-- returns each as it is; the keys {1} and {1.0} repeat
CREATE TABLE tzj (ca INT, cb SEQUENCE);
INSERT INTO tzj VALUES (321, {1}), (322, {1.0}), (323, {1.00}), (324, {1}), (325, {1.0});
SELECT tzj.ca, (SELECT tzj.cb FROM db_root) FROM tzj ORDER BY 1;
SELECT tzj.ca, (SELECT /*+ NO_SUBQUERY_CACHE */ tzj.cb FROM db_root) FROM tzj ORDER BY 1;

evaluate 'Case 23: NUMERIC and string to FLOAT - a value just off the midpoint of two FLOATs converts to the nearest one';
-- the FLOAT nearest to 1.0000000596046447753906250001 is 1 + 2^-23 (1.00000011920928955078125) and the one nearest to
-- 5189924.749999999751703 is 5189924.5; a conversion through DOUBLE rounds each to the midpoint and then to the even
-- FLOAT, 1 and 5189925
SELECT CASE WHEN CAST (1.0000000596046447753906250001 AS FLOAT) = CAST (1.00000011920928955078125 AS FLOAT)
             AND CAST (5189924.749999999751703 AS FLOAT) = CAST (5189924.5 AS FLOAT)
            THEN 'PASS' ELSE 'FAIL' END numeric_to_float,
       CASE WHEN CAST ('1.0000000596046447753906250001' AS FLOAT) = CAST (1.00000011920928955078125 AS FLOAT)
             AND CAST ('5189924.749999999751703' AS FLOAT) = CAST (5189924.5 AS FLOAT)
            THEN 'PASS' ELSE 'FAIL' END string_to_float;

evaluate 'Case 24: SET, MULTISET and SEQUENCE across kinds - hash join returns the pairs of the nested loop join';
-- a key of two collection kinds hashes in the domain of one, the other converted into it with its elements, and its
-- pairs compare with coercion; a SET keeps its elements sorted and once ({2, 1} and {1, 2, 2} hold {1, 2}), a MULTISET
-- compares sorted, a SEQUENCE in its order
-- tzk SET (INT)     : 1 {1, 2}, 2 {2, 1}, 3 {3}, 4 {1, 2, 2}, 5 {}
-- tzl SEQUENCE (INT): 11 {1, 2}, 12 {2, 1}, 13 {3}, 14 {1, 2, 2}, 15 {}, 16 {1, 1, 2}
-- tzm SEQUENCE (NUMERIC (10, 2)): 21 {1.00, 2.00}, 22 {2.00, 1.00}, 23 {3.00}, 24 {1.50}
-- tzn MULTISET (INT): 31 {1, 2}, 32 {2, 1}, 33 {1, 2, 2}, 34 {1, 1, 2}
-- SET = SEQUENCE           : (1, 11), (2, 11), (3, 13), (4, 11), (5, 15)
-- SET = SEQUENCE (NUMERIC) : (1, 21), (2, 21), (3, 23), (4, 21)
-- MULTISET = SEQUENCE      : (31, 11), (31, 12), (32, 11), (32, 12), (33, 14), (34, 16)
-- SET = MULTISET           : (1, 31), (1, 32), (2, 31), (2, 32), (4, 31), (4, 32)
DROP TABLE IF EXISTS tzk, tzl, tzm, tzn;
CREATE TABLE tzk (ca INT, cb SET (INT));
INSERT INTO tzk VALUES (1, {1, 2}), (2, {2, 1}), (3, {3}), (4, {1, 2, 2}), (5, {});
CREATE TABLE tzl (ca INT, cb SEQUENCE (INT));
INSERT INTO tzl VALUES (11, {1, 2}), (12, {2, 1}), (13, {3}), (14, {1, 2, 2}), (15, {}), (16, {1, 1, 2});
CREATE TABLE tzm (ca INT, cb SEQUENCE (NUMERIC (10, 2)));
INSERT INTO tzm VALUES (21, {1.00, 2.00}), (22, {2.00, 1.00}), (23, {3.00}), (24, {1.50});
CREATE TABLE tzn (ca INT, cb MULTISET (INT));
INSERT INTO tzn VALUES (31, {1, 2}), (32, {2, 1}), (33, {1, 2, 2}), (34, {1, 1, 2});
UPDATE STATISTICS ON tzk, tzl, tzm, tzn WITH FULLSCAN;
-- SET = SEQUENCE
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tzk.ca, tzl.ca FROM tzk, tzl WHERE tzk.cb = tzl.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tzk.ca, tzl.ca FROM tzk, tzl WHERE tzk.cb = tzl.cb ORDER BY 1, 2;
-- SET = SEQUENCE (NUMERIC): the elements of two types as well
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tzk.ca, tzm.ca FROM tzk, tzm WHERE tzk.cb = tzm.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tzk.ca, tzm.ca FROM tzk, tzm WHERE tzk.cb = tzm.cb ORDER BY 1, 2;
-- MULTISET = SEQUENCE
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tzn.ca, tzl.ca FROM tzn, tzl WHERE tzn.cb = tzl.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tzn.ca, tzl.ca FROM tzn, tzl WHERE tzn.cb = tzl.cb ORDER BY 1, 2;
-- SET = MULTISET
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tzk.ca, tzn.ca FROM tzk, tzn WHERE tzk.cb = tzn.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tzk.ca, tzn.ca FROM tzk, tzn WHERE tzk.cb = tzn.cb ORDER BY 1, 2;

evaluate 'Case 25: JSON - CONNECT BY by a hash list scan returns the rows of the single-table plan';
-- a JSON key of CONNECT BY takes the hash list scan; its children of 1 are 1.0, "1" and 1, and of 2 are 2 and "2.0"
-- tzo: ca | id  | pid
--       1 | 1   | NULL
--       2 | 2   | 1.0
--       3 | 3   | "1"
--       4 | 4   | 1
--       5 | 5   | 2
--       6 | 6   | "2.0"
--       7 | 7   | [1]
--       8 | [1] | 1
--       9 | 9   | [1]
DROP TABLE IF EXISTS tzo;
CREATE TABLE tzo (ca INT, id JSON, pid JSON);
INSERT INTO tzo VALUES (1, '1', NULL), (2, '2', '1.0'), (3, '3', '"1"'), (4, '4', '1'), (5, '5', '2'), (6, '6', '"2.0"'), (7, '7', '[1]'), (8, '[1]', '1'), (9, '9', '[1]');
set trace on;
SELECT ca, LEVEL FROM tzo START WITH ca = 1 CONNECT BY PRIOR id = pid ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_HASH_LIST_SCAN */ ca, LEVEL FROM tzo START WITH ca = 1 CONNECT BY PRIOR id = pid ORDER BY 1, 2;

evaluate 'Case 26: SET OF NUMERIC - hash join of elements of their own scale (1.5 and 1.50) returns the pairs of the nested loop join';
-- a NUMERIC element of no precision keeps the scale of its value: {1.5} = {1.50} and {2} = {2.000}
DROP TABLE IF EXISTS tzq, tzp;
CREATE TABLE tzp (ca INT, cb SET (NUMERIC));
INSERT INTO tzp VALUES (1, {1.5}), (2, {2});
CREATE TABLE tzq (ca INT, cb SET (NUMERIC));
INSERT INTO tzq VALUES (11, {1.50}), (12, {2.000});
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tzp.ca, tzq.ca FROM tzp, tzq WHERE tzp.cb = tzq.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tzp.ca, tzq.ca FROM tzp, tzq WHERE tzp.cb = tzq.cb ORDER BY 1, 2;

evaluate 'Case 27: string to DOUBLE - a subnormal value converts to it, not to an overflow error';
-- 1e-310 is below the smallest normal DOUBLE (2.2250738585072014e-308); before the change it was an overflow error
SELECT CASE WHEN CAST ('1e-310' AS DOUBLE) > 0 AND CAST ('1e-310' AS DOUBLE) < 2.2250738585072014e-308
            THEN 'PASS' ELSE 'FAIL' END string_to_subnormal_double;

evaluate 'Case 28: JSON - an integer and a DOUBLE or a numeric string compare by their values at 2^53 and 2^63, and hash join returns the pairs of the nested loop join';
-- before the change the integer converted to DOUBLE, which rounds above 2^53
-- ca | cj                   | cn                       | cj against cn
-- ---+----------------------+--------------------------+---------------------------------------------
--  1 | 9007199254740993     | 9007199254740992.0       | gt: 2^53 + 1 and 2^53
--  2 | 9007199254740992     | 9007199254740992.0       | eq
--  3 | 9007199254740993     | "9007199254740993"       | gt: the string converts to the DOUBLE 2^53
--  4 | -9007199254740993    | -9007199254740992.0      | lt
--  5 | 9223372036854775807  | 9223372036854775807.0    | lt: the DOUBLE is 2^63, above every BIGINT
--  6 | -9223372036854775808 | -9223372036854775808.0   | eq: the DOUBLE is -2^63, the least BIGINT
--  7 | 2                    | 1.5                      | gt: the fraction decides
--  8 | -2                   | -1.5                     | lt
DROP TABLE IF EXISTS tzr;
CREATE TABLE tzr (ca INT, cj JSON, cn JSON);
INSERT INTO tzr VALUES (1, '9007199254740993', '9007199254740992.0'), (2, '9007199254740992', '9007199254740992.0'),
  (3, '9007199254740993', '"9007199254740993"'), (4, '-9007199254740993', '-9007199254740992.0'),
  (5, '9223372036854775807', '9223372036854775807.0'), (6, '-9223372036854775808', '-9223372036854775808.0'),
  (7, '2', '1.5'), (8, '-2', '-1.5');
SELECT ca, CASE WHEN cj = cn THEN 'eq' WHEN cj < cn THEN 'lt' WHEN cj > cn THEN 'gt' END cmp FROM tzr ORDER BY 1;
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ a.ca, b.ca FROM tzr a, tzr b WHERE a.cj = b.cn ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ a.ca, b.ca FROM tzr a, tzr b WHERE a.cj = b.cn ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc, td, te, tf, tg, th, ti, tj, tk, tl, tm, tn, tp, tq, tr, ts, tt, tu, tv, tw, tx, ty, tza, tzb, tzc, tzd, tze, tzf, tzg, tzh, tzi, tzj, tzk, tzl, tzm, tzn, tzo, tzp, tzq, tzr;
