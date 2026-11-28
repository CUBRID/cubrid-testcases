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
 *  The keys are invalid UTF-8 byte strings. The comparison of utf8_ko_cs reads them as code points and reads some
 *  different bytes as one code point (C1 81 as A, 80 and 81 as one, and a lead byte followed by spaces, C3 20, as C3
 *  A0), so the hash of utf8_ko_cs must hash the code points, not the bytes, and must not leave out a space that a lead
 *  byte reads. utf8_bin compares the bytes and is the control.
 *
 *  Coverage:
 *    Case 1:  utf8_bin - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join
 *    Case 2:  utf8_bin - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY
 *    Case 3:  utf8_bin - t_varchar_part prune per VARCHAR(10) constant reads one partition and matches t_varchar_a
 *    Case 4:  utf8_bin - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash
 *             list scan
 *    Case 5:  utf8_ko_cs - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join
 *    Case 6:  utf8_ko_cs - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY
 *    Case 7:  utf8_ko_cs - t_varchar_part prune per VARCHAR(10) constant reads one partition and matches t_varchar_a
 *    Case 8:  utf8_ko_cs - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash
 *             list scan
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

-- utf8_bin
DROP TABLE IF EXISTS t_varchar_part, t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(10) COLLATE utf8_bin);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(10) COLLATE utf8_bin);
CREATE TABLE t_varchar_part (ca INT, cb VARCHAR(10) COLLATE utf8_bin) PARTITION BY HASH (cb) PARTITIONS 7;

-- FROM_BASE64 makes the bytes, so this file holds no invalid UTF-8
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
-- ca | cb bytes | note
-- ---+----------+----------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
INSERT INTO t_varchar_a VALUES
  (1, CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)),
  (2, CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin));

-- 3 to 4: '<U+00E9>' and its lead byte followed by a byte that is not a continuation byte
-- ca | cb bytes | note
-- ---+----------+----------------------------------
--  3 | C3 A9    | '<U+00E9>'
--  4 | C3 29    | lead byte of '<U+00E9>', then ')'
INSERT INTO t_varchar_a VALUES
  (3, CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)),
  (4, CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin));

-- 5 to 6: a lone continuation byte
-- ca | cb bytes
-- ---+---------
--  5 | 80
--  6 | 81
INSERT INTO t_varchar_a VALUES
  (5, CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)),
  (6, CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin));

-- 7 to 8: a lone continuation byte between ASCII characters
-- ca | cb bytes | note
-- ---+----------+-------------
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
INSERT INTO t_varchar_a VALUES
  (7, CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)),
  (8, CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin));

-- 9 to 14: a lead byte followed by spaces, which intl_utf8_to_cp () reads as the lead byte's next bytes,
-- and the character it reads them as; 11 to 14 end in more spaces
-- ca | cb bytes          | note
-- ---+-------------------+-----------------------------------------------
--  9 | C3 A0             | '<U+00E0>'
-- 10 | C3 20             | lead byte of '<U+00E0>', then a space
-- 11 | C3 A0 20 20 20 20 | '<U+00E0>', then 4 spaces
-- 12 | C3 20 20 20 20 20 | lead byte of '<U+00E0>', then 5 spaces
-- 13 | F0 A0 A0 A0 20 20 | a 4-byte character, then 2 spaces
-- 14 | F0 20 20 20 20 20 | lead byte of a 4-byte character, then 5 spaces
INSERT INTO t_varchar_a VALUES
  (9, CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_bin)),
  (10, CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_bin)),
  (11, CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_bin)),
  (12, CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_bin)),
  (13, CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_bin)),
  (14, CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_bin));
INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;
INSERT INTO t_varchar_part SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b, t_varchar_part WITH FULLSCAN;

evaluate 'Case 1: utf8_bin - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join';
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

evaluate 'Case 2: utf8_bin - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY';
select min(ca), count(*) from t_varchar_a group by cb order by 1, 2;
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

evaluate 'Case 3: utf8_bin - t_varchar_part prune per VARCHAR(10) constant reads one partition and matches t_varchar_a';
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
SELECT /*+ no_parallel_subquery */ 1 AS ca, '[A]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 2 AS ca, '[\xC1\x81]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

-- 3 to 4: '<U+00E9>' and its lead byte followed by a byte that is not a continuation byte
SELECT /*+ no_parallel_subquery */ 3 AS ca, '[<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 4 AS ca, '[\xC3)]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

-- 5 to 6: a lone continuation byte
SELECT /*+ no_parallel_subquery */ 5 AS ca, '[\x80]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 6 AS ca, '[\x81]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

-- 7 to 8: a lone continuation byte between ASCII characters
SELECT /*+ no_parallel_subquery */ 7 AS ca, '[a\x80b]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 8 AS ca, '[a\x81b]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

