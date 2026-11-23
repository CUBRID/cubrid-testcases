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
 *  For each built-in collation other than utf8_bin, ta holds CHAR(3) keys, and tb, tc, and td
 *  hold the same values as CHAR(5), VARCHAR(40), and CHAR(5) with hash partitions, so a key of
 *  one length meets a key of another length. The last two cases join CHAR(3) and CHAR(5) keys
 *  of one euckr_bin character. Each prints the count of a nested loop join, a hash join, a
 *  comparison of the two values, and an IN subquery, which must all be 1.
 *
 *  Coverage: each collation below runs these cases in this order
 *    (1) hash join of ta and tb returns the pairs of the nested loop join
 *    (2) hash join of ta and tc returns the pairs of the nested loop join
 *    (3) hash join of tb and tc returns the pairs of the nested loop join
 *    (4) hash join of tb and tb returns the pairs of the nested loop join
 *    (5) td prune per CHAR(5) constant reads one partition and matches tb
 *    (6) td prune per VARCHAR(40) constant reads one partition and matches tb
 *
 *    Case 1 to 6:    binary
 *    Case 7 to 12:   euckr_bin
 *    Case 13 to 18:  iso88591_bin
 *    Case 19 to 24:  iso88591_en_ci
 *    Case 25 to 30:  iso88591_en_cs
 *    Case 31 to 36:  utf8_en_ci
 *    Case 37 to 42:  utf8_en_cs
 *    Case 43 to 48:  utf8_ko_cs
 *    Case 49 to 54:  utf8_tr_cs
 *    Case 55:  euckr_bin - CHAR(3) and CHAR(5) keys of B0 A1 match on every path
 *    Case 56:  euckr_bin - CHAR(3) and CHAR(5) keys of B0 A2 match on every path
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server
-- The keys with trailing spaces compare as they do because of ignore_trailing_space=no,
-- the default of the CTP database

-- binary
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE binary);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE binary);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE binary);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE binary) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE binary)),
  (2, CAST (CHR (32 USING binary) AS CHAR(3) COLLATE binary)),
  (3, CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(3) COLLATE binary));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING binary) AS CHAR(3) COLLATE binary)),
  (5, CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(3) COLLATE binary)),
  (6, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(3) COLLATE binary)),
  (7, CAST (CHR (65 USING binary) AS CHAR(3) COLLATE binary));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(3) COLLATE binary)),
  (9, CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(3) COLLATE binary)),
  (10, CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(3) COLLATE binary)),
  (11, CAST (CHR (0 USING binary) AS CHAR(3) COLLATE binary)),
  (12, CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(3) COLLATE binary)),
  (13, CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(3) COLLATE binary)),
  (14, CAST (CHR (98 USING binary) AS CHAR(3) COLLATE binary));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING binary) AS CHAR(3) COLLATE binary)),
  (16, CAST (CHR (73 USING binary) AS CHAR(3) COLLATE binary)),
  (17, CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(3) COLLATE binary)),
  (18, CAST (CHR (101 USING binary) AS CHAR(3) COLLATE binary)),
  (19, CAST (CHR (69 USING binary) AS CHAR(3) COLLATE binary)),
  (20, CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(3) COLLATE binary));

