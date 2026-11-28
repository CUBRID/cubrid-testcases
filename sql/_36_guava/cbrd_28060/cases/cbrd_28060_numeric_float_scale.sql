/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A NUMERIC without a precision keeps the scale of each value, up to 252 decimal places. The hash reduces the digits
 *  of a value mod 2^61 - 1 and divides them by 10^scale in that modulus, so one value written with more decimal places,
 *  past 40 as well, must get one hash. The verification blocks after the hash join and the hash GROUP BY print PASS
 *  when the hash query and its nested loop join or sort GROUP BY twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  float NUMERIC - hash join of t_numeric_a and t_numeric_b returns the pairs of the nested loop join
 *    Case 2:  float NUMERIC - hash GROUP BY on t_numeric_ab returns the groups of the sort GROUP BY
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

-- t_numeric_a and t_numeric_b hold NUMERIC values without a precision, which keep the decimal places of each value;
-- t_numeric_b holds the values of t_numeric_a with more decimal places, and t_numeric_ab the rows of both
DROP TABLE IF EXISTS t_numeric_a;
CREATE TABLE t_numeric_a (ca INT, cb NUMERIC);

-- ca | cb    | decimal places
-- ---+-------+------------------
--  1 | 1E-40 | 40 decimal places
--  2 | 1E-41 | 41 decimal places
--  3 | 1E-60 | 60 decimal places
--  4 | 0.5   | 1 decimal place
INSERT INTO t_numeric_a VALUES
  (1, 0.0000000000000000000000000000000000000001),
  (2, 0.00000000000000000000000000000000000000001),
  (3, 0.000000000000000000000000000000000000000000000000000000000001),
  (4, 0.5);

DROP TABLE IF EXISTS t_numeric_b;
CREATE TABLE t_numeric_b (ca INT, cb NUMERIC);

-- ca | cb    | decimal places
-- ---+-------+----------------------------------------
-- 11 | 1E-40 | 41 decimal places
-- 12 | 1E-40 | 79 decimal places, 39 zeros after the 1
-- 21 | 1E-41 | 42 decimal places
-- 31 | 1E-60 | 61 decimal places
-- 32 | 1E-60 | 99 decimal places, 39 zeros after the 1
-- 41 | 0.5   | 2 decimal places
INSERT INTO t_numeric_b VALUES
  (11, 0.00000000000000000000000000000000000000010),
  (12, 0.0000000000000000000000000000000000000001000000000000000000000000000000000000000),
  (21, 0.000000000000000000000000000000000000000010),
  (31, 0.0000000000000000000000000000000000000000000000000000000000010),
  (32, 0.000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000),
  (41, 0.50);

DROP TABLE IF EXISTS t_numeric_ab;
CREATE TABLE t_numeric_ab AS SELECT * FROM t_numeric_a UNION ALL SELECT * FROM t_numeric_b;

UPDATE STATISTICS ON t_numeric_a, t_numeric_b, t_numeric_ab WITH FULLSCAN;

evaluate 'Case 1: float NUMERIC - hash join of t_numeric_a and t_numeric_b returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_numeric_a x, t_numeric_b y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_numeric_a x, t_numeric_b y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_numeric_a x, t_numeric_b y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: float NUMERIC - hash GROUP BY on t_numeric_ab returns the groups of the sort GROUP BY';
select min(ca), count(*) from t_numeric_ab group by cb order by 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select min(ca) as min_ca, count(*) as cnt from t_numeric_ab group by cb),
  sort_rows as (select /*+ no_hash_aggregate */ min(ca) as min_ca, count(*) as cnt from t_numeric_ab group by cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- cleanup
set system parameters 'agg_hash_respect_order=default';

DROP TABLE IF EXISTS t_numeric_a, t_numeric_b, t_numeric_ab;

set trace off;
