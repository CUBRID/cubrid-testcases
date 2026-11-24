/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash join hashes a NUMERIC key by its value. The change makes NUMERIC values of different declared scales that
 *  compare equal, such as 1.5 in NUMERIC(38,1) and in NUMERIC(38,20), get one hash. The verification block after each
 *  hash join prints PASS when the hash join and its nested loop join twin return the same rows as a multiset. SHOW
 *  TRACE shows HASHJOIN. Cases 1 to 55 join each pair of the t_numeric_<n> tables in the order of t_numeric_zero,
 *  t_numeric_one, t_numeric_two, t_numeric_three, t_numeric_nine, t_numeric_ten, t_numeric_eighteen,
 *  t_numeric_nineteen, t_numeric_twenty, t_numeric_thirtyseven, t_numeric_thirtyeight: Case 1 joins t_numeric_zero and
 *  t_numeric_one, Case 55 t_numeric_thirtyseven and t_numeric_thirtyeight.
 *
 *  Cases 56 and 57 join FLOAT and MONETARY keys with DOUBLE keys, which compare as DOUBLE: FLOAT 0.1 matches its own
 *  value as DOUBLE and not DOUBLE 0.1, -0.0 matches 0.0, and NaN matches NaN.
 *
 *  Coverage:
 *    Case 1 to 55:  NUMERIC - hash join of each pair of t_numeric_<n> returns the pairs of the nested loop join
 *    Case 56:       FLOAT and DOUBLE - hash join of t_float and t_double returns the pairs of the nested loop join
 *    Case 57:       MONETARY and DOUBLE - hash join of t_monetary and t_double returns the pairs of the nested
 *                   loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

DROP TABLE IF EXISTS t_numeric_zero;
CREATE TABLE t_numeric_zero (ca INT, cb NUMERIC(38,0));

