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
 *  of each value in t_char_long_part and in t_char_long, and the two counts must match. SHOW TRACE shows the path that
 *  each hash case took. CTP masks the digits of a trace, so the answer checks only the path: HASHJOIN, hash true and
 *  sort false in GROUPBY, one PARTITION line for the one value that a prune case traces after it counts the rows of
 *  every value, and SCAN (hash temp(m), ...) for the hash list scan.
 *
 *  The keys are utf8_bin strings that differ only in a NUL or a space (in the middle, at the end, at the start), and
 *  strings with 2-byte and 3-byte characters. t_varchar holds the keys as VARCHAR(40), and t_char_short, t_char_long,
 *  and t_char_long_part hold the same values as CHAR(3), CHAR(5), and CHAR(5) with hash partitions, so a key of one
 *  length meets a key of another length.
 *
 *  Coverage:
 *    Case 1:  utf8_bin - hash join of t_char_long and t_char_long returns the pairs of the nested loop join
 *    Case 2:  utf8_bin - hash join of t_char_short and t_char_long returns the pairs of the nested loop join
 *    Case 3:  utf8_bin - hash join of t_char_short and t_varchar returns the pairs of the nested loop join
 *    Case 4:  utf8_bin - hash join of t_char_long and t_varchar returns the pairs of the nested loop join
 *    Case 5:  utf8_bin - hash GROUP BY on t_char_long returns the groups of the sort GROUP BY
 *    Case 6:  utf8_bin - t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long
 *    Case 7:  utf8_bin - t_char_long_part prune per VARCHAR(40) constant reads one partition and matches t_char_long
 *    Case 8:  utf8_bin - hash list scan of t_char_short and t_char_long returns the pairs of the join without the hash
 *             list scan
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server. The keys with trailing spaces compare as
-- they do because of ignore_trailing_space=no, the default of the CTP database

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

DROP TABLE IF EXISTS t_char_long_part, t_varchar, t_char_long, t_char_short;
CREATE TABLE t_char_short (ca INT, cb CHAR(3) COLLATE utf8_bin);
CREATE TABLE t_char_long (ca INT, cb CHAR(5) COLLATE utf8_bin);
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_bin);
CREATE TABLE t_char_long_part (ca INT, cb CHAR(5) COLLATE utf8_bin) PARTITION BY HASH (cb) PARTITIONS 7;

