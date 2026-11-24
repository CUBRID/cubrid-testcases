/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A hash GROUP BY puts each key into a hash table of max_agg_hash_size. When the table overflows, it moves the rest of
 *  the rows into partitions by the hash and groups each partition again (the hash merge). The change lets the keys of
 *  an expansion collation reach the hash merge. If the hash of two keys that compare equal differs, a group splits in
 *  two, so each hash GROUP BY must return the groups of its sort GROUP BY twin. The verification block after each hash
 *  GROUP BY prints PASS when the two queries return the same rows as a multiset. SHOW TRACE shows hash partial with
 *  hash merge partitions in GROUPBY for Cases 1 to 5 and 7 to 9, and hash true with sort false for Case 6.
 *
 *  Case 6 is the one case whose groups fit the hash table, and it runs for utf8_de_exp_ai_ci only, so it follows the
 *  hash merge cases of the five collations.
 *
 *  Cases 7 to 9 group keys of other types through the hash merge: JSON, whose spellings 1.0 and 1e0 compare equal
 *  and 1, 1.0 and "1" do not; NUMERIC without a precision, whose values 1.5, 1.50 and 1.500 compare equal; and a
 *  JSON column with an INT column.
 *
 *  Coverage:
 *    Case 1:  utf8_de_exp_ai_ci - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort
 *             GROUP BY
 *    Case 2:  utf8_de_exp - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY
 *    Case 3:  utf8_fr_exp_ab - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP
 *             BY
 *    Case 4:  utf8_gen_ai_ci - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP
 *             BY
 *    Case 5:  utf8_bin - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY
 *    Case 6:  utf8_de_exp_ai_ci - hash GROUP BY on t_varchar within the hash table returns the groups of the sort GROUP
 *             BY
 *    Case 7:  JSON - hash GROUP BY on t_json through the hash merge returns the groups of the sort GROUP BY
 *    Case 8:  float NUMERIC - hash GROUP BY on t_numeric through the hash merge returns the groups of the sort GROUP BY
 *    Case 9:  JSON and INT - hash GROUP BY on t_json by two columns through the hash merge returns the groups of the
 *             sort GROUP BY
 */

set trace on;

-- The hash cases add no_parallel_hash_join and no_parallel_subquery, or parallel(0), so that the trace holds no
-- parallel workers lines, which depend on the number of cores of the server

-- agg_hash_respect_order=no makes a hash GROUP BY return its groups without sorting them, so a group that the hash
-- splits shows as two groups; with the default yes, the sort merges the two again
set system parameters 'agg_hash_respect_order=no';

-- 72000 rows, 4 rows for each key: the hash table of each collation below exceeds the default
-- max_agg_hash_size (2M), and the GROUP BY ends in the hash merge. With 36000 rows, 2 rows for each key,
-- the ratio of groups to rows is higher, and some collations end in the sort instead.
-- The TC leaves max_agg_hash_size as it is: the server reads the size once and keeps it
DROP TABLE IF EXISTS t_varchar, t_int;
CREATE TABLE t_int (ca INT, cb INT, cc INT);

-- t_int, ROWNUM r = 1 to 72000. Each t_varchar below takes ca of t_int, and builds cb from the spelling that cc
-- picks and the number cb of t_int
-- ca    | cb   | cc | t_varchar.cb
-- ------+------+----+--------------------
-- 1     | 1    | 0  | 'cafe-1'
-- 2999  | 2999 | 0  | 'cafe-2999'
-- 3000  | 0    | 1  | 'caf<U+00E9>-0'
-- 3001  | 1    | 1  | 'caf<U+00E9>-1'
-- 6000  | 0    | 2  | 'CAF<U+00C9>-0'
-- 18001 | 1    | 0  | 'cafe-1'
INSERT INTO t_int
SELECT ROWNUM, MOD (ROWNUM, 3000), MOD (FLOOR (ROWNUM / 3000), 6)
FROM db_class a, db_class b, db_class c, db_class d
LIMIT 72000;

-- utf8_de_exp_ai_ci
DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);
INSERT INTO t_varchar
SELECT ca,
  CASE cc
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || cb
FROM t_int;

