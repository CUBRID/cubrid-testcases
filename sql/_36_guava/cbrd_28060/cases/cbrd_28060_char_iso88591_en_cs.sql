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
 *  For the built-in collation iso88591_en_cs, t_varchar holds the keys as VARCHAR(40), and
 *  t_char_short, t_char_long, and t_char_long_part hold the same values as CHAR(3), CHAR(5), and
 *  CHAR(5) with hash partitions, so a key of one length meets a key of another length.
 *
 *  Coverage:
 *    Case 1:  iso88591_en_cs - hash join of t_char_long and t_char_long returns the pairs of the nested loop join
 *    Case 2:  iso88591_en_cs - hash join of t_char_short and t_char_long returns the pairs of the nested loop join
 *    Case 3:  iso88591_en_cs - hash join of t_char_short and t_varchar returns the pairs of the nested loop join
 *    Case 4:  iso88591_en_cs - hash join of t_char_long and t_varchar returns the pairs of the nested loop join
 *    Case 5:  iso88591_en_cs - hash GROUP BY on t_char_long returns the groups of the sort GROUP BY
 *    Case 6:  iso88591_en_cs - t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long
 *    Case 7:  iso88591_en_cs - t_char_long_part prune per VARCHAR(40) constant reads one partition and matches
 *             t_char_long
 *    Case 8:  iso88591_en_cs - hash list scan of t_char_short and t_char_long returns the pairs of the join without the
 *             hash list scan
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server. The keys with trailing spaces compare as
-- they do because of ignore_trailing_space=no, the default of the CTP database

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