-- t_varchar holds the values, and t_char_short and t_char_long take them from it: CHAR pads a value with spaces,
-- so 'a', 'a ' and 'a  ' are one value there, and only VARCHAR keeps them apart

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO t_varchar VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE utf8_bin)),
  (2, CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (3, CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO t_varchar VALUES
  (4, CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (5, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (6, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (7, CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

-- 8 to 14: a NUL against a space in the middle, at the end and at the start: utf8_bin compares a NUL as a space
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
  (8, CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (9, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (10, CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (11, CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (12, CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (13, CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (14, CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

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
  (15, CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (16, CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (17, CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (18, CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (19, CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (20, CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

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
INSERT INTO t_varchar VALUES
  (21, CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (22, CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (23, CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (24, CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (25, CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (26, CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (27, CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
-- ca | cb           | note
-- ---+--------------+---------------------------
-- 28 | '<U+3000>'   | ideographic space, 3 bytes
-- 29 | 'a<U+3000>b' | U+3000 in the middle
INSERT INTO t_varchar VALUES
  (28, CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (29, CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
-- ca | cb                 | note
-- ---+--------------------+----------------------------------------
-- 30 | '<U+AC00>'         | Hangul GA, 3 bytes
-- 31 | '<U+AC00> '        | trailing space after a 3-byte character
-- 32 | '<U+AC00>\0'       | trailing NUL after a 3-byte character
-- 33 | '<U+AC00><U+3000>' | trailing U+3000
INSERT INTO t_varchar VALUES
  (30, CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (31, CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (32, CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)),
  (33, CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin));

-- t_char_short and t_char_long: the values of t_varchar as CHAR(3) and CHAR(5)
INSERT INTO t_char_short SELECT * FROM t_varchar;
INSERT INTO t_char_long SELECT * FROM t_varchar;

INSERT INTO t_char_long_part SELECT * FROM t_char_long;

UPDATE STATISTICS ON t_char_short, t_char_long, t_varchar, t_char_long_part WITH FULLSCAN;

evaluate 'Case 1: utf8_bin - hash join of t_char_long and t_char_long returns the pairs of the nested loop join';
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

evaluate 'Case 2: utf8_bin - hash join of t_char_short and t_char_long returns the pairs of the nested loop join';
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

evaluate 'Case 3: utf8_bin - hash join of t_char_short and t_varchar returns the pairs of the nested loop join';
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

evaluate 'Case 4: utf8_bin - hash join of t_char_long and t_varchar returns the pairs of the nested loop join';
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

evaluate 'Case 5: utf8_bin - hash GROUP BY on t_char_long returns the groups of the sort GROUP BY';
select min(ca), count(*)
from t_char_long group by cb order by 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select min(ca) as min_ca, count(*) as cnt from t_char_long group by cb),
  sort_rows as (select /*+ no_hash_aggregate */ min(ca) as min_ca, count(*) as cnt from t_char_long group by cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

evaluate 'Case 6: utf8_bin - t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST ('' AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start: utf8_bin compares a NUL as a space
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 11 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 12 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 13 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 14 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT 15 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (105 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 16 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (73 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 17 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 18 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (101 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 19 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (69 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 20 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
SELECT 21 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50353 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 22 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50352 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 23 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 24 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 25 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50079 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 26 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 27 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
SELECT 28 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 29 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
SELECT 30 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 31 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 32 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT 33 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS CHAR(5) COLLATE utf8_bin)) AS cnt_part;

SELECT COUNT (*)
FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) AS CHAR(5) COLLATE utf8_bin);
show trace;

evaluate 'Case 7: utf8_bin - t_char_long_part prune per VARCHAR(40) constant reads one partition and matches t_char_long';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT 1 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST ('' AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 2 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 3 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT 4 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 5 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 6 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 7 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start: utf8_bin compares a NUL as a space
SELECT 8 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 9 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 10 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 11 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 12 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 13 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 14 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT 15 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (105 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 16 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (73 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 17 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (115 USING utf8) || CHR (115 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 18 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (101 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 19 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (69 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 20 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (9 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 21 to 27: 2-byte characters: the Turkish i, accents and sharp s, the counterparts of the ASCII pairs above
SELECT 21 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50353 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 22 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50352 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 23 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 24 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 25 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (50079 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 26 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (50089 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 27 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING utf8) || CHR (50057 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 28 to 29: U+3000 ideographic space: 3 bytes, none of them the byte 0x20
SELECT 28 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 29 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) || CHR (14909568 USING utf8) || CHR (98 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

-- 30 to 33: a 3-byte character followed by a space, a NUL or U+3000
SELECT 30 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 31 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (32 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 32 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (0 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT 33 AS ca,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (15380608 USING utf8) || CHR (14909568 USING utf8) AS VARCHAR(40) COLLATE utf8_bin)) AS cnt_part;

SELECT COUNT (*)
FROM t_char_long_part WHERE cb = CAST (CHR (97 USING utf8) AS VARCHAR(40) COLLATE utf8_bin);
show trace;

evaluate 'Case 8: utf8_bin - hash list scan of t_char_short and t_char_long returns the pairs of the join without the hash list scan';
select /*+ ordered parallel(0) */ x.ca, y.ca
from t_char_short x, (select /*+ NO_MERGE */ ca, cb from t_char_long where ca >= 1) y where x.cb = y.cb order by 1, 2;
show trace;

-- compare with the join without the hash list scan: PASS when the two queries return the same rows as a multiset
with
  hashscan_rows as (select /*+ ordered parallel(0) */ x.ca as x_ca, y.ca as y_ca from t_char_short x, (select /*+ NO_MERGE */ ca, cb from t_char_long where ca >= 1) y where x.cb = y.cb),
  listscan_rows as (select /*+ ordered parallel(0) NO_HASH_LIST_SCAN */ x.ca as x_ca, y.ca as y_ca from t_char_short x, (select /*+ NO_MERGE */ ca, cb from t_char_long where ca >= 1) y where x.cb = y.cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hashscan_rows difference all select * from listscan_rows)
    union all
    (select * from listscan_rows difference all select * from hashscan_rows)
  ) diff_result;

-- cleanup
set system parameters 'agg_hash_respect_order=default';

drop table if exists t_char_short, t_char_long, t_varchar, t_char_long_part;

set trace off;
