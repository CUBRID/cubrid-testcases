/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash join, a hash GROUP BY, and a hash partition prune hash a string key with the hash
 *  function of its collation. The change hashes byte collations eight bytes at a time and makes
 *  the hash of every collation follow its comparison, so two keys that compare equal get one hash.
 *
 *  Each hash case has a twin that skips the hash path: a nested loop join, a sort GROUP BY, or a table without
 *  partitions. The verification block after each hash join and hash GROUP BY prints PASS when the hash query and its
 *  twin return the same rows as a multiset. A prune case counts the rows of each value in t_varchar_part and in
 *  t_varchar_a, and the two counts must match. SHOW TRACE shows the path that each hash case took. CTP masks the digits
 *  of a trace, so the answer checks only the path: HASHJOIN, hash true in GROUPBY, and one PARTITION line for the one
 *  value that a prune case traces after it counts the rows of every value.
 *
 *  The keys are strings that a loaded collation compares equal though their bytes differ (an accent, upper case, a soft
 *  hyphen of weight 0, and the expansions of sharp s and ae), and a pair that differs only at level 4.
 *
 *  Coverage:
 *    Case 1:  utf8_de_exp_ai_ci - hash join returns the pairs of the nested loop join
 *    Case 2:  utf8_de_exp_ai_ci - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY
 *    Case 3:  utf8_de_exp_ai_ci - t_varchar_part prune per constant reads one partition and matches t_varchar_a
 *    Case 4:  utf8_de_exp - a pair that differs only at level 4 joins as in the nested loop join
 *    Case 5:  utf8_km_exp - a pair that differs only at level 4 joins as in the nested loop join
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- utf8_de_exp_ai_ci: primary strength, expansions
DROP TABLE IF EXISTS t_varchar_part, t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
CREATE TABLE t_varchar_part (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 4: an accent, upper case and a soft hyphen of weight 0, all left out at level 1
-- ca | cb              | note
-- ---+-----------------+--------------------------------------
--  1 | 'cafes'         |
--  2 | 'caf<U+00E9>s'  | e acute U+00E9 (C3 A9)
--  3 | 'CAF<U+00C9>S'  | upper case and E acute U+00C9 (C3 89)
--  4 | 'caf<U+00AD>es' | soft hyphen U+00AD (C2 AD)
INSERT INTO t_varchar_a VALUES (1, 'cafes'), (2, 'cafés'), (3, 'CAFÉS'), (4, 'caf' || CHR (49837 USING utf8) || 'es');

-- 5 to 7: sharp s (U+00DF) expands to 'ss'
-- ca | cb              | note
-- ---+-----------------+-----------------------
--  5 | 'Strasse'       |
--  6 | 'Stra<U+00DF>e' | sharp s U+00DF (C3 9F)
--  7 | 'STRASSE'       | upper case
INSERT INTO t_varchar_a VALUES (5, 'Strasse'), (6, 'Straße'), (7, 'STRASSE');

-- 8 to 10: ae ligature (U+00E6) expands to 'ae'; 'ab' differs at level 1
-- ca | cb         | note
-- ---+------------+---------------------------
--  8 | 'ae'       |
--  9 | '<U+00E6>' | ae ligature U+00E6 (C3 A6)
-- 10 | 'ab'       |
INSERT INTO t_varchar_a VALUES (8, 'ae'), (9, 'æ'), (10, 'ab');

INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;
INSERT INTO t_varchar_part SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b, t_varchar_part WITH FULLSCAN;

evaluate 'Case 1: utf8_de_exp_ai_ci - hash join returns the pairs of the nested loop join';

SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca, t_varchar_b.ca
FROM t_varchar_a, t_varchar_b
WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca
ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: utf8_de_exp_ai_ci - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY';
select min(ca), count(*)
from t_varchar_a group by cb order by 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select min(ca) as min_ca, count(*) as cnt from t_varchar_a group by cb),
  sort_rows as (select /*+ no_hash_aggregate */ min(ca) as min_ca, count(*) as cnt from t_varchar_a group by cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

evaluate 'Case 3: utf8_de_exp_ai_ci - t_varchar_part prune per constant reads one partition and matches t_varchar_a';
-- 1 to 4: an accent, upper case and a soft hyphen of weight 0, all left out at level 1
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'cafes') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'cafes') AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'cafés') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'cafés') AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'CAFÉS') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'CAFÉS') AS cnt_part;

SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_part;

-- 5 to 7: sharp s (U+00DF) expands to 'ss'
SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'Strasse') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'Strasse') AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'Straße') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'Straße') AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'STRASSE') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'STRASSE') AS cnt_part;

-- 8 to 10: ae ligature (U+00E6) expands to 'ae'; 'ab' differs at level 1
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'ae') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'ae') AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'æ') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'æ') AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'ab') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'ab') AS cnt_part;

SELECT COUNT (*)
FROM t_varchar_part WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es';
show trace;

-- utf8_de_exp has tertiary strength. U+03A9 and U+2126 differ only at level 4
DROP TABLE IF EXISTS t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(10) COLLATE utf8_de_exp);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(10) COLLATE utf8_de_exp);

-- ca | cb         | note
-- ---+------------+------------------------------
--  1 | '<U+03A9>' | Greek capital omega (CE A9)
--  2 | '<U+2126>' | ohm sign (E2 84 A6)
INSERT INTO t_varchar_a VALUES (1, CHR (52905 USING utf8)), (2, CHR (14845094 USING utf8));
INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b WITH FULLSCAN;

evaluate 'Case 4: utf8_de_exp - a pair that differs only at level 4 joins as in the nested loop join';

SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca, t_varchar_b.ca,
  HEX (t_varchar_a.cb), HEX (t_varchar_b.cb)
FROM t_varchar_a, t_varchar_b
WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca
ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca, HEX (t_varchar_a.cb) AS hex_ta_cb, HEX (t_varchar_b.cb) AS hex_tb_cb FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca, HEX (t_varchar_a.cb) AS hex_ta_cb, HEX (t_varchar_b.cb) AS hex_tb_cb FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- utf8_km_exp has quaternary strength. U+03A9 and U+2126 differ only at level 4
DROP TABLE IF EXISTS t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(10) COLLATE utf8_km_exp);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(10) COLLATE utf8_km_exp);

-- ca | cb         | note
-- ---+------------+------------------------------
--  1 | '<U+03A9>' | Greek capital omega (CE A9)
--  2 | '<U+2126>' | ohm sign (E2 84 A6)
INSERT INTO t_varchar_a VALUES (1, CHR (52905 USING utf8)), (2, CHR (14845094 USING utf8));
INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b WITH FULLSCAN;

evaluate 'Case 5: utf8_km_exp - a pair that differs only at level 4 joins as in the nested loop join';

SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca, t_varchar_b.ca,
  HEX (t_varchar_a.cb), HEX (t_varchar_b.cb)
FROM t_varchar_a, t_varchar_b
WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca
ORDER BY 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca, HEX (t_varchar_a.cb) AS hex_ta_cb, HEX (t_varchar_b.cb) AS hex_tb_cb FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca),
  nl_rows as (SELECT /*+ NO_USE_HASH USE_NL */ t_varchar_a.ca AS t_varchar_a_ca, t_varchar_b.ca AS t_varchar_b_ca, HEX (t_varchar_a.cb) AS hex_ta_cb, HEX (t_varchar_b.cb) AS hex_tb_cb FROM t_varchar_a, t_varchar_b WHERE t_varchar_a.cb = t_varchar_b.cb AND t_varchar_a.ca < t_varchar_b.ca)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

-- cleanup
drop table if exists t_varchar_a, t_varchar_b, t_varchar_part;

set trace off;
