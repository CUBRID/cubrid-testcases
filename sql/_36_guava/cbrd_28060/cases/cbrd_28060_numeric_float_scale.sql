/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A NUMERIC without a precision keeps the scale of each value, up to 252 decimal places. The hash reduces the digits
 *  of a value mod 2^61 - 1 and divides them by 10^scale in that modulus, so one value written with more decimal places,
 *  past 40 as well, must get one hash. The hash join and the hash GROUP BY are followed by their nested loop join and
 *  sort GROUP BY twins.
 *
 *  Coverage:
 *    Case 1:  float NUMERIC - hash join of ta and tb returns the pairs of the nested loop join
 *    Case 2:  float NUMERIC - hash GROUP BY on tc returns the groups of the sort GROUP BY
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- ta and tb hold NUMERIC values without a precision, which keep the decimal places of each value.
-- tb holds the values of ta with more decimal places. The hash reduces the digits of a value mod 2^61 - 1
-- and divides them by 10^scale in that modulus, so each value must get one hash whatever its decimal places
DROP TABLE IF EXISTS ta;
CREATE TABLE ta (ca INT, cb NUMERIC);
-- ca | cb    | decimal places
-- ---+-------+------------------
--  1 | 1E-40 | 40 decimal places
--  2 | 1E-41 | 41 decimal places
--  3 | 1E-60 | 60 decimal places
--  4 | 0.5   | 1 decimal place
INSERT INTO ta VALUES
  (1, 0.0000000000000000000000000000000000000001),
  (2, 0.00000000000000000000000000000000000000001),
  (3, 0.000000000000000000000000000000000000000000000000000000000001),
  (4, 0.5);

DROP TABLE IF EXISTS tb;
CREATE TABLE tb (ca INT, cb NUMERIC);
-- ca | cb    | decimal places
-- ---+-------+----------------------------------------
-- 11 | 1E-40 | 41 decimal places
-- 12 | 1E-40 | 79 decimal places, 39 zeros after the 1
-- 21 | 1E-41 | 42 decimal places
-- 31 | 1E-60 | 61 decimal places
-- 32 | 1E-60 | 99 decimal places, 39 zeros after the 1
-- 41 | 0.5   | 2 decimal places
INSERT INTO tb VALUES
  (11, 0.00000000000000000000000000000000000000010),
  (12, 0.0000000000000000000000000000000000000001000000000000000000000000000000000000000),
  (21, 0.000000000000000000000000000000000000000010),
  (31, 0.0000000000000000000000000000000000000000000000000000000000010),
  (32, 0.000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000),
  (41, 0.50);

DROP TABLE IF EXISTS tc;
CREATE TABLE tc AS SELECT * FROM ta UNION ALL SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: float NUMERIC - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;

evaluate 'Case 2: float NUMERIC - hash GROUP BY on tc returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from tc group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from tc group by cb order by 1, 2;

-- cleanup
set trace off;

DROP TABLE IF EXISTS ta, tb, tc;
