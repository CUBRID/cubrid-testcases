/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash join, a hash GROUP BY, a hash partition prune, and a hash list scan hash a string key with the hash function
 *  of its collation. The change hashes byte collations eight bytes at a time and makes the hash of every collation
 *  follow its comparison, so two keys that compare equal get one hash.
 *
 *  Each hash case has a twin that skips the hash path: a nested loop join, a sort GROUP BY, a table without partitions,
 *  or the join without the hash list scan. The verification block after each hash join, hash GROUP BY, and hash list
 *  scan prints PASS when the hash query and its twin return the same rows as a multiset. A prune case counts the rows
 *  of each value in t_varchar_part and in t_varchar_a, and the two counts must match. SHOW TRACE shows the path that
 *  each hash case took. CTP masks the digits of a trace, so the answer checks only the path: HASHJOIN, hash true and
 *  sort false in GROUPBY, one PARTITION line for the one value that a prune case traces after it counts the rows of
 *  every value, and SCAN (hash temp(m), ...) for the hash list scan.
 *
 *  For the built-in collation utf8_en_ci, t_varchar_a, t_varchar_b, and t_varchar_part hold VARCHAR(40) keys: the
 *  strings of cbrd_28060_varchar_utf8_bin that the charset can hold, and the case pairs, accents, and expansions that
 *  the collation compares equal.
 *
 *  Coverage:
 *    Case 1:  utf8_en_ci - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join
 *    Case 2:  utf8_en_ci - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY
 *    Case 3:  utf8_en_ci - t_varchar_part prune per VARCHAR(40) constant reads one partition and matches t_varchar_a
 *    Case 4:  utf8_en_ci - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash
 *             list scan
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server. The keys with trailing spaces compare as
-- they do because of ignore_trailing_space=no, the default of the CTP database

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

-- utf8_en_ci
DROP TABLE IF EXISTS t_varchar_part, t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(40) COLLATE utf8_en_ci);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(40) COLLATE utf8_en_ci);
CREATE TABLE t_varchar_part (ca INT, cb VARCHAR(40) COLLATE utf8_en_ci) PARTITION BY HASH (cb) PARTITIONS 7;

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO t_varchar_a VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO t_varchar_a VALUES
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

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
INSERT INTO t_varchar_a VALUES
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

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
INSERT INTO t_varchar_a VALUES
  (15, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (16, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (17, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (18, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (19, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (20, CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (21, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (22, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (23, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (24, CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

-- 25 to 30: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 25 | 'i'    |
-- 26 | 'I'    | upper case of 'i'
-- 27 | 'ss'   | expansion of sharp s (U+00DF)
-- 28 | 'e'    |
-- 29 | 'E'    | upper case of 'e'
-- 30 | 'a\tb' | tab, not a space
INSERT INTO t_varchar_a VALUES
  (25, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (26, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (27, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (28, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (29, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (30, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

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
INSERT INTO t_varchar_a VALUES
  (31, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (32, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (33, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (34, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (35, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (36, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (37, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

-- 38 to 39: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 38 | '<U+3000>'   | ideographic space, 3 bytes
-- 39 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO t_varchar_a VALUES
  (38, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (39, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

-- 40 to 43: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 40 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 41 | '<U+AC00> '        | trailing space after a 3-byte character
-- 42 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 43 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO t_varchar_a VALUES
  (40, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (41, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (42, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)),
  (43, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci));

-- t_varchar_b and t_varchar_part: the values of t_varchar_a
INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;
INSERT INTO t_varchar_part SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b, t_varchar_part WITH FULLSCAN;

evaluate 'Case 1: utf8_en_ci - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_varchar_a x, t_varchar_b y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_varchar_a x, t_varchar_b y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_varchar_a x, t_varchar_b y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: utf8_en_ci - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY';
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

evaluate 'Case 3: utf8_en_ci - t_varchar_part prune per VARCHAR(40) constant reads one partition and matches t_varchar_a';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 11 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 12 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 13 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 14 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 15 to 24: the 8-byte chunks of the hash: a space or NUL inside the first chunk, right past it, and past two chunks
SELECT 15 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 16 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 17 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 18 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (32 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 19 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 20 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (65 USING utf8) || CHR (66 USING utf8) || CHR (67 USING utf8) || CHR (68 USING utf8) || CHR (69 USING utf8) || CHR (70 USING utf8) || CHR (71 USING utf8) || CHR (72 USING utf8) || CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 21 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (32 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (32 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 22 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (0 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (0 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 23 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 24 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (98 USING utf8) || CHR (99 USING utf8) || CHR (100 USING utf8) || CHR (101 USING utf8) || CHR (102 USING utf8) || CHR (103 USING utf8) || CHR (104 USING utf8) || CHR (105 USING utf8) || CHR (106 USING utf8) || CHR (107 USING utf8) || CHR (108 USING utf8) || CHR (109 USING utf8) || CHR (110 USING utf8) || CHR (111 USING utf8) || CHR (112 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 25 to 30: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT 25 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 26 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 27 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 28 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 29 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 30 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 31 to 37: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
SELECT 31 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 32 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 33 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 34 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 35 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 36 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 37 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 38 to 39: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
SELECT 38 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 39 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

-- 40 to 43: a 3-byte character followed by a space, a NUL or U+3000
SELECT 40 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 41 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 42 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT 43 AS ca,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci)) AS cnt_part;

SELECT COUNT (*)
FROM t_varchar_part WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_en_ci);
show trace;

evaluate 'Case 4: utf8_en_ci - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash list scan';
select /*+ ordered parallel(0) */ x.ca, y.ca
from t_varchar_a x, (select /*+ NO_MERGE */ ca, cb from t_varchar_b where ca >= 1) y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (select /*+ ordered parallel(0) */ x.ca as x_ca, y.ca as y_ca from t_varchar_a x, (select /*+ NO_MERGE */ ca, cb from t_varchar_b where ca >= 1) y where x.cb = y.cb),
  listscan_rows as (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ x.ca as x_ca, y.ca as y_ca from t_varchar_a x, (select /*+ NO_MERGE */ ca, cb from t_varchar_b where ca >= 1) y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

-- cleanup
set system parameters 'agg_hash_respect_order=default';

drop table if exists t_varchar_a, t_varchar_b, t_varchar_part;

set trace off;
