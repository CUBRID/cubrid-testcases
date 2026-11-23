/**
 *  This test case verifies CBRD-28060: Hash strings in multi-byte words consistently with string comparison
 *
 *  A hash join, a hash GROUP BY, and a hash partition prune hash a string key with the hash
 *  function of its collation. The change hashes byte collations eight bytes at a time and makes
 *  the hash of every collation follow its comparison, so two keys that compare equal get one hash.
 *
 *  Each hash case is followed by a twin that skips the hash path - a nested loop join, a sort
 *  GROUP BY, or a table without partitions - and the two results must match row by row.
 *  SHOW TRACE shows the path that each hash case took. CTP masks the digits of a trace, so the
 *  answer checks only the path - HASHJOIN, hash true in GROUPBY, and one PARTITION line for each
 *  value of a prune case.
 *
 *  The keys are strings that a loaded collation compares as equal though their bytes differ - an
 *  accent, upper case, a soft hyphen of weight 0, and the expansions of sharp s and ae - and a pair
 *  that differs only at level 4.
 *
 *  Coverage:
 *    Case 1:  utf8_de_exp_ai_ci - hash join returns the pairs of the nested loop join
 *    Case 2:  utf8_de_exp_ai_ci - hash GROUP BY on ta returns the groups of the sort GROUP BY
 *    Case 3:  utf8_de_exp_ai_ci - tc prune per constant reads one partition and matches ta
 *    Case 4:  utf8_de_exp - a pair that differs only at level 4 joins as in the nested loop join
 *    Case 5:  utf8_km_exp - a pair that differs only at level 4 joins as in the nested loop join
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- utf8_de_exp_ai_ci: primary strength, expansions
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci) PARTITION BY HASH (cb) PARTITIONS 7;
-- 1 to 4: an accent, upper case and a soft hyphen of weight 0, all left out at level 1
-- ca | cb              | note
-- ---+-----------------+---------------------------
--  1 | 'cafes'         |
--  2 | 'cafés'         | é (C3 A9)
--  3 | 'CAFÉS'         | upper case and É (C3 89)
--  4 | 'caf<U+00AD>es' | soft hyphen U+00AD (C2 AD)
INSERT INTO ta VALUES (1, 'cafes'), (2, 'cafés'), (3, 'CAFÉS'), (4, 'caf' || CHR (49837 USING utf8) || 'es');

-- 5 to 7: 'ß' expands to 'ss'
-- ca | cb        | note
-- ---+-----------+-----------
--  5 | 'Strasse' |
--  6 | 'Straße'  | ß (C3 9F)
--  7 | 'STRASSE' | upper case
INSERT INTO ta VALUES (5, 'Strasse'), (6, 'Straße'), (7, 'STRASSE');

-- 8 to 10: 'æ' expands to 'ae'; 'ab' differs at level 1
-- ca | cb   | note
-- ---+------+----------
--  8 | 'ae' |
--  9 | 'æ'  | æ (C3 A6)
-- 10 | 'ab' |
INSERT INTO ta VALUES (8, 'ae'), (9, 'æ'), (10, 'ab');

INSERT INTO tb SELECT * FROM ta;
INSERT INTO tc SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: utf8_de_exp_ai_ci - hash join returns the pairs of the nested loop join';
set trace on;
SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca
FROM ta, tb
WHERE ta.cb = tb.cb AND ta.ca < tb.ca
ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca FROM ta, tb WHERE ta.cb = tb.cb AND ta.ca < tb.ca ORDER BY 1, 2;

evaluate 'Case 2: utf8_de_exp_ai_ci - hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

evaluate 'Case 3: utf8_de_exp_ai_ci - tc prune per constant reads one partition and matches ta';
set trace on;
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'cafes') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'cafes') AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'cafés') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'cafés') AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'CAFÉS') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'CAFÉS') AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'Strasse') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'Strasse') AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'Straße') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'Straße') AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'STRASSE') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'STRASSE') AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'ae') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'ae') AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'æ') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'æ') AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = 'ab') AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = 'ab') AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_de_exp has tertiary strength. U+03A9 and U+2126 differ only at level 4
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(10) COLLATE utf8_de_exp);
CREATE TABLE tb (ca INT, cb VARCHAR(10) COLLATE utf8_de_exp);
-- ca | cb         | note
-- ---+------------+------------------------------
--  1 | '<U+03A9>' | Greek capital omega (CE A9)
--  2 | '<U+2126>' | ohm sign (E2 84 A6)
INSERT INTO ta VALUES (1, CHR (52905 USING utf8)), (2, CHR (14845094 USING utf8));
INSERT INTO tb SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 4: utf8_de_exp - a pair that differs only at level 4 joins as in the nested loop join';
set trace on;
SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca, HEX (ta.cb), HEX (tb.cb)
FROM ta, tb
WHERE ta.cb = tb.cb AND ta.ca < tb.ca
ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca, HEX (ta.cb), HEX (tb.cb) FROM ta, tb WHERE ta.cb = tb.cb AND ta.ca < tb.ca ORDER BY 1, 2;

-- utf8_km_exp has quaternary strength. U+03A9 and U+2126 differ only at level 4
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(10) COLLATE utf8_km_exp);
CREATE TABLE tb (ca INT, cb VARCHAR(10) COLLATE utf8_km_exp);
-- ca | cb         | note
-- ---+------------+------------------------------
--  1 | '<U+03A9>' | Greek capital omega (CE A9)
--  2 | '<U+2126>' | ohm sign (E2 84 A6)
INSERT INTO ta VALUES (1, CHR (52905 USING utf8)), (2, CHR (14845094 USING utf8));
INSERT INTO tb SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 5: utf8_km_exp - a pair that differs only at level 4 joins as in the nested loop join';
set trace on;
SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ ta.ca, tb.ca, HEX (ta.cb), HEX (tb.cb)
FROM ta, tb
WHERE ta.cb = tb.cb AND ta.ca < tb.ca
ORDER BY 1, 2;
show trace;
set trace off;
SELECT /*+ NO_USE_HASH USE_NL */ ta.ca, tb.ca, HEX (ta.cb), HEX (tb.cb) FROM ta, tb WHERE ta.cb = tb.cb AND ta.ca < tb.ca ORDER BY 1, 2;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
