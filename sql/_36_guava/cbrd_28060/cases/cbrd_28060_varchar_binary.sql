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
 *  For the built-in collation binary, ta, tb, and tc hold VARCHAR(40) keys - the strings of
 *  cbrd_28060_varchar_utf8_bin that the charset can hold, and the case pairs, accents, and
 *  expansions that the collation compares as equal.
 *
 *  Coverage:
 *    Case 1:  hash join of ta and tb returns the pairs of the nested loop join
 *    Case 2:  hash GROUP BY on ta returns the groups of the sort GROUP BY
 *    Case 3:  tc prune per VARCHAR(40) constant reads one partition and matches ta
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server
-- The keys with trailing spaces compare as they do because of ignore_trailing_space=no,
-- the default of the CTP database

-- binary
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(40) COLLATE binary);
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE binary);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE binary) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE binary)),
  (2, CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (3, CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)),
  (5, CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (6, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (7, CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary));

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
  (8, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (9, CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (10, CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (11, CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (12, CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (13, CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (14, CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary));

-- 15 to 24: the 8-byte chunks of the hash: a space or NUL inside the first chunk, right past it, and past two chunks
-- ca | cb                   | note
-- ---+----------------------+--------------------------------------
-- 15 | 'abcdefgh'           | 8 bytes, one full 8-byte chunk
-- 16 | 'abcdefgh '          | space as byte 9, past the first chunk
-- 17 | 'abcdefgh\0'         | NUL as byte 9, past the first chunk
-- 18 | 'abcdefgh \0'        | space and NUL past the first chunk
-- 19 | 'abcdefghi'          | 9 bytes
-- 20 | 'ABCDEFGHI'          | upper case of 'abcdefghi'
-- 21 | 'abc def gh'         | spaces inside the first chunk
-- 22 | 'abc\0def\0gh'       | NULs inside the first chunk
-- 23 | 'abcdefghijklmnop'   | 16 bytes, two full chunks
-- 24 | 'abcdefghijklmnop  ' | trailing spaces past two chunks
INSERT INTO ta VALUES
  (15, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)),
  (16, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)),
  (17, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (18, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (19, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)),
  (20, CAST (CHR (65 USING binary) || CHR (66 USING binary) || CHR (67 USING binary) || CHR (68 USING binary) || CHR (69 USING binary) || CHR (70 USING binary) || CHR (71 USING binary) || CHR (72 USING binary) || CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)),
  (21, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (32 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (32 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)),
  (22, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (0 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (0 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)),
  (23, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) AS VARCHAR(40) COLLATE binary)),
  (24, CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary));

-- 25 to 30: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 25 | 'i'    |
-- 26 | 'I'    | upper case of 'i'
-- 27 | 'ss'   | expansion of sharp s (U+00DF)
-- 28 | 'e'    |
-- 29 | 'E'    | upper case of 'e'
-- 30 | 'a\tb' | tab, not a space
INSERT INTO ta VALUES
  (25, CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)),
  (26, CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)),
  (27, CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)),
  (28, CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)),
  (29, CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)),
  (30, CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary));

-- 31 to 36: bytes 80 and FF, which are not ASCII: alone, after 'a' and a space, and next to a NUL
-- ca | cb       | note
-- ---+----------+-------------------------
-- 31 | '\xFF'   | FF only
-- 32 | 'a\xFF'  | FF after 'a'
-- 33 | 'a \xFF' | FF after 'a' and a space
-- 34 | '\x80\0' | 80, then a trailing NUL
-- 35 | '\x80'   | 80 only
-- 36 | '\0\xFF' | leading NUL, then FF
INSERT INTO ta VALUES
  (31, CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (32, CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (33, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (34, CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (35, CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)),
  (36, CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary));

INSERT INTO tb SELECT * FROM ta;
INSERT INTO tc SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: hash join of ta and tb returns the pairs of the nested loop join';
set trace on;
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;
show trace;
set trace off;
select /*+ no_use_hash use_nl */ x.ca, y.ca from ta x, tb y where x.cb = y.cb order by 1, 2;

evaluate 'Case 2: hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

evaluate 'Case 3: tc prune per VARCHAR(40) constant reads one partition and matches ta';
set trace on;
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (32 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING binary) || CHR (66 USING binary) || CHR (67 USING binary) || CHR (68 USING binary) || CHR (69 USING binary) || CHR (70 USING binary) || CHR (71 USING binary) || CHR (72 USING binary) || CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING binary) || CHR (66 USING binary) || CHR (67 USING binary) || CHR (68 USING binary) || CHR (69 USING binary) || CHR (70 USING binary) || CHR (71 USING binary) || CHR (72 USING binary) || CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (32 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (32 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (32 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (32 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (0 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (0 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (0 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (0 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (98 USING binary) || CHR (99 USING binary) || CHR (100 USING binary) || CHR (101 USING binary) || CHR (102 USING binary) || CHR (103 USING binary) || CHR (104 USING binary) || CHR (105 USING binary) || CHR (106 USING binary) || CHR (107 USING binary) || CHR (108 USING binary) || CHR (109 USING binary) || CHR (110 USING binary) || CHR (111 USING binary) || CHR (112 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