UPDATE STATISTICS ON t_varchar WITH FULLSCAN;

evaluate 'Case 1: utf8_de_exp_ai_ci - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- utf8_de_exp
DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp);
INSERT INTO t_varchar
SELECT ca,
  CASE cc
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || cb
FROM t_int;

UPDATE STATISTICS ON t_varchar WITH FULLSCAN;

evaluate 'Case 2: utf8_de_exp - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- utf8_fr_exp_ab
DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_fr_exp_ab);
INSERT INTO t_varchar
SELECT ca,
  CASE cc
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || cb
FROM t_int;

UPDATE STATISTICS ON t_varchar WITH FULLSCAN;

evaluate 'Case 3: utf8_fr_exp_ab - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- utf8_gen_ai_ci
DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_gen_ai_ci);
INSERT INTO t_varchar
SELECT ca,
  CASE cc
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || cb
FROM t_int;

UPDATE STATISTICS ON t_varchar WITH FULLSCAN;

evaluate 'Case 4: utf8_gen_ai_ci - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- utf8_bin
DROP TABLE IF EXISTS t_varchar;
CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_bin);
INSERT INTO t_varchar
SELECT ca,
  CASE cc
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || cb
FROM t_int;

UPDATE STATISTICS ON t_varchar WITH FULLSCAN;

evaluate 'Case 5: utf8_bin - hash GROUP BY on t_varchar through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_varchar group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- 120 rows with 40 distinct keys, which fit the hash table of the default max_agg_hash_size
DROP TABLE IF EXISTS t_varchar, t_int;
CREATE TABLE t_int (ca INT);
INSERT INTO t_int SELECT ROWNUM FROM db_class a, db_class b LIMIT 120;

CREATE TABLE t_varchar (ca INT, cb VARCHAR(40) COLLATE utf8_de_exp_ai_ci);

-- t_varchar, ca = 1 to 120: MOD (ca, 6) picks one of six spellings, and the suffix is MOD (FLOOR (ca / 6), 20)
-- ca  | cb
-- ----+----------------------
-- 1   | 'caf<U+00E9>-0'
-- 2   | 'CAF<U+00C9>-0'
-- 3   | 'caf<U+00AD>e-0'
-- 4   | 'Strasse-0'
-- 5   | 'Stra<U+00DF>e-0'
-- 6   | 'cafe-1'
-- 120 | 'cafe-0'
INSERT INTO t_varchar
SELECT ca,
  CASE MOD (ca, 6)
    WHEN 0 THEN 'cafe'
    WHEN 1 THEN 'café'
    WHEN 2 THEN 'CAFÉ'
    WHEN 3 THEN 'caf' || CHR (49837 USING utf8) || 'e'
    WHEN 4 THEN 'Strasse'
    ELSE 'Straße'
  END || '-' || MOD (FLOOR (ca / 6), 20)
FROM t_int;

UPDATE STATISTICS ON t_int, t_varchar WITH FULLSCAN;

evaluate 'Case 6: utf8_de_exp_ai_ci - hash GROUP BY on t_varchar within the hash table returns the groups of the sort GROUP BY';
select /*+ parallel(0) */ min(ca), count(*)
from t_varchar group by cb order by 1, 2;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select /*+ parallel(0) */ min(ca) as min_ca, count(*) as cnt from t_varchar group by cb),
  sort_rows as (select /*+ no_hash_aggregate */ min(ca) as min_ca, count(*) as cnt from t_varchar group by cb)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- Cases 7 to 9 take the rows of t_int of Cases 1 to 5 again: 72000 rows, from which each table below builds 15000 or
-- 9000 groups, enough for the hash merge
DROP TABLE IF EXISTS t_int, t_json, t_numeric;
CREATE TABLE t_int (ca INT, cb INT, cc INT);

-- t_int, ROWNUM r = 1 to 72000: the rows of t_int of Cases 1 to 5
-- ca    | cb   | cc
-- ------+------+----
-- 1     | 1    | 0
-- 3000  | 0    | 1
-- 6000  | 0    | 2
-- 72000 | 0    | 0
INSERT INTO t_int
SELECT ROWNUM, MOD (ROWNUM, 3000), MOD (FLOOR (ROWNUM / 3000), 6)
FROM db_class a, db_class b, db_class c, db_class d
LIMIT 72000;

