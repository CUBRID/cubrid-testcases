/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  A cached result of a correlated subquery keyed by a NUMERIC or a MONETARY must not answer for one of another scale
 *  (1.0 and 1.00) or currency ($1.00 and \1.00), and one keyed by -0 or -NaN must not answer for 0 or NaN (DOUBLE,
 *  FLOAT, MONETARY): they compare equal and hash alike but print apart. The verification block after each query prints
 *  PASS when the query and its NO_SUBQUERY_CACHE twin return the same rows as a multiset.
 *
 *  Coverage:
 *    Case 1:  NUMERIC and MONETARY - a correlated subquery keyed by one value of two scales or currencies returns the
 *             uncached results
 *    Case 2:  DOUBLE, FLOAT and MONETARY - a correlated subquery keyed by -0 and 0, or by -NaN and NaN, returns the
 *             uncached results
 */

evaluate 'Case 1: NUMERIC and MONETARY - a correlated subquery keyed by one value of two scales or currencies returns the uncached results';
-- d.cb holds each value as its branch of the UNION ALL gives it; the subquery is keyed by d.cb
-- d.ca | d.cb
-- -----+----------------------------
--  221 | 1 as NUMERIC (5, 1): 1.0
--  222 | 1 as NUMERIC (5, 2): 1.00
--  231 | $1.00 (dollar)
--  232 | \1.00 (won)
SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 221 ca, CAST (1 AS NUMERIC (5, 1)) cb FROM db_root
      UNION ALL SELECT 222, CAST (1 AS NUMERIC (5, 2)) FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 221 ca, CAST (1 AS NUMERIC (5, 1)) cb FROM db_root UNION ALL SELECT 222, CAST (1 AS NUMERIC (5, 2)) FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 221 ca, CAST (1 AS NUMERIC (5, 1)) cb FROM db_root UNION ALL SELECT 222, CAST (1 AS NUMERIC (5, 2)) FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 231 ca, $1.00 cb FROM db_root
      UNION ALL SELECT 232, \1.00 FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 231 ca, $1.00 cb FROM db_root UNION ALL SELECT 232, \1.00 FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 231 ca, $1.00 cb FROM db_root UNION ALL SELECT 232, \1.00 FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

evaluate 'Case 2: DOUBLE, FLOAT and MONETARY - a correlated subquery keyed by -0 and 0, or by -NaN and NaN, returns the uncached results';
-- d.ca | d.cb
-- -----+------------------------------------
--  241 | 0 as DOUBLE
--  242 | -0 as DOUBLE
--  251 | 0 as FLOAT
--  252 | -0 as FLOAT
--  271 | NaN as DOUBLE
--  272 | -NaN as DOUBLE
--  261 | $0.00
--  262 | -$0.00
SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 241 ca, CAST (0 AS DOUBLE) cb FROM db_root
      UNION ALL SELECT 242, -CAST (0 AS DOUBLE) FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 241 ca, CAST (0 AS DOUBLE) cb FROM db_root UNION ALL SELECT 242, -CAST (0 AS DOUBLE) FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 241 ca, CAST (0 AS DOUBLE) cb FROM db_root UNION ALL SELECT 242, -CAST (0 AS DOUBLE) FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 251 ca, CAST (0 AS FLOAT) cb FROM db_root
      UNION ALL SELECT 252, -CAST (0 AS FLOAT) FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 251 ca, CAST (0 AS FLOAT) cb FROM db_root UNION ALL SELECT 252, -CAST (0 AS FLOAT) FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 251 ca, CAST (0 AS FLOAT) cb FROM db_root UNION ALL SELECT 252, -CAST (0 AS FLOAT) FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 271 ca, CAST ('nan' AS DOUBLE) cb FROM db_root
      UNION ALL SELECT 272, -CAST ('nan' AS DOUBLE) FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 271 ca, CAST ('nan' AS DOUBLE) cb FROM db_root UNION ALL SELECT 272, -CAST ('nan' AS DOUBLE) FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 271 ca, CAST ('nan' AS DOUBLE) cb FROM db_root UNION ALL SELECT 272, -CAST ('nan' AS DOUBLE) FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;

SELECT d.ca, (SELECT d.cb || '' FROM db_root)
FROM (SELECT 261 ca, $0.00 cb FROM db_root
      UNION ALL SELECT 262, -$0.00 FROM db_root) d
ORDER BY 1;

-- compare with the query without the subquery cache: PASS when the two queries return the same rows as a multiset
with
  cache_rows as (SELECT d.ca AS d_ca, (SELECT d.cb || '' FROM db_root) AS cb_str FROM (SELECT 261 ca, $0.00 cb FROM db_root UNION ALL SELECT 262, -$0.00 FROM db_root) d),
  nocache_rows as (SELECT d.ca AS d_ca, (SELECT /*+ NO_SUBQUERY_CACHE */ d.cb || '' FROM db_root) AS cb_str FROM (SELECT 261 ca, $0.00 cb FROM db_root UNION ALL SELECT 262, -$0.00 FROM db_root) d)
select (case when count (*) = 0 then 'PASS' else 'FAIL' end) as result
  from
  (
    (select * from cache_rows difference all select * from nocache_rows)
    union all
    (select * from nocache_rows difference all select * from cache_rows)
  ) diff_result;