-- t_numeric_<n> holds NUMERIC(38,<n>) values. The names spell <n> in letters because CTP masks the digits of a trace.
-- ca stands for one value in every t_numeric_<n> table, and each table holds the values that fit its scale
-- ca | cb
-- ---+-----------------------------------------
--  1 | 0
--  2 | 1
--  3 | 100
--  4 | 0.5
--  5 | 0.25
--  6 | 0.1
--  7 | 0.01
--  8 | 0.001
--  9 | 0.000001
-- 10 | 1.5
-- 11 | 12.34
-- 12 | 9.9
-- 13 | -0.5
-- 14 | 0.1234567890123456789
-- 15 | 0.00000000000000000001
-- 16 | 0.12345678901234567890123456789012345678
-- 17 | -1.0
-- 18 | -12.3
-- 19 | -123456789.0
INSERT INTO t_numeric_zero VALUES (1, 0), (2, 1), (3, 100), (17, -1.0), (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_one;
CREATE TABLE t_numeric_one (ca INT, cb NUMERIC(38,1));
INSERT INTO t_numeric_one VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (6, 0.1),
  (10, 1.5),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_two;
CREATE TABLE t_numeric_two (ca INT, cb NUMERIC(38,2));
INSERT INTO t_numeric_two VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_three;
CREATE TABLE t_numeric_three (ca INT, cb NUMERIC(38,3));
INSERT INTO t_numeric_three VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_nine;
CREATE TABLE t_numeric_nine (ca INT, cb NUMERIC(38,9));
INSERT INTO t_numeric_nine VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_ten;
CREATE TABLE t_numeric_ten (ca INT, cb NUMERIC(38,10));
INSERT INTO t_numeric_ten VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_eighteen;
CREATE TABLE t_numeric_eighteen (ca INT, cb NUMERIC(38,18));
INSERT INTO t_numeric_eighteen VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_nineteen;
CREATE TABLE t_numeric_nineteen (ca INT, cb NUMERIC(38,19));
INSERT INTO t_numeric_nineteen VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_twenty;
CREATE TABLE t_numeric_twenty (ca INT, cb NUMERIC(38,20));
INSERT INTO t_numeric_twenty VALUES
  (1, 0),
  (2, 1),
  (3, 100),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (11, 12.34),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (17, -1.0),
  (18, -12.3),
  (19, -123456789.0);

DROP TABLE IF EXISTS t_numeric_thirtyseven;
CREATE TABLE t_numeric_thirtyseven (ca INT, cb NUMERIC(38,37));
INSERT INTO t_numeric_thirtyseven VALUES
  (1, 0),
  (2, 1),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (10, 1.5),
  (12, 9.9),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (17, -1.0);

DROP TABLE IF EXISTS t_numeric_thirtyeight;
CREATE TABLE t_numeric_thirtyeight (ca INT, cb NUMERIC(38,38));
INSERT INTO t_numeric_thirtyeight VALUES
  (1, 0),
  (4, 0.5),
  (5, 0.25),
  (6, 0.1),
  (7, 0.01),
  (8, 0.001),
  (9, 0.000001),
  (13, -0.5),
  (14, 0.1234567890123456789),
  (15, 0.00000000000000000001),
  (16, 0.12345678901234567890123456789012345678);

UPDATE STATISTICS ON t_numeric_zero, t_numeric_one, t_numeric_two, t_numeric_three, t_numeric_nine, t_numeric_ten, t_numeric_eighteen, t_numeric_nineteen, t_numeric_twenty, t_numeric_thirtyseven, t_numeric_thirtyeight WITH FULLSCAN;

evaluate 'Case 1: NUMERIC - hash join of t_numeric_zero and t_numeric_one returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_one y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_one y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_one y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: NUMERIC - hash join of t_numeric_zero and t_numeric_two returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_two y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_two y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_two y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: NUMERIC - hash join of t_numeric_zero and t_numeric_three returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_three y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_three y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_three y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 4: NUMERIC - hash join of t_numeric_zero and t_numeric_nine returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_nine y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_nine y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_nine y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 5: NUMERIC - hash join of t_numeric_zero and t_numeric_ten returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_ten y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_ten y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_ten y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 6: NUMERIC - hash join of t_numeric_zero and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 7: NUMERIC - hash join of t_numeric_zero and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 8: NUMERIC - hash join of t_numeric_zero and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 9: NUMERIC - hash join of t_numeric_zero and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 10: NUMERIC - hash join of t_numeric_zero and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_zero x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_zero x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 11: NUMERIC - hash join of t_numeric_one and t_numeric_two returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_two y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_two y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_two y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 12: NUMERIC - hash join of t_numeric_one and t_numeric_three returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_three y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_three y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_three y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 13: NUMERIC - hash join of t_numeric_one and t_numeric_nine returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_nine y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_nine y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_nine y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 14: NUMERIC - hash join of t_numeric_one and t_numeric_ten returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_ten y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_ten y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_ten y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 15: NUMERIC - hash join of t_numeric_one and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 16: NUMERIC - hash join of t_numeric_one and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 17: NUMERIC - hash join of t_numeric_one and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 18: NUMERIC - hash join of t_numeric_one and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 19: NUMERIC - hash join of t_numeric_one and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_one x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_one x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 20: NUMERIC - hash join of t_numeric_two and t_numeric_three returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_three y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_three y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_three y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 21: NUMERIC - hash join of t_numeric_two and t_numeric_nine returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_nine y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_nine y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_nine y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 22: NUMERIC - hash join of t_numeric_two and t_numeric_ten returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_ten y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_ten y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_ten y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 23: NUMERIC - hash join of t_numeric_two and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 24: NUMERIC - hash join of t_numeric_two and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 25: NUMERIC - hash join of t_numeric_two and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 26: NUMERIC - hash join of t_numeric_two and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 27: NUMERIC - hash join of t_numeric_two and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_two x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_two x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 28: NUMERIC - hash join of t_numeric_three and t_numeric_nine returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_nine y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_nine y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_nine y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 29: NUMERIC - hash join of t_numeric_three and t_numeric_ten returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_ten y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_ten y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_ten y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 30: NUMERIC - hash join of t_numeric_three and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 31: NUMERIC - hash join of t_numeric_three and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 32: NUMERIC - hash join of t_numeric_three and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 33: NUMERIC - hash join of t_numeric_three and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 34: NUMERIC - hash join of t_numeric_three and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_three x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_three x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 35: NUMERIC - hash join of t_numeric_nine and t_numeric_ten returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_ten y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_ten y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_ten y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 36: NUMERIC - hash join of t_numeric_nine and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 37: NUMERIC - hash join of t_numeric_nine and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 38: NUMERIC - hash join of t_numeric_nine and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 39: NUMERIC - hash join of t_numeric_nine and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 40: NUMERIC - hash join of t_numeric_nine and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nine x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nine x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 41: NUMERIC - hash join of t_numeric_ten and t_numeric_eighteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_ten x, t_numeric_eighteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_eighteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_eighteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 42: NUMERIC - hash join of t_numeric_ten and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_ten x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 43: NUMERIC - hash join of t_numeric_ten and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_ten x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 44: NUMERIC - hash join of t_numeric_ten and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_ten x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 45: NUMERIC - hash join of t_numeric_ten and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_ten x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_ten x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 46: NUMERIC - hash join of t_numeric_eighteen and t_numeric_nineteen returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_eighteen x, t_numeric_nineteen y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_nineteen y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_nineteen y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 47: NUMERIC - hash join of t_numeric_eighteen and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_eighteen x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 48: NUMERIC - hash join of t_numeric_eighteen and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_eighteen x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 49: NUMERIC - hash join of t_numeric_eighteen and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_eighteen x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_eighteen x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 50: NUMERIC - hash join of t_numeric_nineteen and t_numeric_twenty returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nineteen x, t_numeric_twenty y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_twenty y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_twenty y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 51: NUMERIC - hash join of t_numeric_nineteen and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nineteen x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 52: NUMERIC - hash join of t_numeric_nineteen and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_nineteen x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_nineteen x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 53: NUMERIC - hash join of t_numeric_twenty and t_numeric_thirtyseven returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_twenty x, t_numeric_thirtyseven y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_twenty x, t_numeric_thirtyseven y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_twenty x, t_numeric_thirtyseven y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 54: NUMERIC - hash join of t_numeric_twenty and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_twenty x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_twenty x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_twenty x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 55: NUMERIC - hash join of t_numeric_thirtyseven and t_numeric_thirtyeight returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_thirtyseven x, t_numeric_thirtyeight y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_thirtyseven x, t_numeric_thirtyeight y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_thirtyseven x, t_numeric_thirtyeight y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- Cases 56 and 57 join FLOAT and MONETARY keys with DOUBLE keys, which compare as DOUBLE
DROP TABLE IF EXISTS t_float, t_double, t_monetary;
CREATE TABLE t_float (ca INT, cb FLOAT);

-- ca | cb
-- ---+-----------------------------------
--  1 | 0.1, the FLOAT nearest to 0.1
--  2 | -0.0
--  3 | 0.0
--  4 | 1.5
--  5 | 16777216, 2^24
--  6 | 3.4e38
--  7 | 1e-40, a subnormal FLOAT
--  8 | NaN
INSERT INTO t_float VALUES
  (1, CAST (0.1 AS FLOAT)), (2, -0e0), (3, 0e0), (4, 1.5), (5, 16777216), (6, 3.4e38), (7, 1e-40),
  (8, CAST ('nan' AS FLOAT));

CREATE TABLE t_double (ca INT, cb DOUBLE);

-- ca 2, 8 and 9 hold FLOAT values of t_float as DOUBLE; ca 1 holds the DOUBLE nearest to 0.1, which no FLOAT equals
-- ca | cb
-- ---+-----------------------------------
--  1 | 0.1
--  2 | FLOAT 0.1
--  3 | -0.0
--  4 | 0.0
--  5 | 1.5
--  6 | 16777217, 2^24 + 1
--  7 | 16777216
--  8 | FLOAT 3.4e38
--  9 | FLOAT 1e-40
-- 10 | NaN
INSERT INTO t_double VALUES
  (1, 0.1), (2, CAST (CAST (0.1 AS FLOAT) AS DOUBLE)), (3, -0e0), (4, 0e0), (5, 1.5), (6, 16777217), (7, 16777216),
  (8, CAST (CAST (3.4e38 AS FLOAT) AS DOUBLE)), (9, CAST (CAST (1e-40 AS FLOAT) AS DOUBLE)), (10, CAST ('nan' AS DOUBLE));

CREATE TABLE t_monetary (ca INT, cb MONETARY);

-- ca | cb
-- ---+----------
--  1 | 0.1
--  2 | -0.0
--  3 | 0
--  4 | 1.5
--  5 | 16777216
INSERT INTO t_monetary VALUES (1, 0.1), (2, -0e0), (3, 0), (4, 1.5), (5, 16777216);

UPDATE STATISTICS ON t_float, t_double, t_monetary WITH FULLSCAN;

evaluate 'Case 56: FLOAT and DOUBLE - hash join of t_float and t_double returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_float x, t_double y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_float x, t_double y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_float x, t_double y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 57: MONETARY and DOUBLE - hash join of t_monetary and t_double returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_monetary x, t_double y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_monetary x, t_double y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_monetary x, t_double y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
DROP TABLE IF EXISTS t_numeric_zero, t_numeric_one, t_numeric_two, t_numeric_three, t_numeric_nine, t_numeric_ten, t_numeric_eighteen, t_numeric_nineteen, t_numeric_twenty, t_numeric_thirtyseven, t_numeric_thirtyeight;
DROP TABLE IF EXISTS t_float, t_double, t_monetary;

set trace off;
