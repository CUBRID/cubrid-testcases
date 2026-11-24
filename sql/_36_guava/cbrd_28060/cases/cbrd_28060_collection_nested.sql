/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A collection element that is itself a collection compares equal to one of another collection type ({SET {1, 2}} =
 *  {SEQUENCE {1, 2}}), but the planner sees a column of SEQUENCE OF SET as a SEQUENCE OF INTEGER. Before the change,
 *  the hash join of such columns returned no pair. The change hashes a collection element by the sum of the hashes of
 *  its elements, whatever its collection type. A key built of a collection column ({t_set_int.cb}) keeps the nested
 *  domain, which a hash join or a hash list scan hashes when its leaf element types do. The verification block after
 *  each hash join and hash list scan prints PASS when the query and its nested loop twin return the same rows as a
 *  multiset.
 *
 *  Coverage:
 *    Case 1:  SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join of t_sequence_set and t_sequence_sequence returns
 *             the pairs of the nested loop join
 *    Case 2:  SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join
 *    Case 3:  SEQUENCE of a SET column - hash list scan of nested keys returns the pairs of the join without the hash
 *             list scan
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_sequence_set, t_sequence_sequence;

-- CREATE TABLE AS SELECT makes the columns SEQUENCE OF SET and SEQUENCE OF SEQUENCE
-- t_sequence_set
-- ca | cb
-- ---+--------------
-- 91 | {{1, 2}}
-- 92 | {{3}}
-- 96 | {{1, 2}, {3}}
CREATE TABLE t_sequence_set AS SELECT 91 ca, {SET {1, 2}} cb FROM db_root;
INSERT INTO t_sequence_set SELECT 92, {SET {3}} FROM db_root;
INSERT INTO t_sequence_set SELECT 96, {SET {1, 2}, SET {3}} FROM db_root;

-- t_sequence_sequence
-- ca | cb
-- ---+---------
-- 93 | {{1, 2}}
-- 94 | {{2, 1}}
-- 95 | {{3}}
CREATE TABLE t_sequence_sequence AS SELECT 93 ca, {SEQUENCE {1, 2}} cb FROM db_root;
INSERT INTO t_sequence_sequence SELECT 94, {SEQUENCE {2, 1}} FROM db_root;
INSERT INTO t_sequence_sequence SELECT 95, {SEQUENCE {3}} FROM db_root;
UPDATE STATISTICS ON t_sequence_set, t_sequence_sequence WITH FULLSCAN;

evaluate 'Case 1: SEQUENCE OF SET and SEQUENCE OF SEQUENCE - hash join of t_sequence_set and t_sequence_sequence returns the pairs of the nested loop join';
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_sequence_set.ca,
  t_sequence_sequence.ca
FROM t_sequence_set, t_sequence_sequence WHERE t_sequence_set.cb = t_sequence_sequence.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_sequence_set.ca as t_sequence_set_ca, t_sequence_sequence.ca as t_sequence_sequence_ca FROM t_sequence_set, t_sequence_sequence WHERE t_sequence_set.cb = t_sequence_sequence.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_sequence_set.ca as t_sequence_set_ca, t_sequence_sequence.ca as t_sequence_sequence_ca FROM t_sequence_set, t_sequence_sequence WHERE t_sequence_set.cb = t_sequence_sequence.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- {t_set_int.cb} is a SEQUENCE OF SET OF INTEGER: against SET (INT) or SEQUENCE (INT) elements it hashes;
-- against SET (VARCHAR) elements ({{1}} = {{'1'}}), or with a leaf beside the set ({t_set_int.cb, t_set_int.ca}),
-- it joins by nested loop. Case 3 reads t_set_int and t_collections as well
DROP TABLE IF EXISTS t_set_int, t_collections;

CREATE TABLE t_set_int (ca INT, cb SET (INT));

-- ca  | cb
-- ----+--------
-- 201 | {1, 2}
-- 202 | {3}
INSERT INTO t_set_int VALUES (201, {1, 2}), (202, {3});

CREATE TABLE t_collections (ca INT, cb SET (INT), cc SET (VARCHAR (10)), cd SEQUENCE (INT));

-- ca  | cb     | cc         | cd
-- ----+--------+------------+-------
-- 211 | {2, 1} | {'1', '2'} | {1, 2}
-- 212 | {3}    | {'3'}      | {3}
-- 213 | {4}    | {'x'}      | {2, 1}
INSERT INTO t_collections VALUES (211, {2, 1}, {'1', '2'}, {1, 2}), (212, {3}, {'3'}, {3}), (213, {4}, {'x'}, {2, 1});

UPDATE STATISTICS ON t_set_int, t_collections WITH FULLSCAN;

evaluate 'Case 2: SEQUENCE of a SET column - hash join of nested keys returns the pairs of the nested loop join';
SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_collections.ca
FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cb} ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cb}),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cb})
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_collections.ca
FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cd} ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cd}),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cd})
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_collections.ca
FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cc} ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cc}),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb} = {t_collections.cc})
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca, t_collections.ca
FROM t_set_int, t_collections
WHERE {t_set_int.cb, t_set_int.ca + 10} = {t_collections.cb, t_collections.ca} ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb, t_set_int.ca + 10} = {t_collections.cb, t_collections.ca}),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_set_int.ca as t_set_int_ca, t_collections.ca as t_collections_ca FROM t_set_int, t_collections WHERE {t_set_int.cb, t_set_int.ca + 10} = {t_collections.cb, t_collections.ca})
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: SEQUENCE of a SET column - hash list scan of nested keys returns the pairs of the join without the hash list scan';
-- y reads t_collections with NO_MERGE, the build side of the hash list scan; {t_set_int.cb} against {cb} or {cd}
-- hashes; against {cc} ({{3}} = {{'3'}}), or with a leaf beside the set ({cb, ca}), the scan reads y by nested loop
SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca, y.ca
FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM t_collections WHERE ca >= 1) y
WHERE {t_set_int.cb} = y.c ORDER BY 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c),
  listscan_rows as (SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca, y.ca
FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM t_collections WHERE ca >= 1) y
WHERE {t_set_int.cb} = y.c ORDER BY 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c),
  listscan_rows as (SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cd} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca, y.ca
FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM t_collections WHERE ca >= 1) y
WHERE {t_set_int.cb} = y.c ORDER BY 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c),
  listscan_rows as (SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cc} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb} = y.c)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca, y.ca
FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM t_collections WHERE ca >= 1) y
WHERE {t_set_int.cb, t_set_int.ca + 10} = y.c ORDER BY 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (SELECT /*+ ORDERED PARALLEL(0) */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb, t_set_int.ca + 10} = y.c),
  listscan_rows as (SELECT /*+ ORDERED PARALLEL(0) NO_HASH_LIST_SCAN */ t_set_int.ca as t_set_int_ca, y.ca as y_ca FROM t_set_int, (SELECT /*+ NO_MERGE */ ca, {cb, ca} c FROM t_collections WHERE ca >= 1) y WHERE {t_set_int.cb, t_set_int.ca + 10} = y.c)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_sequence_set, t_sequence_sequence, t_set_int, t_collections;

set trace off;
