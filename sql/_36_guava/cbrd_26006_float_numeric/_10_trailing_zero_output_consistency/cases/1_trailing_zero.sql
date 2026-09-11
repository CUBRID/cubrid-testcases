/*
 * Why trailing zeros matter
 * (e.g., 1, 1.0, 1.000 are numerically equal, but their printed form may differ
 *  depending on execution path such as covering index scan.)
 */

evaluate '1. Trailing zero: UNIQUE constraint behavior (numeric equality)';
/* ------------------------------------------------------------
 * 1. Verify UNIQUE constraint behavior (numeric equality)
 * ------------------------------------------------------------ */
DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (
  col1 NUMERIC PRIMARY KEY
);

INSERT INTO t1 VALUES (1);
evaluate '1-1. Expect: UNIQUE constraint violation (same numeric value)';
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1.000);


evaluate '2. Trailing zero: non-unique table output consistency (covering index scan)';
/* ------------------------------------------------------------
 * 2. Non-unique table: output can differ depending on insert order
 *    when the query is satisfied via a covering index
 * ------------------------------------------------------------ */
DROP TABLE IF EXISTS t1;

CREATE TABLE t1 (
  col1 NUMERIC
);

CREATE INDEX idx_01 ON t1(col1);

evaluate '2-1. Case A: insert 1 -> 1.0 -> 1.000';
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1.000);

evaluate '2-1. Plain select';
SELECT /*+ RECOMPILE */ * FROM t1;

evaluate '2-2. Force non-covering index / fetch base table (to compare output format)';
SELECT /*+ NO_COVERING_IDX RECOMPILE */ *
  FROM t1
 WHERE col1 > 0;

evaluate '2-3. Allow optimizer to use covering index if possible';
SELECT /*+ RECOMPILE */ *
  FROM t1
 WHERE col1 > 0;

-- NOTE: the covering-index plan normalizes trailing zeros -> prints 1, 1, 1
--       (base-table access above keeps the inserted form 1, 1.0, 1.000).


evaluate '2-4. Case B: insert 1.0 -> 1 -> 1.000';
DELETE FROM t1;

INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1.000);

evaluate '2-5. Plain select';
SELECT /*+ RECOMPILE */ *
  FROM t1
 WHERE col1 > 0;


evaluate '2-6. Case C: insert 1.000 -> 1.0 -> 1';
DELETE FROM t1;

INSERT INTO t1 VALUES (1.000);
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1);

evaluate '2-7. Plain select';
SELECT /*+ RECOMPILE */ *
  FROM t1
 WHERE col1 > 0;

DROP TABLE IF EXISTS t1;

evaluate '3. Trailing zero: misc TO_CHAR behavior';
/* ------------------------------------------------------------
 * 3. Misc
 * ------------------------------------------------------------ */

evaluate '3-1. When converted to string, trailing zeros can be preserved/visible';
SELECT
  TO_CHAR(CAST(1.0  AS NUMERIC)) AS a,
  TO_CHAR(CAST(1.00 AS NUMERIC)) AS b,
  (TO_CHAR(CAST(1.0 AS NUMERIC)) = TO_CHAR(CAST(1.00 AS NUMERIC))) AS c;

evaluate '3-2. When concatenated with text, the formatting after trailing zeros matters';
SELECT
  (TO_CHAR(CAST(1.0  AS NUMERIC))  + 'a') AS a,
  (TO_CHAR(CAST(1.00 AS NUMERIC))  + 'a') AS b,
  ((TO_CHAR(CAST(1.0 AS NUMERIC)) + 'a') = (TO_CHAR(CAST(1.00 AS NUMERIC)) + 'a')) AS c;

evaluate '3-3. 1 row';
select 1 from dual where 'abc' = 'abc ';
 
evaluate '3-4. 0 row';
select 1 from dual where cast ('abc' as varchar) = cast ('abc ' as varchar);
DROP TABLE IF EXISTS t1;


evaluate '4. Fixed NUMERIC(p,s): fixed scale always prints the declared decimals';
/* ------------------------------------------------------------
 * 4. A Fixed NUMERIC(p,s) column stores a fixed scale, so 1, 1.0, 1.5
 *    all print with the declared scale (NUMERIC(10,3) -> x.000/x.500).
 *    Unlike the Float NUMERIC of Section 2, a covering-index scan does
 *    NOT strip the trailing zeros -- the fixed scale is part of the type.
 *    (Rows here have distinct values 1.000 vs 1.500, so ORDER BY col1 is
 *     deterministic and the two equal 1.000 rows print identically.)
 * ------------------------------------------------------------ */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 NUMERIC(10,3));
CREATE INDEX idx_01 ON t1(col1);

INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1.5);

evaluate '4-1. Base table access: fixed scale (1.000, 1.000, 1.500)';
SELECT /*+ NO_COVERING_IDX RECOMPILE */ *
  FROM t1
 WHERE col1 > 0
 ORDER BY col1;

evaluate '4-2. Covering index scan: still fixed scale (fixed NUMERIC is not normalized)';
SELECT /*+ RECOMPILE */ col1
  FROM t1
 WHERE col1 > 0
 ORDER BY col1;

DROP TABLE IF EXISTS t1;


evaluate '5. Trailing zero: UNION / DISTINCT / COUNT(DISTINCT) treat equal values as one';
/* ------------------------------------------------------------
 * 5. Numeric equality means 1, 1.0, 1.000 collapse to a single
 *    distinct value under UNION / DISTINCT / COUNT(DISTINCT),
 *    while UNION ALL keeps every row and preserves each printed form.
 * ------------------------------------------------------------ */
evaluate '5-1. UNION collapses trailing-zero variants to one row';
SELECT 1.0 AS v FROM dual
UNION
SELECT 1.000 FROM dual
UNION
SELECT 1 FROM dual;

evaluate '5-2. UNION ALL keeps all rows and preserves each form (ordered by ord)';
SELECT v FROM (
  SELECT 1 AS ord, 1.0   AS v FROM dual
  UNION ALL
  SELECT 2 AS ord, 1.000 AS v FROM dual
  UNION ALL
  SELECT 3 AS ord, 1     AS v FROM dual
) t
ORDER BY ord;

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 NUMERIC);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1.000);

evaluate '5-3. DISTINCT collapses to one value';
SELECT DISTINCT col1 FROM t1;

evaluate '5-4. COUNT(DISTINCT) = 1, COUNT(*) = 3';
SELECT COUNT(DISTINCT col1) AS distinct_cnt, COUNT(*) AS total_cnt FROM t1;

DROP TABLE IF EXISTS t1;


evaluate '6. Trailing zero: GROUP BY key and aggregate output form';
/* ------------------------------------------------------------
 * 6. GROUP BY treats 1, 1.0, 1.000 as one group. Verify the printed
 *    group-key form and the MIN/MAX/SUM/COUNT output (SUM = 3).
 *    One group -> ORDER BY col1 is trivially deterministic.
 * ------------------------------------------------------------ */
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (col1 NUMERIC);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (1.0);
INSERT INTO t1 VALUES (1.000);

evaluate '6-1. GROUP BY: one group, verify key + aggregates';
SELECT col1, COUNT(*) AS cnt, MIN(col1) AS mn, MAX(col1) AS mx, SUM(col1) AS sm
  FROM t1
 GROUP BY col1
 ORDER BY col1;

DROP TABLE IF EXISTS t1;