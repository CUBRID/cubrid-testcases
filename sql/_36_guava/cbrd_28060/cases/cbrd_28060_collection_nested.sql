/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A collection element that is itself a collection compares equal to one of another collection type ({SET {1, 2}} =
 *  {SEQUENCE {1, 2}}), but the planner sees a column of SEQUENCE OF SET as a SEQUENCE OF INTEGER, so the hash join of
 *  such columns returned no pair before the change. A collection element now hashes by the sum of its elements hashes,
 *  whatever its collection type. A key built of a collection column ({tc.cb}) keeps the nested domain, which a hash
 *  join or a hash list scan hashes when its leaf element types do. Each hash join and hash list scan must return the
 *  rows of its nested loop twin.
 *
 *  Coverage:
 *    Case 1:  SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join returns the pairs of the nested loop join
 *    Case 2:  SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join
 *    Case 3:  SEQUENCE of a SET column - hash list scan of nested keys returns the rows of the nested loop scan
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- CREATE TABLE AS SELECT makes the columns SEQUENCE OF SET and SEQUENCE OF SEQUENCE
-- ta.ca | ta.cb
-- ------+---------------
--  91   | {{1, 2}}
--  92   | {{3}}
--  96   | {{1, 2}, {3}}
-- tb.ca | tb.cb
-- ------+---------------
--  93   | {{1, 2}}
--  94   | {{2, 1}}
--  95   | {{3}}
DROP TABLE IF EXISTS ta, tb;
CREATE TABLE ta AS SELECT 91 ca, {SET {1, 2}} cb FROM db_root;
INSERT INTO ta SELECT 92, {SET {3}} FROM db_root;
INSERT INTO ta SELECT 96, {SET {1, 2}, SET {3}} FROM db_root;
CREATE TABLE tb AS SELECT 93 ca, {SEQUENCE {1, 2}} cb FROM db_root;
INSERT INTO tb SELECT 94, {SEQUENCE {2, 1}} FROM db_root;
INSERT INTO tb SELECT 95, {SEQUENCE {3}} FROM db_root;
UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 1: SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb ORDER BY 1, 2;

-- {tc.cb} is a SEQUENCE OF SET OF INTEGER: against SET (INT) or SEQUENCE (INT) elements it hashes;
-- against SET (VARCHAR) elements ({{1}} = {{'1'}}), or with a leaf beside the set ({tc.cb, tc.ca}),
-- it joins by nested loop. Case 3 reads tc and td as well
DROP TABLE IF EXISTS tc, td;

-- ca  | cb
-- ----+--------
-- 201 | {1, 2}
-- 202 | {3}
CREATE TABLE tc (ca INT, cb SET (INT));
INSERT INTO tc VALUES (201, {1, 2}), (202, {3});

-- ca  | cb     | cc         | cd
-- ----+--------+------------+-------
-- 211 | {2, 1} | {'1', '2'} | {1, 2}
-- 212 | {3}    | {'3'}      | {3}
-- 213 | {4}    | {'x'}      | {2, 1}
CREATE TABLE td (ca INT, cb SET (INT), cc SET (VARCHAR (10)), cd SEQUENCE (INT));
INSERT INTO td VALUES (211, {2, 1}, {'1', '2'}, {1, 2}), (212, {3}, {'3'}, {3}), (213, {4}, {'x'}, {2, 1});

UPDATE STATISTICS ON tc, td WITH FULLSCAN;

evaluate 'Case 2: SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cb} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cd} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cc} ORDER BY 1, 2;
show trace;
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ tc.ca, td.ca FROM tc, td WHERE {tc.cb, tc.ca + 10} = {td.cb, td.ca} ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cb} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cd} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tc.ca, td.ca FROM tc, td WHERE {tc.cb} = {td.cc} ORDER BY 1, 2;
SELECT /*+ NO_USE_HASH USE_NL */ tc.ca, td.ca FROM tc, td WHERE {tc.cb, tc.ca + 10} = {td.cb, td.ca} ORDER BY 1, 2;

evaluate 'Case 3: SEQUENCE of a SET column - hash list scan of nested keys returns the rows of the nested loop scan';
-- y reads td with NO_MERGE, the build side of the hash list scan; {tc.cb} against {cb} or {cd} hashes;
-- against {cc} ({{3}} = {{'3'}}, which the hash list scan missed before the change), or with a leaf beside the set
-- ({cb, ca}), the scan reads y by nested loop
set trace on;
SELECT /*+ ORDERED PARALLEL(0) */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
show trace;
SELECT /*+ ORDERED PARALLEL(0) */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM td WHERE ca >= 1) y WHERE {tc.cb, tc.ca + 10} = y.c ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM td WHERE ca >= 1) y WHERE {tc.cb} = y.c ORDER BY 1, 2;
SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ tc.ca, y.ca FROM tc, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM td WHERE ca >= 1) y WHERE {tc.cb, tc.ca + 10} = y.c ORDER BY 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc, td;
