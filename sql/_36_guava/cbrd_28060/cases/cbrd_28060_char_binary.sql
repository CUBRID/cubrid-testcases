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
 *  For the built-in collation binary, ta holds CHAR(3) keys, and tb, tc, and td hold the same
 *  values as CHAR(5), VARCHAR(40), and CHAR(5) with hash partitions, so a key of one length meets a
 *  key of another length.
 *
 *  Coverage:
 *    Case 1:  hash join of ta and tb returns the pairs of the nested loop join
 *    Case 2:  hash join of ta and tc returns the pairs of the nested loop join
 *    Case 3:  hash join of tb and tc returns the pairs of the nested loop join
 *    Case 4:  hash join of tb and tb returns the pairs of the nested loop join
 *    Case 5:  td prune per CHAR(5) constant reads one partition and matches tb
 *    Case 6:  td prune per VARCHAR(40) constant reads one partition and matches tb
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

evaluate 'Case 1: hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;

evaluate 'Case 2: hash join of ta and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from ta x, tc y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from ta x, tc y where x.cb = y.cb order by 1, 2;

evaluate 'Case 3: hash join of tb and tc returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tb x, tc y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tb x, tc y where x.cb = y.cb order by 1, 2;

evaluate 'Case 4: hash join of tb and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from tb x, tb y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from tb x, tb y where x.cb = y.cb order by 1, 2;

evaluate 'Case 5: td prune per CHAR(5) constant reads one partition and matches tb';
set trace on;
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

evaluate 'Case 6: td prune per VARCHAR(40) constant reads one partition and matches tb';
set trace on;
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

-- cleanup
set trace off;

drop table if exists ta, tb, tc, td;
