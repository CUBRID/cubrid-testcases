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
 *  For the built-in collation utf8_tr_cs, ta, tb, and tc hold VARCHAR(40) keys - the strings of
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

-- utf8_tr_cs
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(40) COLLATE utf8_tr_cs);
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE utf8_tr_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE utf8_tr_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

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
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

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
  (15, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (16, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (17, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (18, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (19, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (20, CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (21, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (22, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (23, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (24, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

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
  (25, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (26, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (27, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (28, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (29, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (30, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

-- 31 to 37: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+---------------------------------------------
-- 31 | '<U+0131>'  | dotless i (utf8_tr_cs case pair of I)
-- 32 | '<U+0130>'  | dotted capital I (utf8_tr_cs case pair of i)
-- 33 | '<U+00E9>'  | e acute, 2 bytes
-- 34 | '<U+00C9>'  | upper case of '<U+00E9>'
-- 35 | '<U+00DF>'  | sharp s, 2 bytes
-- 36 | 'a<U+00E9>' | ASCII then a 2-byte character
-- 37 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO ta VALUES
  (31, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (32, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (33, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (34, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (35, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (36, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (37, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

-- 38 to 39: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 38 | '<U+3000>'   | ideographic space, 3 bytes
-- 39 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO ta VALUES
  (38, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (39, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

-- 40 to 43: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 40 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 41 | '<U+AC00> '        | trailing space after a 3-byte character
-- 42 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 43 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO ta VALUES
  (40, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (41, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (42, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)),
  (43, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs));

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
    (SELECT COUNT (*) FROM ta WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 37 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 38 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 39 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 40 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 41 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 42 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
  UNION ALL
  SELECT 43 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_tr_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
