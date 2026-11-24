/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A collection declared with several element types hashes when all of them share one element hash type (exact numbers,
 *  DOUBLE and MONETARY, or strings of one collation), and its hash join returns the pairs of its nested loop join twin.
 *  One that mixes two hash types (INT and VARCHAR, INT and FLOAT) is joined by the nested loop under a hash join hint.
 *  SHOW TRACE shows which join runs. The verification block after each join prints PASS when the join and its twin
 *  return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  SET of several element types of one hash type - hash join returns the pairs of the nested loop join
 *    Case 2:  SET of element types of two hash types - joins by nested loop, with the pairs of the nested loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_exact_a, t_exact_b, t_string_a, t_string_b, t_int_double_a, t_int_double_b;

CREATE TABLE t_exact_a (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));

-- t_exact_a and t_exact_b: INT, BIGINT and NUMERIC(10,2) elements, which hash as the DOUBLE they equal
-- t_exact_a.ca | t_exact_a.cb         | t_exact_b.ca | t_exact_b.cb
-- -------------+----------------------+--------------+---------------------------
-- 101          | {1, 2}               | 111          | {CAST (1 AS BIGINT), 2.00}
-- 102          | {3}                  | 112          | {3.00}
-- 103          | {CAST (5 AS BIGINT)} | 113          | {5}
--              |                      | 114          | {4}
INSERT INTO t_exact_a VALUES (101, {1, 2}), (102, {3}), (103, {CAST (5 AS BIGINT)});
CREATE TABLE t_exact_b (ca INT, cb SET (INT, BIGINT, NUMERIC (10, 2)));
INSERT INTO t_exact_b VALUES (111, {CAST (1 AS BIGINT), 2.00}), (112, {3.00}), (113, {5}), (114, {4});

CREATE TABLE t_string_a (ca INT, cb SET (VARCHAR (10), CHAR (5)));

-- t_string_a and t_string_b: VARCHAR and CHAR elements of one collation, which hash without the trailing pad
-- t_string_a.ca | t_string_a.cb | t_string_b.ca | t_string_b.cb
-- --------------+---------------+---------------+------------------------------
-- 121           | {'a'}         | 131           | {CAST ('a' AS CHAR (5))}
-- 122           | {'b', 'c'}    | 132           | {'c', CAST ('b' AS CHAR (5))}
--               |               | 133           | {'d'}
INSERT INTO t_string_a VALUES (121, {'a'}), (122, {'b', 'c'});
CREATE TABLE t_string_b (ca INT, cb SET (VARCHAR (10), CHAR (5)));
INSERT INTO t_string_b VALUES (131, {CAST ('a' AS CHAR (5))}), (132, {'c', CAST ('b' AS CHAR (5))}), (133, {'d'});

CREATE TABLE t_int_double_a (ca INT, cb SET (INT, DOUBLE));

-- t_int_double_a and t_int_double_b: INT and DOUBLE elements, which hash as the DOUBLE they equal
-- t_int_double_a.ca | t_int_double_a.cb | t_int_double_b.ca | t_int_double_b.cb
-- ------------------+-------------------+-------------------+----------------------------
-- 181               | {1, 2.5e0}        | 191               | {CAST (1 AS DOUBLE), 2.5e0}
-- 182               | {3}               | 192               | {CAST (3 AS DOUBLE)}
--                   |                   | 193               | {4}
INSERT INTO t_int_double_a VALUES (181, {1, 2.5e0}), (182, {3});
CREATE TABLE t_int_double_b (ca INT, cb SET (INT, DOUBLE));
INSERT INTO t_int_double_b VALUES (191, {CAST (1 AS DOUBLE), 2.5e0}), (192, {CAST (3 AS DOUBLE)}), (193, {4});

UPDATE STATISTICS ON t_exact_a, t_exact_b, t_string_a, t_string_b, t_int_double_a, t_int_double_b WITH FULLSCAN;

