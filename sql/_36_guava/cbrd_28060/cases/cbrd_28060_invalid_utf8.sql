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
 *  The keys are invalid UTF-8 byte strings. The comparison of utf8_ko_cs reads them as code points
 *  and reads some different bytes as one code point - C1 81 as A, and 80 and 81 as one - so the
 *  hash of utf8_ko_cs must hash the code points, not the bytes. utf8_bin compares the bytes and
 *  is the control.
 *
 *  Coverage:
 *    Case 1:  utf8_bin - hash join of ta and tb returns the pairs of the nested loop join
 *    Case 2:  utf8_bin - hash GROUP BY on ta returns the groups of the sort GROUP BY
 *    Case 3:  utf8_bin - tc prune per VARCHAR(10) constant reads one partition and matches ta
 *    Case 4:  utf8_ko_cs - hash join of ta and tb returns the pairs of the nested loop join
 *    Case 5:  utf8_ko_cs - hash GROUP BY on ta returns the groups of the sort GROUP BY
 *    Case 6:  utf8_ko_cs - tc prune per VARCHAR(10) constant reads one partition and matches ta
 */

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace
-- holds no parallel workers lines, whose presence depends on the cores of the server

-- utf8_bin
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(10) COLLATE utf8_bin);
CREATE TABLE tb (ca INT, cb VARCHAR(10) COLLATE utf8_bin);
CREATE TABLE tc (ca INT, cb VARCHAR(10) COLLATE utf8_bin) PARTITION BY HASH (cb) PARTITIONS 7;
-- FROM_BASE64 makes the bytes, so this file holds no invalid UTF-8
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
-- ca | cb bytes | note
-- ---+----------+----------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
INSERT INTO ta VALUES
  (1, CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)),
  (2, CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin));

-- 3 to 4: 'é' and its lead byte followed by a byte that is not a continuation byte
-- ca | cb bytes | note
-- ---+----------+---------------------------
--  3 | C3 A9    | 'é'
--  4 | C3 29    | lead byte of 'é', then ')'
INSERT INTO ta VALUES
  (3, CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)),
  (4, CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin));

-- 5 to 6: a lone continuation byte
-- ca | cb bytes
-- ---+---------
--  5 | 80
--  6 | 81
INSERT INTO ta VALUES
  (5, CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)),
  (6, CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin));

-- 7 to 8: a lone continuation byte between ASCII characters
-- ca | cb bytes | note
-- ---+----------+-------------
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
INSERT INTO ta VALUES
  (7, CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)),
  (8, CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin));
INSERT INTO tb SELECT * FROM ta;
INSERT INTO tc SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 1: utf8_bin - hash join of ta and tb returns the pairs of the nested loop join';
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

evaluate 'Case 2: utf8_bin - hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

evaluate 'Case 3: utf8_bin - tc prune per VARCHAR(10) constant reads one partition and matches ta';
set trace on;
-- ca | cb bytes | note
-- ---+----------+----------------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
--  3 | C3 A9    | '<U+00E9>'
--  4 | C3 29    | lead byte of '<U+00E9>', then ')'
--  5 | 80       |
--  6 | 81       |
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_bin)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- utf8_ko_cs
DROP TABLE IF EXISTS tc, tb, ta;
CREATE TABLE ta (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs);
CREATE TABLE tb (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs);
CREATE TABLE tc (ca INT, cb VARCHAR(10) COLLATE utf8_ko_cs) PARTITION BY HASH (cb) PARTITIONS 7;
-- FROM_BASE64 makes the bytes, so this file holds no invalid UTF-8
-- 1 to 2: 'A' and its overlong 2-byte form, which intl_utf8_to_cp () reads as 'A'
-- ca | cb bytes | note
-- ---+----------+----------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
INSERT INTO ta VALUES
  (1, CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (2, CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 3 to 4: 'é' and its lead byte followed by a byte that is not a continuation byte
-- ca | cb bytes | note
-- ---+----------+---------------------------
--  3 | C3 A9    | 'é'
--  4 | C3 29    | lead byte of 'é', then ')'
INSERT INTO ta VALUES
  (3, CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (4, CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 5 to 6: a lone continuation byte
-- ca | cb bytes
-- ---+---------
--  5 | 80
--  6 | 81
INSERT INTO ta VALUES
  (5, CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (6, CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs));

-- 7 to 8: a lone continuation byte between ASCII characters
-- ca | cb bytes | note
-- ---+----------+-------------
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
INSERT INTO ta VALUES
  (7, CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)),
  (8, CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs));
INSERT INTO tb SELECT * FROM ta;
INSERT INTO tc SELECT * FROM ta;

UPDATE STATISTICS ON ta, tb, tc WITH FULLSCAN;

evaluate 'Case 4: utf8_ko_cs - hash join of ta and tb returns the pairs of the nested loop join';
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

evaluate 'Case 5: utf8_ko_cs - hash GROUP BY on ta returns the groups of the sort GROUP BY';
set trace on;
select min(ca), count(*) from ta group by cb order by 1, 2;
show trace;
set trace off;
select /*+ no_hash_aggregate */ min(ca), count(*) from ta group by cb order by 1, 2;

evaluate 'Case 6: utf8_ko_cs - tc prune per VARCHAR(10) constant reads one partition and matches ta';
set trace on;
-- ca | cb bytes | note
-- ---+----------+----------------------------------
--  1 | 41       | 'A'
--  2 | C1 81    | overlong 'A', invalid UTF-8
--  3 | C3 A9    | '<U+00E9>'
--  4 | C3 29    | lead byte of '<U+00E9>', then ')'
--  5 | 80       |
--  6 | 81       |
--  7 | 61 80 62 | 'a', 80, 'b'
--  8 | 61 81 62 | 'a', 81, 'b'
select /*+ no_parallel_subquery */ ca, cnt_base, cnt_part
from (
  SELECT 1 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('QQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 2 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('wYE=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 3 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('w6k=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 4 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('wyk=') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 5 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('gA==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 6 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('gQ==') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 7 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('YYBi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
  UNION ALL
  SELECT 8 AS ca,
    (SELECT COUNT (*) FROM ta WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_base,
    (SELECT COUNT (*) FROM tc WHERE cb = CAST (FROM_BASE64 ('YYFi') AS VARCHAR(10) COLLATE utf8_ko_cs)) AS cnt_part
) r
order by ca;
show trace;
set trace off;

-- cleanup
set trace off;

drop table if exists ta, tb, tc;
