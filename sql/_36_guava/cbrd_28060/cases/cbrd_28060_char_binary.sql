/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash join, a hash GROUP BY, and a hash partition prune hash a string key with the hash
 *  function of its collation. The change hashes byte collations eight bytes at a time and makes
 *  the hash of every collation follow its comparison, so two keys that compare equal get one hash.
 *
 *  Each hash case has a twin that skips the hash path: a nested loop join or a table without partitions. The
 *  verification block after each hash join prints PASS when the hash join and its twin return the same rows as a
 *  multiset. A prune case counts the rows of each value in t_char_long_part and in t_char_long, and the two counts must
 *  match. SHOW TRACE shows the path that each hash case took. CTP masks the digits of a trace, so the answer checks
 *  only the path: HASHJOIN and one PARTITION line for the one value that a prune case traces after it counts the rows
 *  of every value.
 *
 *  For the built-in collation binary, t_varchar holds the keys as VARCHAR(40), and t_char_short,
 *  t_char_long, and t_char_long_part hold the same values as CHAR(3), CHAR(5), and CHAR(5) with hash
 *  partitions, so a key of one length meets a key of another length.
 *
 *  Coverage:
 *    Case 1:  hash join of t_char_short and t_char_long returns the pairs of the nested loop join
 *    Case 2:  hash join of t_char_short and t_varchar returns the pairs of the nested loop join
 *    Case 3:  hash join of t_char_long and t_varchar returns the pairs of the nested loop join
 *    Case 4:  hash join of t_char_long and t_char_long returns the pairs of the nested loop join
 *    Case 5:  t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long
 *    Case 6:  t_char_long_part prune per VARCHAR(40) constant reads one partition and matches t_char_long
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server. The keys with trailing spaces compare as
-- they do because of ignore_trailing_space=no, the default of the CTP database

-- binary
DROP TABLE IF EXISTS t_char_long_part, t_varchar, t_char_long, t_char_short;
CREATE TABLE t_char_short (ca INT, cb CHAR(3) COLLATE binary);
CREATE TABLE t_char_long (ca INT, cb CHAR(5) COLLATE binary);
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE binary);
CREATE TABLE t_char_long_part (ca INT, cb CHAR(5) COLLATE binary) PARTITION BY HASH (cb) PARTITIONS 7;

-- t_varchar holds the values, and t_char_short and t_char_long take them from it: CHAR pads a value with spaces,
-- so 'a', 'a ' and 'a  ' are one value there, and only VARCHAR keeps them apart

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO t_varchar VALUES
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
INSERT INTO t_varchar VALUES
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
INSERT INTO t_varchar VALUES
  (8, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (9, CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (10, CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (11, CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (12, CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (13, CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)),
  (14, CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary));

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
-- ca | cb     | note
-- ---+--------+------------------------------
-- 15 | 'i'    |
-- 16 | 'I'    | upper case of 'i'
-- 17 | 'ss'   | expansion of sharp s (U+00DF)
-- 18 | 'e'    |
-- 19 | 'E'    | upper case of 'e'
-- 20 | 'a\tb' | tab, not a space
INSERT INTO t_varchar VALUES
  (15, CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)),
  (16, CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)),
  (17, CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)),
  (18, CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)),
  (19, CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)),
  (20, CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary));

-- 21 to 26: bytes 80 and FF, which are not ASCII: alone, after 'a' and a space, and next to a NUL
-- ca | cb       | note
-- ---+----------+-------------------------
-- 21 | '\xFF'   | FF only
-- 22 | 'a\xFF'  | FF after 'a'
-- 23 | 'a \xFF' | FF after 'a' and a space
-- 24 | '\x80\0' | 80, then a trailing NUL
-- 25 | '\x80'   | 80 only
-- 26 | '\0\xFF' | leading NUL, then FF
INSERT INTO t_varchar VALUES
  (21, CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (22, CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (23, CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)),
  (24, CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)),
  (25, CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)),
  (26, CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary));

-- t_char_short and t_char_long: the values of t_varchar as CHAR(3) and CHAR(5)
INSERT INTO t_char_short SELECT * FROM t_varchar;
INSERT INTO t_char_long SELECT * FROM t_varchar;

INSERT INTO t_char_long_part SELECT * FROM t_char_long;

UPDATE STATISTICS ON t_char_short, t_char_long, t_varchar, t_char_long_part WITH FULLSCAN;

evaluate 'Case 1: hash join of t_char_short and t_char_long returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_char_short x, t_char_long y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_char_short x, t_char_long y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_char_short x, t_char_long y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 2: hash join of t_char_short and t_varchar returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_char_short x, t_varchar y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_char_short x, t_varchar y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_char_short x, t_varchar y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 3: hash join of t_char_long and t_varchar returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_char_long x, t_varchar y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_char_long x, t_varchar y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_char_long x, t_varchar y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 4: hash join of t_char_long and t_char_long returns the pairs of the nested loop join';
select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca, y.ca
from t_char_long x, t_char_long y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the nested loop join: PASS when the two queries return the same rows as a multiset
with
  hj_rows as (select /*+ use_hash no_parallel_hash_join no_parallel_subquery */ x.ca as x_ca, y.ca as y_ca from t_char_long x, t_char_long y where x.cb = y.cb),
  nl_rows as (select /*+ no_use_hash use_nl */ x.ca as x_ca, y.ca as y_ca from t_char_long x, t_char_long y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hj_rows difference all select * from nl_rows)
    union all
    (select * from nl_rows difference all select * from hj_rows)
  ) diff_result;

evaluate 'Case 5: t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST ('' AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST ('' AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 11 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 12 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 13 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 14 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT 15 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (105 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (105 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 16 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (73 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (73 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 17 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 18 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (101 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (101 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 19 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (69 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (69 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 20 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

-- 21 to 26: bytes 80 and FF, which are not ASCII: alone, after 'a' and a space, and next to a NUL
SELECT 21 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 22 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 23 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 24 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 25 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (128 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (128 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT 26 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS CHAR(5) COLLATE binary)) AS cnt_part;

SELECT COUNT (*)
FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) AS CHAR(5) COLLATE binary);
show trace;

evaluate 'Case 6: t_char_long_part prune per VARCHAR(40) constant reads one partition and matches t_char_long';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST ('' AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (32 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 11 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 12 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 13 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 14 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT 15 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (105 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 16 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (73 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 17 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (115 USING binary) || CHR (115 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 18 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (101 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 19 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (69 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 20 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (9 USING binary) || CHR (98 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

-- 21 to 26: bytes 80 and FF, which are not ASCII: alone, after 'a' and a space, and next to a NUL
SELECT 21 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 22 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 23 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) || CHR (32 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 24 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (128 USING binary) || CHR (0 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 25 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (128 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT 26 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING binary) || CHR (255 USING binary) AS VARCHAR(40) COLLATE binary)) AS cnt_part;

SELECT COUNT (*)
FROM t_char_long_part WHERE cb = CAST (CHR (97 USING binary) AS VARCHAR(40) COLLATE binary);
show trace;

-- cleanup
drop table if exists t_char_short, t_char_long, t_varchar, t_char_long_part;

set trace off;
