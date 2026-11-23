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
 *  For the built-in collation euckr_bin, ta, tb, and tc hold VARCHAR(40) keys - the strings of
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

-- euckr_bin
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(40) COLLATE euckr_bin);
CREATE TABLE tb (ca INT, cb VARCHAR(40) COLLATE euckr_bin);
CREATE TABLE tc (ca INT, cb VARCHAR(40) COLLATE euckr_bin) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO ta VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE euckr_bin)),
  (2, CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (3, CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO ta VALUES
  (4, CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (5, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (6, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (7, CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

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
  (8, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (9, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (10, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (11, CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (12, CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (13, CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (14, CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

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
  (15, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (16, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (17, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (18, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (19, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (20, CAST (CHR (65 USING euckr) || CHR (66 USING euckr) || CHR (67 USING euckr) || CHR (68 USING euckr) || CHR (69 USING euckr) || CHR (70 USING euckr) || CHR (71 USING euckr) || CHR (72 USING euckr) || CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (21, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (32 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (32 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (22, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (0 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (0 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (23, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (24, CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

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
  (25, CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (26, CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (27, CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (28, CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (29, CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (30, CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

-- 31 to 35: the EUC space A1 A1 (U+3000): alone, after 'a', in the middle, and next to a space
-- ca | cb           | note
-- ---+--------------+----------------------------
-- 31 | '<U+3000>'   | A1 A1, the EUC space
-- 32 | 'a<U+3000>'  | EUC space after 'a'
-- 33 | 'a<U+3000>b' | EUC space in the middle
-- 34 | 'a<U+3000> ' | EUC space, then a space
-- 35 | 'a <U+3000>' | a space, then the EUC space
INSERT INTO ta VALUES
  (31, CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (32, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (33, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (34, CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (35, CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

-- 36 to 42: B0 A1 (U+AC00): its second byte A1 is also the first byte of the EUC space
-- ca | cb                         | note
-- ---+----------------------------+---------------------------------------
-- 36 | '<U+AC00>'                 | B0 A1
-- 37 | '<U+AC00><U+3000>'         | B0 A1, then the EUC space
-- 38 | '<U+3000><U+3000>'         | two EUC spaces
-- 39 | 'a\0b'                     | NUL in the middle, the same bytes as 9
-- 40 | '<U+AC00> '                | B0 A1, then a space
-- 41 | '<U+AC00><U+3000><U+AC00>' | B0 A1, the EUC space, B0 A1
-- 42 | '<U+AC00><U+AC00>'         | B0 A1 twice
INSERT INTO ta VALUES
  (36, CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (37, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (38, CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (39, CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (40, CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (41, CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (42, CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

-- 43 to 47: more characters whose second byte is A1: A4 A1 (U+3131) and C7 A1 (U+D408), and B0 A1 after 'a'
-- ca | cb                         | note
-- ---+----------------------------+---------------------------
-- 43 | '<U+3131>'                 | A4 A1
-- 44 | '<U+3131><U+3000>'         | A4 A1, then the EUC space
-- 45 | '<U+3131> '                | A4 A1, then a space
-- 46 | '<U+D408><U+3000><U+3000>' | C7 A1, then two EUC spaces
-- 47 | 'a<U+AC00>'                | 'a', then B0 A1
INSERT INTO ta VALUES
  (43, CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (44, CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (45, CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (46, CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)),
  (47, CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin));

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
    (SELECT COUNT (*) FROM ta WHERE cb = CAST ('' AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST ('' AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 9 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 10 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 11 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 12 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 13 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (32 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 14 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 15 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 16 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 17 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 18 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (32 USING euckr) || CHR (0 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 19 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 20 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (65 USING euckr) || CHR (66 USING euckr) || CHR (67 USING euckr) || CHR (68 USING euckr) || CHR (69 USING euckr) || CHR (70 USING euckr) || CHR (71 USING euckr) || CHR (72 USING euckr) || CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (65 USING euckr) || CHR (66 USING euckr) || CHR (67 USING euckr) || CHR (68 USING euckr) || CHR (69 USING euckr) || CHR (70 USING euckr) || CHR (71 USING euckr) || CHR (72 USING euckr) || CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 21 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (32 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (32 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (32 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (32 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 22 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (0 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (0 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (0 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (0 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 23 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 24 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (98 USING euckr) || CHR (99 USING euckr) || CHR (100 USING euckr) || CHR (101 USING euckr) || CHR (102 USING euckr) || CHR (103 USING euckr) || CHR (104 USING euckr) || CHR (105 USING euckr) || CHR (106 USING euckr) || CHR (107 USING euckr) || CHR (108 USING euckr) || CHR (109 USING euckr) || CHR (110 USING euckr) || CHR (111 USING euckr) || CHR (112 USING euckr) || CHR (32 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 25 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (105 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 26 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (73 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 27 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (115 USING euckr) || CHR (115 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 28 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (101 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 29 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (69 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 30 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (9 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 31 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 32 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 33 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 34 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (41377 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 35 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (32 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 36 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 37 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 38 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 39 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (0 USING euckr) || CHR (98 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 40 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45217 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 41 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45217 USING euckr) || CHR (41377 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 42 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (45217 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 43 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (42145 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 44 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (42145 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 45 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (42145 USING euckr) || CHR (32 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 46 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (51105 USING euckr) || CHR (41377 USING euckr) || CHR (41377 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
  UNION ALL
  SELECT 47 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (CHR (97 USING euckr) || CHR (45217 USING euckr) AS VARCHAR(40) COLLATE euckr_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