-- 9 to 14: a lead byte followed by spaces, which intl_utf8_to_cp () reads as the lead byte's next bytes,
-- and the character it reads them as; 11 to 14 end in more spaces
SELECT /*+ no_parallel_subquery */ 9 AS ca, '[<U+00E0>]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 10 AS ca, '[\xC3 ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 11 AS ca, '[<U+00E0>    ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 12 AS ca, '[\xC3     ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 13 AS ca, '[<U+20820>  ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 14 AS ca, '[\xF0     ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part;
show trace;

evaluate 'Case 4: utf8_bin - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash list scan';
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

-- utf8_ko_cs
DROP TABLE IF EXISTS t_varchar_part, t_varchar_b, t_varchar_a;
CREATE TABLE t_varchar_a (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs);
CREATE TABLE t_varchar_b (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs);
CREATE TABLE t_varchar_part (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs) PARTITION BY HASH (cb) PARTITIONS 7;

-- FROM_BASE64 makes the bytes, so this file holds no invalid UTF-8
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
-- ca | cb bytes | note
-- ---+----------+----------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
INSERT INTO t_varchar_a VALUES
  (1, CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (2, CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 3 to 4: '<U+00E9>' and its lead byte followed by a byte that is not a continuation byte
-- ca | cb bytes | note
-- ---+----------+----------------------------------
--  3 | C3 A9    | '<U+00E9>'
--  4 | C3 29    | lead byte of '<U+00E9>', then ')'
INSERT INTO t_varchar_a VALUES
  (3, CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (4, CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 5 to 6: a lone continuation byte
-- ca | cb bytes
-- ---+---------
--  5 | 80
--  6 | 81
INSERT INTO t_varchar_a VALUES
  (5, CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (6, CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 7 to 8: a lone continuation byte between ASCII characters
-- ca | cb bytes | note
-- ---+----------+-------------
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
INSERT INTO t_varchar_a VALUES
  (7, CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (8, CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 9 to 14: a lead byte followed by spaces, which intl_utf8_to_cp () reads as the lead byte's next bytes,
-- and the character it reads them as; 11 to 14 end in more spaces
-- ca | cb bytes          | note
-- ---+-------------------+-----------------------------------------------
--  9 | C3 A0             | '<U+00E0>'
-- 10 | C3 20             | lead byte of '<U+00E0>', then a space
-- 11 | C3 A0 20 20 20 20 | '<U+00E0>', then 4 spaces
-- 12 | C3 20 20 20 20 20 | lead byte of '<U+00E0>', then 5 spaces
-- 13 | F0 A0 A0 A0 20 20 | a 4-byte character, then 2 spaces
-- 14 | F0 20 20 20 20 20 | lead byte of a 4-byte character, then 5 spaces
INSERT INTO t_varchar_a VALUES
  (9, CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (10, CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (11, CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (12, CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (13, CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (14, CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs));
INSERT INTO t_varchar_b SELECT * FROM t_varchar_a;
INSERT INTO t_varchar_part SELECT * FROM t_varchar_a;

UPDATE STATISTICS ON t_varchar_a, t_varchar_b, t_varchar_part WITH FULLSCAN;

evaluate 'Case 5: utf8_ko_cs - hash join of t_varchar_a and t_varchar_b returns the pairs of the nested loop join';
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

evaluate 'Case 6: utf8_ko_cs - hash GROUP BY on t_varchar_a returns the groups of the sort GROUP BY';
select min(ca), count(*) from t_varchar_a group by cb order by 1, 2;
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

evaluate 'Case 7: utf8_ko_cs - t_varchar_part prune per VARCHAR(10) constant reads one partition and matches t_varchar_a';
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
SELECT /*+ no_parallel_subquery */ 1 AS ca, '[A]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 2 AS ca, '[\xC1\x81]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

-- 3 to 4: '<U+00E9>' and its lead byte followed by a byte that is not a continuation byte
SELECT /*+ no_parallel_subquery */ 3 AS ca, '[<U+00E9>]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 4 AS ca, '[\xC3)]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

-- 5 to 6: a lone continuation byte
SELECT /*+ no_parallel_subquery */ 5 AS ca, '[\x80]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 6 AS ca, '[\x81]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

-- 7 to 8: a lone continuation byte between ASCII characters
SELECT /*+ no_parallel_subquery */ 7 AS ca, '[a\x80b]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 8 AS ca, '[a\x81b]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

-- 9 to 14: a lead byte followed by spaces, which intl_utf8_to_cp () reads as the lead byte's next bytes,
-- and the character it reads them as; 11 to 14 end in more spaces
SELECT /*+ no_parallel_subquery */ 9 AS ca, '[<U+00E0>]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6A=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 10 AS ca, '[\xC3 ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyA=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 11 AS ca, '[<U+00E0>    ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('w6AgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 12 AS ca, '[\xC3     ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('wyAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 13 AS ca, '[<U+20820>  ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('8KCgoCAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;

SELECT /*+ no_parallel_subquery */ 14 AS ca, '[\xF0     ]' AS cb,
  (SELECT COUNT (*) FROM t_varchar_a WHERE cb = CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
  (SELECT COUNT (*) FROM t_varchar_part WHERE cb = CAST (FROM_BASE64 ('8CAgICAg') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part;
show trace;

evaluate 'Case 8: utf8_ko_cs - hash list scan of t_varchar_a and t_varchar_b returns the pairs of the join without the hash list scan';
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