evaluate 'Case 1: SET of several element types of one hash type - hash join returns the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_exact_a.ca, t_exact_b.ca
FROM t_exact_a, t_exact_b WHERE t_exact_a.cb = t_exact_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_exact_a.ca as t_exact_a_ca, t_exact_b.ca as t_exact_b_ca FROM t_exact_a, t_exact_b WHERE t_exact_a.cb = t_exact_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_exact_a.ca as t_exact_a_ca, t_exact_b.ca as t_exact_b_ca FROM t_exact_a, t_exact_b WHERE t_exact_a.cb = t_exact_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_string_a.ca, t_string_b.ca
FROM t_string_a, t_string_b WHERE t_string_a.cb = t_string_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_string_a.ca as t_string_a_ca, t_string_b.ca as t_string_b_ca FROM t_string_a, t_string_b WHERE t_string_a.cb = t_string_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_string_a.ca as t_string_a_ca, t_string_b.ca as t_string_b_ca FROM t_string_a, t_string_b WHERE t_string_a.cb = t_string_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_double_a.ca, t_int_double_b.ca
FROM t_int_double_a, t_int_double_b WHERE t_int_double_a.cb = t_int_double_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_double_a.ca as t_int_double_a_ca, t_int_double_b.ca as t_int_double_b_ca FROM t_int_double_a, t_int_double_b WHERE t_int_double_a.cb = t_int_double_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_int_double_a.ca as t_int_double_a_ca, t_int_double_b.ca as t_int_double_b_ca FROM t_int_double_a, t_int_double_b WHERE t_int_double_a.cb = t_int_double_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- {1} = {'1'} in t_int_varchar_a and t_int_varchar_b, and INT 16777217 = FLOAT 16777216 in t_int_float_a and
-- t_int_float_b: the comparison coerces the elements, the element hash tells them apart
DROP TABLE IF EXISTS t_int_varchar_a, t_int_varchar_b, t_int_float_a, t_int_float_b;

CREATE TABLE t_int_varchar_a (ca INT, cb SET (INT, VARCHAR (10)));

-- t_int_varchar_a and t_int_varchar_b: INT and VARCHAR elements
-- t_int_varchar_a.ca | t_int_varchar_a.cb | t_int_varchar_b.ca | t_int_varchar_b.cb
-- -------------------+--------------------+--------------------+-------------------
-- 141                | {1}                | 151                | {'1'}
-- 142                | {'x'}              | 152                | {1}
--                    |                    | 153                | {'x'}
INSERT INTO t_int_varchar_a VALUES (141, {1}), (142, {'x'});
CREATE TABLE t_int_varchar_b (ca INT, cb SET (INT, VARCHAR (10)));
INSERT INTO t_int_varchar_b VALUES (151, {'1'}), (152, {1}), (153, {'x'});

CREATE TABLE t_int_float_a (ca INT, cb SET (INT, FLOAT));

-- t_int_float_a and t_int_float_b: INT and FLOAT elements; 16777217 is 2^24 + 1, which FLOAT rounds to 2^24
-- t_int_float_a.ca | t_int_float_a.cb | t_int_float_b.ca | t_int_float_b.cb
-- -----------------+------------------+------------------+---------------------------
-- 161              | {16777217}       | 171              | {CAST (16777216 AS FLOAT)}
--                  |                  | 172              | {16777217}
INSERT INTO t_int_float_a VALUES (161, {16777217});
CREATE TABLE t_int_float_b (ca INT, cb SET (INT, FLOAT));
INSERT INTO t_int_float_b VALUES (171, {CAST (16777216 AS FLOAT)}), (172, {16777217});

UPDATE STATISTICS ON t_int_varchar_a, t_int_varchar_b, t_int_float_a, t_int_float_b WITH FULLSCAN;

evaluate 'Case 2: SET of element types of two hash types - joins by nested loop, with the pairs of the nested loop join';

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_varchar_a.ca, t_int_varchar_b.ca
FROM t_int_varchar_a, t_int_varchar_b WHERE t_int_varchar_a.cb = t_int_varchar_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_varchar_a.ca as t_int_varchar_a_ca, t_int_varchar_b.ca as t_int_varchar_b_ca FROM t_int_varchar_a, t_int_varchar_b WHERE t_int_varchar_a.cb = t_int_varchar_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_int_varchar_a.ca as t_int_varchar_a_ca, t_int_varchar_b.ca as t_int_varchar_b_ca FROM t_int_varchar_a, t_int_varchar_b WHERE t_int_varchar_a.cb = t_int_varchar_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_float_a.ca, t_int_float_b.ca
FROM t_int_float_a, t_int_float_b WHERE t_int_float_a.cb = t_int_float_b.cb ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH ORDERED NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_int_float_a.ca as t_int_float_a_ca, t_int_float_b.ca as t_int_float_b_ca FROM t_int_float_a, t_int_float_b WHERE t_int_float_a.cb = t_int_float_b.cb),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_int_float_a.ca as t_int_float_a_ca, t_int_float_b.ca as t_int_float_b_ca FROM t_int_float_a, t_int_float_b WHERE t_int_float_a.cb = t_int_float_b.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_exact_a, t_exact_b, t_string_a, t_string_b, t_int_double_a, t_int_double_b,
  t_int_varchar_a, t_int_varchar_b, t_int_float_a, t_int_float_b;

set trace off;