-- 21 to 26: bytes 80 and FF, which are not ASCII: alone, after 'a' and a space, and next to a NUL
-- ca | cb       | note
-- ---+----------+-------------------------
-- 21 | '\xFF'   | FF only
-- 22 | 'a\xFF'  | FF after 'a'
-- 23 | 'a \xFF' | FF after 'a' and a space
-- 24 | '\x80\0' | 80, then a trailing NUL
-- 25 | '\x80'   | 80 only
-- 26 | '\0\xFF' | leading NUL, then FF
INSERT INTO ta VALUES
  (21, CAST (CHR (255 USING binary) AS CHAR(3) COLLATE binary)),
  (22, CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(3) COLLATE binary)),
  (23, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(3) COLLATE binary)),
  (24, CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(3) COLLATE binary)),
  (25, CAST (CHR (128 USING binary) AS CHAR(3) COLLATE binary)),
  (26, CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(3) COLLATE binary));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE binary)),
  (2, CAST (CHR (32 USING binary) AS CHAR(5) COLLATE binary)),
  (3, CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)),
  (4, CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary)),
  (5, CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)),
  (6, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)),
  (7, CAST (CHR (65 USING binary) AS CHAR(5) COLLATE binary)),
  (8, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (9, CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (10, CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)),
  (11, CAST (CHR (0 USING binary) AS CHAR(5) COLLATE binary)),
  (12, CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (13, CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (14, CAST (CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (15, CAST (CHR (105 USING binary) AS CHAR(5) COLLATE binary)),
  (16, CAST (CHR (73 USING binary) AS CHAR(5) COLLATE binary)),
  (17, CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(5) COLLATE binary)),
  (18, CAST (CHR (101 USING binary) AS CHAR(5) COLLATE binary)),
  (19, CAST (CHR (69 USING binary) AS CHAR(5) COLLATE binary)),
  (20, CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)),
  (21, CAST (CHR (255 USING binary) AS CHAR(5) COLLATE binary)),
  (22, CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)),
  (23, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)),
  (24, CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)),
  (25, CAST (CHR (128 USING binary) AS CHAR(5) COLLATE binary)),
  (26, CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE binary)),
  (2, CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (3, CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (4, CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)),
  (5, CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (6, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (7, CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)),
  (8, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (9, CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (10, CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (11, CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (12, CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (13, CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (14, CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (15, CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)),
  (16, CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)),
  (17, CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)),
  (18, CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)),
  (19, CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)),
  (20, CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (21, CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (22, CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (23, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (24, CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (25, CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)),
  (26, CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 1: binary - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 2: binary - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 3: binary - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 4: binary - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 5: binary - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb       | note
-- ---+----------+------------------------------
--  1 | ''       | empty string
--  2 | ' '      | a space only
--  3 | '  '     | two spaces only
--  4 | 'a'      |
--  5 | 'a '     | trailing space
--  6 | 'a  '    | two trailing spaces
--  7 | 'A'      | upper case of 'a'
--  8 | 'a b'    | space in the middle
--  9 | 'a\0b'   | NUL in the middle
-- 10 | 'a\0'    | trailing NUL
-- 11 | '\0'     | a NUL only
-- 12 | '\0b'    | leading NUL
-- 13 | ' b'     | leading space
-- 14 | 'b'      |
-- 15 | 'i'      |
-- 16 | 'I'      | upper case of 'i'
-- 17 | 'ss'     | expansion of sharp s (U+00DF)
-- 18 | 'e'      |
-- 19 | 'E'      | upper case of 'e'
-- 20 | 'a\tb'   | tab, not a space
-- 21 | '\xFF'   | FF only
-- 22 | 'a\xFF'  | FF after 'a'
-- 23 | 'a \xFF' | FF after 'a' and a space
-- 24 | '\x80\0' | 80, then a trailing NUL
-- 25 | '\x80'   | 80 only
-- 26 | '\0\xFF' | leading NUL, then FF
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (128 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (128 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 6: binary - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb       | note
-- ---+----------+------------------------------
--  1 | ''       | empty string
--  2 | ' '      | a space only
--  3 | '  '     | two spaces only
--  4 | 'a'      |
--  5 | 'a '     | trailing space
--  6 | 'a  '    | two trailing spaces
--  7 | 'A'      | upper case of 'a'
--  8 | 'a b'    | space in the middle
--  9 | 'a\0b'   | NUL in the middle
-- 10 | 'a\0'    | trailing NUL
-- 11 | '\0'     | a NUL only
-- 12 | '\0b'    | leading NUL
-- 13 | ' b'     | leading space
-- 14 | 'b'      |
-- 15 | 'i'      |
-- 16 | 'I'      | upper case of 'i'
-- 17 | 'ss'     | expansion of sharp s (U+00DF)
-- 18 | 'e'      |
-- 19 | 'E'      | upper case of 'e'
-- 20 | 'a\tb'   | tab, not a space
-- 21 | '\xFF'   | FF only
-- 22 | 'a\xFF'  | FF after 'a'
-- 23 | 'a \xFF' | FF after 'a' and a space
-- 24 | '\x80\0' | 80, then a trailing NUL
-- 25 | '\x80'   | 80 only
-- 26 | '\0\xFF' | leading NUL, then FF
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- euckr_bin
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE euckr_bin);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE euckr_bin);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE euckr_bin);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE euckr_bin) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE euckr_bin)),
  (2, CAST (CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (3, CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (5, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (6, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (7, CAST (CHR (65 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (9, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (10, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (11, CAST (CHR (0 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (12, CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (13, CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (14, CAST (CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (16, CAST (CHR (73 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (17, CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (18, CAST (CHR (101 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (19, CAST (CHR (69 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (20, CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 21 to 25: the EUC space A1 A1 (U+3000): alone, after 'a', in the middle, and next to a space
-- ca | cb           | note
-- ---+--------------+----------------------------
-- 21 | '<U+3000>'   | A1 A1, the EUC space
-- 22 | 'a<U+3000>'  | EUC space after 'a'
-- 23 | 'a<U+3000>b' | EUC space in the middle
-- 24 | 'a<U+3000> ' | EUC space, then a space
-- 25 | 'a <U+3000>' | a space, then the EUC space
INSERT INTO ta VALUES
  (21, CAST (CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (22, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (23, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (24, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (25, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 26 to 32: B0 A1 (U+AC00): its second byte A1 is also the first byte of the EUC space
-- ca | cb                         | note
-- ---+----------------------------+---------------------------------------
-- 26 | '<U+AC00>'                 | B0 A1
-- 27 | '<U+AC00><U+3000>'         | B0 A1, then the EUC space
-- 28 | '<U+3000><U+3000>'         | two EUC spaces
-- 29 | 'a\0b'                     | NUL in the middle, the same bytes as 9
-- 30 | '<U+AC00> '                | B0 A1, then a space
-- 31 | '<U+AC00><U+3000><U+AC00>' | B0 A1, the EUC space, B0 A1
-- 32 | '<U+AC00><U+AC00>'         | B0 A1 twice
INSERT INTO ta VALUES
  (26, CAST (CHR (45217 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (27, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (28, CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (29, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (30, CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (31, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (32, CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- 33 to 37: more characters whose second byte is A1: A4 A1 (U+3131) and C7 A1 (U+D408), and B0 A1 after 'a'
-- ca | cb                         | note
-- ---+----------------------------+---------------------------
-- 33 | '<U+3131>'                 | A4 A1
-- 34 | '<U+3131><U+3000>'         | A4 A1, then the EUC space
-- 35 | '<U+3131> '                | A4 A1, then a space
-- 36 | '<U+D408><U+3000><U+3000>' | C7 A1, then two EUC spaces
-- 37 | 'a<U+AC00>'                | 'a', then B0 A1
INSERT INTO ta VALUES
  (33, CAST (CHR (42145 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (34, CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (35, CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (36, CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(3) COLLATE euckr_bin)),
  (37, CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS CHAR(3) COLLATE euckr_bin));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE euckr_bin)),
  (2, CAST (CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (3, CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (4, CAST (CHR (97 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (5, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (6, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (7, CAST (CHR (65 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (8, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (9, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (10, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (11, CAST (CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (12, CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (13, CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (14, CAST (CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (15, CAST (CHR (105 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (16, CAST (CHR (73 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (17, CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (18, CAST (CHR (101 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (19, CAST (CHR (69 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (20, CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (21, CAST (CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (22, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (23, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (24, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (25, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (26, CAST (CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (27, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (28, CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (29, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (30, CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (31, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (32, CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (33, CAST (CHR (42145 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (34, CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (35, CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (36, CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)),
  (37, CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE euckr_bin)),
  (2, CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (3, CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (4, CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (5, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (6, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (7, CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (8, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (9, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (10, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (11, CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (12, CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (13, CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (14, CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (15, CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (16, CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (17, CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (18, CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (19, CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (20, CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (21, CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (22, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (23, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (24, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (25, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (26, CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (27, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (28, CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (29, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (30, CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (31, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (32, CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (33, CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (34, CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (35, CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (36, CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (37, CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 7: euckr_bin - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 8: euckr_bin - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 9: euckr_bin - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 10: euckr_bin - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 11: euckr_bin - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb                         | note
-- ---+----------------------------+---------------------------------------
--  1 | ''                         | empty string
--  2 | ' '                        | a space only
--  3 | '  '                       | two spaces only
--  4 | 'a'                        |
--  5 | 'a '                       | trailing space
--  6 | 'a  '                      | two trailing spaces
--  7 | 'A'                        | upper case of 'a'
--  8 | 'a b'                      | space in the middle
--  9 | 'a\0b'                     | NUL in the middle
-- 10 | 'a\0'                      | trailing NUL
-- 11 | '\0'                       | a NUL only
-- 12 | '\0b'                      | leading NUL
-- 13 | ' b'                       | leading space
-- 14 | 'b'                        |
-- 15 | 'i'                        |
-- 16 | 'I'                        | upper case of 'i'
-- 17 | 'ss'                       | expansion of sharp s (U+00DF)
-- 18 | 'e'                        |
-- 19 | 'E'                        | upper case of 'e'
-- 20 | 'a\tb'                     | tab, not a space
-- 21 | '<U+3000>'                 | A1 A1, the EUC space
-- 22 | 'a<U+3000>'                | EUC space after 'a'
-- 23 | 'a<U+3000>b'               | EUC space in the middle
-- 24 | 'a<U+3000> '               | EUC space, then a space
-- 25 | 'a <U+3000>'               | a space, then the EUC space
-- 26 | '<U+AC00>'                 | B0 A1
-- 27 | '<U+AC00><U+3000>'         | B0 A1, then the EUC space
-- 28 | '<U+3000><U+3000>'         | two EUC spaces
-- 29 | 'a\0b'                     | NUL in the middle, the same bytes as 9
-- 30 | '<U+AC00> '                | B0 A1, then a space
-- 31 | '<U+AC00><U+3000><U+AC00>' | B0 A1, the EUC space, B0 A1
-- 32 | '<U+AC00><U+AC00>'         | B0 A1 twice
-- 33 | '<U+3131>'                 | A4 A1
-- 34 | '<U+3131><U+3000>'         | A4 A1, then the EUC space
-- 35 | '<U+3131> '                | A4 A1, then a space
-- 36 | '<U+D408><U+3000><U+3000>' | C7 A1, then two EUC spaces
-- 37 | 'a<U+AC00>'                | 'a', then B0 A1
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 37 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 12: euckr_bin - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb                         | note
-- ---+----------------------------+---------------------------------------
--  1 | ''                         | empty string
--  2 | ' '                        | a space only
--  3 | '  '                       | two spaces only
--  4 | 'a'                        |
--  5 | 'a '                       | trailing space
--  6 | 'a  '                      | two trailing spaces
--  7 | 'A'                        | upper case of 'a'
--  8 | 'a b'                      | space in the middle
--  9 | 'a\0b'                     | NUL in the middle
-- 10 | 'a\0'                      | trailing NUL
-- 11 | '\0'                       | a NUL only
-- 12 | '\0b'                      | leading NUL
-- 13 | ' b'                       | leading space
-- 14 | 'b'                        |
-- 15 | 'i'                        |
-- 16 | 'I'                        | upper case of 'i'
-- 17 | 'ss'                       | expansion of sharp s (U+00DF)
-- 18 | 'e'                        |
-- 19 | 'E'                        | upper case of 'e'
-- 20 | 'a\tb'                     | tab, not a space
-- 21 | '<U+3000>'                 | A1 A1, the EUC space
-- 22 | 'a<U+3000>'                | EUC space after 'a'
-- 23 | 'a<U+3000>b'               | EUC space in the middle
-- 24 | 'a<U+3000> '               | EUC space, then a space
-- 25 | 'a <U+3000>'               | a space, then the EUC space
-- 26 | '<U+AC00>'                 | B0 A1
-- 27 | '<U+AC00><U+3000>'         | B0 A1, then the EUC space
-- 28 | '<U+3000><U+3000>'         | two EUC spaces
-- 29 | 'a\0b'                     | NUL in the middle, the same bytes as 9
-- 30 | '<U+AC00> '                | B0 A1, then a space
-- 31 | '<U+AC00><U+3000><U+AC00>' | B0 A1, the EUC space, B0 A1
-- 32 | '<U+AC00><U+AC00>'         | B0 A1 twice
-- 33 | '<U+3131>'                 | A4 A1
-- 34 | '<U+3131><U+3000>'         | A4 A1, then the EUC space
-- 35 | '<U+3131> '                | A4 A1, then a space
-- 36 | '<U+D408><U+3000><U+3000>' | C7 A1, then two EUC spaces
-- 37 | 'a<U+AC00>'                | 'a', then B0 A1
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 37 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- iso88591_bin
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE iso88591_bin);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE iso88591_bin);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE iso88591_bin);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE iso88591_bin) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE iso88591_bin)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+--------------------------
-- 21 | '<U+00E9>'  | E9, e acute
-- 22 | '<U+00C9>'  | C9, upper case of E9
-- 23 | '<U+00DF>'  | DF, sharp s
-- 24 | 'a<U+00E9>' | ASCII then E9
-- 25 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
-- ca | cb           | note
-- ---+--------------+-------------------
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
INSERT INTO ta VALUES
  (26, CAST (CHR (160 USING iso88591) AS CHAR(3) COLLATE iso88591_bin)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_bin));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE iso88591_bin)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (4, CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (15, CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (21, CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (26, CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE iso88591_bin)),
  (2, CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (4, CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (7, CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (11, CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (14, CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (15, CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (16, CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (18, CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (19, CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (21, CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (22, CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (23, CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (26, CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 13: iso88591_bin - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 14: iso88591_bin - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 15: iso88591_bin - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 16: iso88591_bin - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 17: iso88591_bin - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 18: iso88591_bin - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- iso88591_en_ci
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE iso88591_en_ci);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE iso88591_en_ci);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE iso88591_en_ci);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE iso88591_en_ci) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE iso88591_en_ci)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+--------------------------
-- 21 | '<U+00E9>'  | E9, e acute
-- 22 | '<U+00C9>'  | C9, upper case of E9
-- 23 | '<U+00DF>'  | DF, sharp s
-- 24 | 'a<U+00E9>' | ASCII then E9
-- 25 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
-- ca | cb           | note
-- ---+--------------+-------------------
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
INSERT INTO ta VALUES
  (26, CAST (CHR (160 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_ci));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE iso88591_en_ci)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (4, CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (15, CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (21, CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (26, CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (2, CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (4, CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (7, CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (11, CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (14, CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (15, CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (16, CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (18, CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (19, CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (21, CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (22, CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (23, CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (26, CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 19: iso88591_en_ci - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 20: iso88591_en_ci - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 21: iso88591_en_ci - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 22: iso88591_en_ci - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 23: iso88591_en_ci - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_ci)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 24: iso88591_en_ci - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_ci)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- iso88591_en_cs
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE iso88591_en_cs);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE iso88591_en_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE iso88591_en_cs);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE iso88591_en_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE iso88591_en_cs)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+--------------------------
-- 21 | '<U+00E9>'  | E9, e acute
-- 22 | '<U+00C9>'  | C9, upper case of E9
-- 23 | '<U+00DF>'  | DF, sharp s
-- 24 | 'a<U+00E9>' | ASCII then E9
-- 25 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
-- ca | cb           | note
-- ---+--------------+-------------------
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
INSERT INTO ta VALUES
  (26, CAST (CHR (160 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(3) COLLATE iso88591_en_cs));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE iso88591_en_cs)),
  (2, CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (4, CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (7, CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (11, CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (14, CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (15, CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (16, CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (18, CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (19, CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (21, CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (22, CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (23, CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (26, CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (2, CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (4, CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (7, CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (11, CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (14, CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (15, CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (16, CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (18, CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (19, CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (21, CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (22, CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (23, CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (26, CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 25: iso88591_en_cs - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 26: iso88591_en_cs - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 27: iso88591_en_cs - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 28: iso88591_en_cs - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 29: iso88591_en_cs - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 30: iso88591_en_cs - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb           | note
-- ---+--------------+------------------------------
--  1 | ''           | empty string
--  2 | ' '          | a space only
--  3 | '  '         | two spaces only
--  4 | 'a'          |
--  5 | 'a '         | trailing space
--  6 | 'a  '        | two trailing spaces
--  7 | 'A'          | upper case of 'a'
--  8 | 'a b'        | space in the middle
--  9 | 'a\0b'       | NUL in the middle
-- 10 | 'a\0'        | trailing NUL
-- 11 | '\0'         | a NUL only
-- 12 | '\0b'        | leading NUL
-- 13 | ' b'         | leading space
-- 14 | 'b'          |
-- 15 | 'i'          |
-- 16 | 'I'          | upper case of 'i'
-- 17 | 'ss'         | expansion of sharp s (U+00DF)
-- 18 | 'e'          |
-- 19 | 'E'          | upper case of 'e'
-- 20 | 'a\tb'       | tab, not a space
-- 21 | '<U+00E9>'   | E9, e acute
-- 22 | '<U+00C9>'   | C9, upper case of E9
-- 23 | '<U+00DF>'   | DF, sharp s
-- 24 | 'a<U+00E9>'  | ASCII then E9
-- 25 | 'A<U+00C9>'  | upper case of 'a<U+00E9>'
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_en_ci
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE utf8_en_ci);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE utf8_en_ci);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_en_ci);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE utf8_en_ci) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE utf8_en_ci)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 21 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'  | e acute, 2 bytes
-- 24 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'  | sharp s, 2 bytes
-- 26 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (50353 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 28 | '<U+3000>'   | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_ci)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_en_ci));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE utf8_en_ci)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (4, CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (15, CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (21, CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (15, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (16, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (18, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (19, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (21, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (22, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (23, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (24, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (25, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (28, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (30, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 31: utf8_en_ci - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 32: utf8_en_ci - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 33: utf8_en_ci - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 34: utf8_en_ci - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 35: utf8_en_ci - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_ci)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 36: utf8_en_ci - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_en_cs
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE utf8_en_cs);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE utf8_en_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_en_cs);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE utf8_en_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE utf8_en_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 21 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'  | e acute, 2 bytes
-- 24 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'  | sharp s, 2 bytes
-- 26 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (50353 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 28 | '<U+3000>'   | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_en_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_en_cs));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE utf8_en_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (4, CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (15, CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (21, CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_en_cs)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (15, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (16, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (18, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (19, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (21, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (22, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (23, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (24, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (25, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 37: utf8_en_cs - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 38: utf8_en_cs - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 39: utf8_en_cs - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 40: utf8_en_cs - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 41: utf8_en_cs - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_en_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 42: utf8_en_cs - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_ko_cs
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE utf8_ko_cs);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE utf8_ko_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_ko_cs);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE utf8_ko_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE utf8_ko_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 21 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'  | e acute, 2 bytes
-- 24 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'  | sharp s, 2 bytes
-- 26 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (50353 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 28 | '<U+3000>'   | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_ko_cs));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE utf8_ko_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (4, CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (15, CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (21, CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (15, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (16, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (18, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (19, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (21, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (22, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (23, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (24, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (25, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 43: utf8_ko_cs - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 44: utf8_ko_cs - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 45: utf8_ko_cs - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 46: utf8_ko_cs - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 47: utf8_ko_cs - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_ko_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 48: utf8_ko_cs - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_ko_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_tr_cs
DROP TABLE IF EXISTS td, tc, tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE utf8_tr_cs);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE utf8_tr_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_tr_cs);
CREATE TABLE td (ca INT, cb CHAR(5) COLLATE utf8_tr_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS CHAR(3) COLLATE utf8_tr_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
-- ca | cb     | note
-- ---+--------+--------------------
--  8 | 'a b'  | space in the middle
--  9 | 'a\0b' | NUL in the middle
-- 10 | 'a\0'  | trailing NUL
-- 11 | '\0'   | a NUL only
-- 12 | '\0b'  | leading NUL
-- 13 | ' b'   | leading space
-- 14 | 'b'    |
INSERT INTO ta VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (15, CAST (CHR (105 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 21 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'  | e acute, 2 bytes
-- 24 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'  | sharp s, 2 bytes
-- 26 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (21, CAST (CHR (50353 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 28 | '<U+3000>'   | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(3) COLLATE utf8_tr_cs));

-- tb: the values of ta as CHAR(5)
INSERT INTO tb VALUES
  (1, CAST ('' AS CHAR(5) COLLATE utf8_tr_cs)),
  (2, CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (4, CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (7, CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (11, CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (14, CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (15, CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (16, CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (18, CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (19, CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (21, CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (22, CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (23, CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (24, CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (25, CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs));

-- tc: the values of ta as VARCHAR(40)
INSERT INTO tc VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (15, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (16, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (18, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (19, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (21, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (22, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (23, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (24, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (25, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (28, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (30, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

INSERT INTO td SELECT * FROM tb;

UPDATE STATISTICS ON ta, tb, tc, td WITH FULLSCAN;

evaluate 'Case 49: utf8_tr_cs - hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 50: utf8_tr_cs - hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from ta x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 51: utf8_tr_cs - hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tc y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 52: utf8_tr_cs - hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca
from tb x, tb y
where x.cb = y.cb
order by 1, 2;

evaluate 'Case 53: utf8_tr_cs - td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_tr_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

evaluate 'Case 54: utf8_tr_cs - td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
-- ca | cb                 | note
-- ---+--------------------+---------------------------------------------
--  1 | ''                 | empty string
--  2 | ' '                | a space only
--  3 | '  '               | two spaces only
--  4 | 'a'                |
--  5 | 'a '               | trailing space
--  6 | 'a  '              | two trailing spaces
--  7 | 'A'                | upper case of 'a'
--  8 | 'a b'              | space in the middle
--  9 | 'a\0b'             | NUL in the middle
-- 10 | 'a\0'              | trailing NUL
-- 11 | '\0'               | a NUL only
-- 12 | '\0b'              | leading NUL
-- 13 | ' b'               | leading space
-- 14 | 'b'                |
-- 15 | 'i'                |
-- 16 | 'I'                | upper case of 'i'
-- 17 | 'ss'               | expansion of sharp s (U+00DF)
-- 18 | 'e'                |
-- 19 | 'E'                | upper case of 'e'
-- 20 | 'a\tb'             | tab, not a space
-- 21 | '<U+0131>'         | dotless i (utf8_tr_cs case pair of I)
-- 22 | '<U+0130>'         | dotted capital I (utf8_tr_cs case pair of i)
-- 23 | '<U+00E9>'         | e acute, 2 bytes
-- 24 | '<U+00C9>'         | upper case of '<U+00E9>'
-- 25 | '<U+00DF>'         | sharp s, 2 bytes
-- 26 | 'a<U+00E9>'        | ASCII then a 2-byte character
-- 27 | 'A<U+00C9>'        | upper case of 'a<U+00E9>'
-- 28 | '<U+3000>'         | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b'       | U+3000 in the middle
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM tb WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM td WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- euckr_bin, one character of 2 bytes
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE euckr_bin);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE euckr_bin);
-- 1, '가' (B0 A1): its second byte A1 is also the first byte of the EUC space (A1 A1)
INSERT INTO ta VALUES (1, CAST (CHR (45217 USING euckr) AS CHAR(3) COLLATE euckr_bin));
-- 1, the same value as CHAR(5), 2 more padding spaces
INSERT INTO tb VALUES (1, CAST (CHR (45217 USING euckr) AS CHAR(5) COLLATE euckr_bin));

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 55: euckr_bin - CHAR(3) and CHAR(5) keys of B0 A1 match on every path';
set trace on;
SELECT (SELECT /*+ NO_USE_HASH USE_NL */ COUNT (*) FROM ta, tb WHERE ta.cb = tb.cb) AS nl_ab,
       (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ COUNT (*)
        FROM ta, tb WHERE ta.cb = tb.cb) AS hash_ab,
       (SELECT COUNT (*) FROM ta, tb WHERE ta.cb = tb.cb AND (SELECT cb FROM ta) = (SELECT cb FROM tb)) AS cmp_ab,
       (SELECT COUNT (*) FROM ta WHERE ta.cb IN (SELECT cb FROM tb)) AS in_ab;
show trace;
set trace off;

-- euckr_bin, one character of 2 bytes
DROP TABLE IF EXISTS tb, ta;
CREATE TABLE ta (ca INT, cb CHAR(3) COLLATE euckr_bin);
CREATE TABLE tb (ca INT, cb CHAR(5) COLLATE euckr_bin);
-- 1, '각' (B0 A2): the control, its second byte A2 not a byte of the EUC space
INSERT INTO ta VALUES (1, CAST (CHR (45218 USING euckr) AS CHAR(3) COLLATE euckr_bin));
-- 1, the same value as CHAR(5), 2 more padding spaces
INSERT INTO tb VALUES (1, CAST (CHR (45218 USING euckr) AS CHAR(5) COLLATE euckr_bin));

UPDATE STATISTICS ON ta, tb WITH FULLSCAN;

evaluate 'Case 56: euckr_bin - CHAR(3) and CHAR(5) keys of B0 A2 match on every path';
set trace on;
SELECT (SELECT /*+ NO_USE_HASH USE_NL */ COUNT (*) FROM ta, tb WHERE ta.cb = tb.cb) AS nl_ab,
       (SELECT /*+ USE_HASH NO_PARALLEL_HASH_JOIN NO_PARALLEL_SUBQUERY */ COUNT (*)
        FROM ta, tb WHERE ta.cb = tb.cb) AS hash_ab,
       (SELECT COUNT (*) FROM ta, tb WHERE ta.cb = tb.cb AND (SELECT cb FROM ta) = (SELECT cb FROM tb)) AS cmp_ab,
       (SELECT COUNT (*) FROM ta WHERE ta.cb IN (SELECT cb FROM tb)) AS in_ab;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc, td;
