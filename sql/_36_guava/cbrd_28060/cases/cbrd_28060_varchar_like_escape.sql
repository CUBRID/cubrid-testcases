/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A LIKE pattern with an ESCAPE character under a loaded UCA collation compares each segment of the pattern level by
 *  level. The change fixes two cases in which an escape character made the levels after level 1 compare the wrong
 *  characters:
 *    - utf8_de_exp compares the later levels forward from the end of the prefix that level 1 found equal, and counted
 *      that prefix in target bytes, which an escape character in the pattern put out of step
 *    - utf8_fr_exp_ab compares level 2 backward and read the character before the current one with the arguments of
 *      intl_back_utf8_to_cp () reversed
 *
 *  Each column of t_varchar holds the same string under a different collation, and utf8_bin gives the expected rows.
 *  Each query lists the ca of the rows that match one pattern under each collation, and the three lists must match.
 *  The escape character of every pattern is the exclamation mark.
 *
 *  Coverage:
 *    Case 1:  an escaped wildcard at the start, the middle and the end of a segment matches the same rows under
 *             utf8_bin, utf8_de_exp and utf8_fr_exp_ab
 *    Case 2:  an escape character that escapes itself, and one at the end of a pattern, match the same rows
 *    Case 3:  level 2 still tells an accent apart after an escape
 *    Case 4:  an escaped space at the start, the middle and the end of a pattern matches the same rows
 */

DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (
  ca INT,
  cb_bin VARCHAR(20) COLLATE utf8_bin,
  cb_de VARCHAR(20) COLLATE utf8_de_exp,
  cb_fr VARCHAR(20) COLLATE utf8_fr_exp_ab
);

-- ca | cb               | note
-- ---+------------------+---------------------------------------
--  1 | 'a%c'            | '%' in the middle
--  2 | 'abc'            | no wildcard character
--  3 | 'a_c'            | '_' in the middle
--  4 | '%bc'            | '%' at the start
--  5 | 'ab%'            | '%' at the end
--  6 | 'xa%c'           |
--  7 | 'a!c'            | the escape character in the middle
--  8 | 'ab!'            | the escape character at the end
--  9 | '<U+00C4>%c'     | A diaeresis U+00C4 (C3 84), level 2
-- 10 | 'A%c'            | differs from row 9 at level 2
-- 11 | 'c<U+00F4>t%'    | o circumflex U+00F4 (C3 B4), level 2
-- 12 | 'cot%'           | differs from row 11 at level 2
-- 13 | 'ab '            | one trailing space
-- 14 | 'ab  '           | two trailing spaces
-- 15 | 'a b'            | a space in the middle
-- 16 | ' ab'            | a leading space
INSERT INTO t_varchar VALUES
  (1, 'a%c', 'a%c', 'a%c'), (2, 'abc', 'abc', 'abc'), (3, 'a_c', 'a_c', 'a_c'), (4, '%bc', '%bc', '%bc'),
  (5, 'ab%', 'ab%', 'ab%'), (6, 'xa%c', 'xa%c', 'xa%c'), (7, 'a!c', 'a!c', 'a!c'), (8, 'ab!', 'ab!', 'ab!'),
  (9, 'Ä%c', 'Ä%c', 'Ä%c'), (10, 'A%c', 'A%c', 'A%c'), (11, 'côt%', 'côt%', 'côt%'), (12, 'cot%', 'cot%', 'cot%'),
  (13, 'ab ', 'ab ', 'ab '), (14, 'ab  ', 'ab  ', 'ab  '), (15, 'a b', 'a b', 'a b'), (16, ' ab', ' ab', ' ab');

evaluate 'Case 1: an escaped wildcard matches the same rows under utf8_bin, utf8_de_exp and utf8_fr_exp_ab';
SELECT 1 AS id, '[a!%c]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'a!%c' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'a!%c' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'a!%c' ESCAPE '!') AS rows_fr;

SELECT 2 AS id, '[!%bc]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE '!%bc' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE '!%bc' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE '!%bc' ESCAPE '!') AS rows_fr;

SELECT 3 AS id, '[ab!%]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'ab!%' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'ab!%' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'ab!%' ESCAPE '!') AS rows_fr;

SELECT 4 AS id, '[a!_c]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'a!_c' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'a!_c' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'a!_c' ESCAPE '!') AS rows_fr;

SELECT 5 AS id, '[%a!%c]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE '%a!%c' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE '%a!%c' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE '%a!%c' ESCAPE '!') AS rows_fr;

SELECT 6 AS id, '[a!%c%]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'a!%c%' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'a!%c%' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'a!%c%' ESCAPE '!') AS rows_fr;

evaluate 'Case 2: an escape character that escapes itself or ends a pattern matches the same rows';
-- the escape character escapes itself
SELECT 7 AS id, '[a!!c]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'a!!c' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'a!!c' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'a!!c' ESCAPE '!') AS rows_fr;

-- the escape character at the end of a pattern is a normal character
SELECT 8 AS id, '[ab!]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'ab!' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'ab!' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'ab!' ESCAPE '!') AS rows_fr;

evaluate 'Case 3: level 2 still tells an accent apart after an escape';
SELECT 9 AS id, '[<U+00C4>!%c]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'Ä!%c' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'Ä!%c' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'Ä!%c' ESCAPE '!') AS rows_fr;

SELECT 10 AS id, '[c<U+00F4>t!%]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'côt!%' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'côt!%' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'côt!%' ESCAPE '!') AS rows_fr;

evaluate 'Case 4: an escaped space matches the same rows under utf8_bin, utf8_de_exp and utf8_fr_exp_ab';
SELECT 11 AS id, '[ab! ]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'ab! ' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'ab! ' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'ab! ' ESCAPE '!') AS rows_fr;

SELECT 12 AS id, '[ab!  ]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'ab!  ' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'ab!  ' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'ab!  ' ESCAPE '!') AS rows_fr;

SELECT 13 AS id, '[ab! %]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'ab! %' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'ab! %' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'ab! %' ESCAPE '!') AS rows_fr;

SELECT 14 AS id, '[a! b]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE 'a! b' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE 'a! b' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE 'a! b' ESCAPE '!') AS rows_fr;

SELECT 15 AS id, '[! ab]' AS pattern,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_bin LIKE '! ab' ESCAPE '!') AS rows_bin,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_de LIKE '! ab' ESCAPE '!') AS rows_de,
  (SELECT GROUP_CONCAT (ca ORDER BY ca) FROM t_varchar WHERE cb_fr LIKE '! ab' ESCAPE '!') AS rows_fr;

-- cleanup
DROP TABLE IF EXISTS t_varchar;