CREATE TABLE t_json (ca INT, cb JSON, cc INT);

-- t_json takes ca of t_int, spells cb from the number cb of t_int as cc of t_int picks, and holds the parity of that
-- number in cc. A GROUP BY finds 1.0 and 1e0 equal (one DOUBLE), and 1, 1.0 and "1" apart, so each number makes five
-- groups: 1; 1.0 and 1e0; "1"; [1]; 1.5. Row 72001 holds -0.0, which falls in the group of 0.0 and 0e0
-- ca    | cb      | cc
-- ------+---------+----
-- 1     | 1       | 1
-- 3001  | 1.0     | 1
-- 6001  | "1"     | 1
-- 9001  | 1e0     | 1
-- 12001 | [1]     | 1
-- 15001 | 1.5     | 1
-- 72001 | -0.0    | 0
INSERT INTO t_json
SELECT ca,
  CAST (CASE cc
    WHEN 0 THEN TO_CHAR (cb)
    WHEN 1 THEN TO_CHAR (cb) || '.0'
    WHEN 2 THEN '"' || TO_CHAR (cb) || '"'
    WHEN 3 THEN TO_CHAR (cb) || 'e0'
    WHEN 4 THEN '[' || TO_CHAR (cb) || ']'
    ELSE TO_CHAR (cb) || '.5'
  END AS JSON),
  MOD (cb, 2)
FROM t_int;
INSERT INTO t_json VALUES (72001, '-0.0', 0);

CREATE TABLE t_numeric (ca INT, cb NUMERIC);

-- t_numeric takes ca of t_int and spells cb from the number cb of t_int as cc of t_int picks. A NUMERIC without a
-- precision keeps the decimal places of each value, so 1.5, 1.50 and 1.500 are one value with three scales: each
-- number makes three groups: 1.5, 1.50 and 1.500; 1 and 1.0; 1.25
-- ca    | cb
-- ------+-------
-- 1     | 1.5
-- 3001  | 1.50
-- 6001  | 1.500
-- 9001  | 1
-- 12001 | 1.0
-- 15001 | 1.25
INSERT INTO t_numeric
SELECT ca,
  CAST (CASE cc
    WHEN 0 THEN TO_CHAR (cb) || '.5'
    WHEN 1 THEN TO_CHAR (cb) || '.50'
    WHEN 2 THEN TO_CHAR (cb) || '.500'
    WHEN 3 THEN TO_CHAR (cb)
    WHEN 4 THEN TO_CHAR (cb) || '.0'
    ELSE TO_CHAR (cb) || '.25'
  END AS NUMERIC)
FROM t_int;

UPDATE STATISTICS ON t_int, t_json, t_numeric WITH FULLSCAN;

evaluate 'Case 7: JSON - hash GROUP BY on t_json through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_json group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_json group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_json group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

evaluate 'Case 8: float NUMERIC - hash GROUP BY on t_numeric through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_numeric group by cb) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_numeric group by cb) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_numeric group by cb) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

evaluate 'Case 9: JSON and INT - hash GROUP BY on t_json by two columns through the hash merge returns the groups of the sort GROUP BY';
-- too many groups to print: the query and the comparison below give the number of groups, the sum of COUNT, and the sum
-- of MIN
select count(*), sum(cnt), sum(ca_min)
from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_json group by cb, cc) g;
show trace;

-- compare with the sort GROUP BY: PASS when the two queries return the same rows as a multiset
with
  hash_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ parallel(0) */ min(ca) ca_min, count(*) cnt from t_json group by cb, cc) g),
  sort_rows as (select count(*) as cnt, sum(cnt) as sum_cnt, sum(ca_min) as sum_ca_min from (select /*+ no_hash_aggregate */ min(ca) ca_min, count(*) cnt from t_json group by cb, cc) g)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from hash_rows difference all select * from sort_rows)
    union all
    (select * from sort_rows difference all select * from hash_rows)
  ) diff_result;

-- cleanup
set system parameters 'agg_hash_respect_order=default';

drop table if exists t_int, t_varchar, t_json, t_numeric;

set trace off;
