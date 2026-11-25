/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash partition prune hashes a string constant with the hash function of the collation of the key. The change makes
 *  the hash of every collation follow its comparison, so a constant reads the partition of every key that compares
 *  equal to it.
 *
 *  The prune case counts the rows of each value in t_varchar_part and in t_varchar_a, and the two counts must match.
 *  Each constant is a string without a COLLATE clause, which the prune converts into the collation of the key before it
 *  hashes it. SHOW TRACE shows the path that the case took. CTP masks the digits of a trace, so the answer checks only
 *  the path: one PARTITION line for the one value that the case traces after it counts the rows of every value.
 *
 *  The keys are strings that the loaded collation utf8_de_exp_ai_ci compares equal though their bytes differ (an
 *  accent, upper case, a soft hyphen of weight 0, and the expansions of sharp s and ae). The hash join, the hash GROUP
 *  BY, and the hash list scan of these keys are the cases of cbrd_28060_varchar_utf8_de_exp_ai_ci.
 *
 *  Coverage:
 *    Case 1:  utf8_de_exp_ai_ci - t_varchar_part prune per VARCHAR(40) constant reads one partition and matches
 *             t_varchar_a
 */

set trace on;

-- utf8_de_exp_ai_ci: primary strength, expansions
DROP TABLE IF EXISTS t_varchar_part, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
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

INSERT INTO t_varchar_part SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_part WITH FULLSCAN;

evaluate 'Case 1: utf8_de_exp_ai_ci - t_varchar_part prune per VARCHAR(40) constant reads one partition and matches t_varchar_a';
-- 1 to 4: an accent, upper case and a soft hyphen of weight 0, all left out at level 1
SELECT 1 AS ca, '[cafes]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'cafes') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'cafes') AS cnt_part;

SELECT 2 AS ca, '[caf<U+00E9>s]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'cafés') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'cafés') AS cnt_part;

SELECT 3 AS ca, '[CAF<U+00C9>S]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'CAFÉS') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'CAFÉS') AS cnt_part;

SELECT 4 AS ca, '[caf<U+00AD>es]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es') AS cnt_part;

-- 5 to 7: sharp s (U+00DF) expands to 'ss'
SELECT 5 AS ca, '[Strasse]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'Strasse') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'Strasse') AS cnt_part;

SELECT 6 AS ca, '[Stra<U+00DF>e]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'Straße') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'Straße') AS cnt_part;

SELECT 7 AS ca, '[STRASSE]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'STRASSE') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'STRASSE') AS cnt_part;

-- 8 to 10: ae ligature (U+00E6) expands to 'ae'; 'ab' differs at level 1
SELECT 8 AS ca, '[ae]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'ae') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'ae') AS cnt_part;

SELECT 9 AS ca, '[<U+00E6>]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'æ') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'æ') AS cnt_part;

SELECT 10 AS ca, '[ab]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = 'ab') AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'ab') AS cnt_part;

SELECT COUNT (*) FROM t_varchar_part WHERE cb = 'caf' || CHR (49837 USING utf8) || 'es';
show trace;

-- cleanup
drop table if exists t_varchar_a, t_varchar_part;

set trace off;