-- iso88591_en_cs
DROP TABLE IF EXISTS t_char_long_part, t_varchar, t_char_long, t_char_short;
CREATE TABLE t_char_short (ca INT, cb CHAR(3) COLLATE iso88591_en_cs);
CREATE TABLE t_char_long (ca INT, cb CHAR(5) COLLATE iso88591_en_cs);
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE iso88591_en_cs);
CREATE TABLE t_char_long_part (ca INT, cb CHAR(5) COLLATE iso88591_en_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- t_varchar holds the values, and t_char_short and t_char_long take them from it: CHAR pads a value with spaces,
-- so 'a', 'a ' and 'a  ' are one value there, and only VARCHAR keeps them apart

-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
-- ca | cb   | note
-- ---+------+----------------
--  1 | ''   | empty string
--  2 | ' '  | a space only
--  3 | '  ' | two spaces only
INSERT INTO t_varchar VALUES
  (1, CAST ('' AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (2, CAST (CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (3, CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

-- 4 to 7: trailing spaces after a character, and its upper case
-- ca | cb    | note
-- ---+-------+--------------------
--  4 | 'a'   |
--  5 | 'a '  | trailing space
--  6 | 'a  ' | two trailing spaces
--  7 | 'A'   | upper case of 'a'
INSERT INTO t_varchar VALUES
  (4, CAST (CHR (97 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (5, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (6, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (7, CAST (CHR (65 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

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
  (8, CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (9, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (10, CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (11, CAST (CHR (0 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (12, CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (13, CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (14, CAST (CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

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
  (15, CAST (CHR (105 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (16, CAST (CHR (73 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (17, CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (18, CAST (CHR (101 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (19, CAST (CHR (69 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (20, CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
-- ca | cb          | note
-- ---+-------------+--------------------------
-- 21 | '<U+00E9>'  | E9, e acute
-- 22 | '<U+00C9>'  | C9, upper case of E9
-- 23 | '<U+00DF>'  | DF, sharp s
-- 24 | 'a<U+00E9>' | ASCII then E9
-- 25 | 'A<U+00C9>' | upper case of 'a<U+00E9>'
INSERT INTO t_varchar VALUES
  (21, CAST (CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (22, CAST (CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (23, CAST (CHR (223 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (24, CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (25, CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
-- ca | cb           | note
-- ---+--------------+-------------------
-- 26 | '<U+00A0>'   | A0, no-break space
-- 27 | 'a<U+00A0>b' | A0 in the middle
INSERT INTO t_varchar VALUES
  (26, CAST (CHR (160 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs)),
  (27, CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS VARCHAR(40) COLLATE iso88591_en_cs));

-- t_char_short and t_char_long: the values of t_varchar as CHAR(3) and CHAR(5)
INSERT INTO t_char_short SELECT * FROM t_varchar;
INSERT INTO t_char_long SELECT * FROM t_varchar;

INSERT INTO t_char_long_part SELECT * FROM t_char_long;

UPDATE STATISTICS ON t_char_short, t_char_long, t_varchar, t_char_long_part WITH FULLSCAN;

evaluate 'Case 1: iso88591_en_cs - hash join of t_char_long and t_char_long returns the pairs of the nested loop join';
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

evaluate 'Case 2: iso88591_en_cs - hash join of t_char_short and t_char_long returns the pairs of the nested loop join';
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

evaluate 'Case 3: iso88591_en_cs - hash join of t_char_short and t_varchar returns the pairs of the nested loop join';
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

evaluate 'Case 4: iso88591_en_cs - hash join of t_char_long and t_varchar returns the pairs of the nested loop join';
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

evaluate 'Case 5: iso88591_en_cs - hash GROUP BY on t_char_long returns the groups of the sort GROUP BY';
select min(ca), count(*) from t_char_long group by cb order by 1, 2;
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

evaluate 'Case 6: iso88591_en_cs - t_char_long_part prune per CHAR(5) constant reads one partition and matches t_char_long';
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT '[]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST ('' AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[  ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT '[a]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a  ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[A]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
SELECT '[a b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\0b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\0]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[\0]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[\0b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (0 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (32 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT '[i]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (105 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[I]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (73 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ss]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (115 USING iso88591) || CHR (115 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[e]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (101 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[E]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (69 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\tb]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
SELECT '[<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[<U+00C9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[<U+00DF>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (223 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (233 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[A<U+00C9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (65 USING iso88591) || CHR (201 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
SELECT '[<U+00A0>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (160 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a<U+00A0>b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (CHR (97 USING iso88591) AS CHAR(5) COLLATE iso88591_en_cs);
show trace;

evaluate 'Case 7: iso88591_en_cs - t_char_long_part prune per VARCHAR(40) constant reads one partition and matches t_char_long';
-- each constant is padded with spaces to the 5 characters that t_char_long.cb holds: with ignore_trailing_space=no
-- the trailing spaces of a VARCHAR count, and a shorter constant would match no row
-- 1 to 3: empty string and spaces only: a key with no byte other than spaces
SELECT '[]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD ('', 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD ('', 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[  ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (32 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (32 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

-- 4 to 7: trailing spaces after a character, and its upper case
SELECT '[a]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a  ]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (32 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[A]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (65 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (65 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

-- 8 to 14: a NUL against a space in the middle, at the end and at the start
SELECT '[a b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (32 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\0b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (0 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\0]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (0 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (0 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[\0]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (0 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (0 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[\0b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (0 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (0 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (32 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (32 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

-- 15 to 20: ASCII pairs the case insensitive and expansion collations find equal; a tab, not a space
SELECT '[i]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (105 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (105 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[I]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (73 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (73 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[ss]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (115 USING iso88591) || CHR (115 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (115 USING iso88591) || CHR (115 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[e]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (101 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (101 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[E]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (69 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (69 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a\tb]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (9 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

-- 21 to 25: 1-byte Latin-1 characters: accents and sharp s, the counterparts of the ASCII pairs above
SELECT '[<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (233 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (233 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[<U+00C9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (201 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (201 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[<U+00DF>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (223 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (223 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (233 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (233 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[A<U+00C9>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (65 USING iso88591) || CHR (201 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (65 USING iso88591) || CHR (201 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

-- 26 to 27: A0 no-break space: 1 byte that is not the byte 0x20
SELECT '[<U+00A0>]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (160 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (160 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT '[a<U+00A0>b]' AS cb,
  (SELECT COUNT (*) FROM t_char_long WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591) || CHR (160 USING iso88591) || CHR (98 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs)) AS cnt_part;

SELECT COUNT (*)
FROM t_char_long_part WHERE cb = CAST (RPAD (CHR (97 USING iso88591), 5) AS VARCHAR(40) COLLATE iso88591_en_cs);
show trace;

evaluate 'Case 8: iso88591_en_cs - hash list scan of t_char_short and t_char_long returns the pairs of the join without the hash list scan';
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
