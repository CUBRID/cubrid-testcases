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


evaluate '2. Trailing zero: base-table form (per insert order) vs covering-index normalization';
/* ------------------------------------------------------------
 * 2. Three numerically-equal values (1 = 1.0 = 1.000) are inserted in three
 *    different orders (Case A/B/C). Because the values are equal, ORDER BY col1
 *    cannot make the row order deterministic, so an id column (= insert sequence)
 *    is used with ORDER BY id. Base-table access prints each row's stored scale
 *    in insert order (so Case A/B/C differ), while a covering-index scan on col1
 *    normalizes the trailing zeros to 1, 1, 1 regardless of insert order.
 *    The execution path is proven by the query-plan directive on 2-1 (non-covering)
 *    and 2-2 (index scan marked (covers)).
 * ------------------------------------------------------------ */

-- Case A: insert 1 -> 1.0 -> 1.000
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
  id   INT,
  col1 NUMERIC
);
CREATE INDEX idx_01 ON t1(col1);

INSERT INTO t1 VALUES (1, 1);
INSERT INTO t1 VALUES (2, 1.0);
INSERT INTO t1 VALUES (3, 1.000);

evaluate '2-1. Case A base-table access: stored form in insert order (1, 1.0, 1.000)';
--@queryplan
SELECT /*+ NO_COVERING_IDX RECOMPILE */ id, col1
  FROM t1
 WHERE col1 > 0
 ORDER BY id;

evaluate '2-2. Case A covering index scan on col1: normalized (1, 1, 1)';
--@queryplan
SELECT /*+ RECOMPILE */ col1
  FROM t1
 WHERE col1 > 0
 ORDER BY col1;

-- Case B: insert 1.0 -> 1 -> 1.000
DELETE FROM t1;
INSERT INTO t1 VALUES (1, 1.0);
INSERT INTO t1 VALUES (2, 1);
INSERT INTO t1 VALUES (3, 1.000);

evaluate '2-3. Case B base-table access: stored form in insert order (1.0, 1, 1.000)';
SELECT /*+ NO_COVERING_IDX RECOMPILE */ id, col1
  FROM t1
 WHERE col1 > 0
 ORDER BY id;

evaluate '2-4. Case B covering index scan: normalized (1, 1, 1) regardless of insert order';
SELECT /*+ RECOMPILE */ col1
  FROM t1
 WHERE col1 > 0
 ORDER BY col1;

-- Case C: insert 1.000 -> 1.0 -> 1
DELETE FROM t1;
INSERT INTO t1 VALUES (1, 1.000);
INSERT INTO t1 VALUES (2, 1.0);
INSERT INTO t1 VALUES (3, 1);

evaluate '2-5. Case C base-table access: stored form in insert order (1.000, 1.0, 1)';
SELECT /*+ NO_COVERING_IDX RECOMPILE */ id, col1
  FROM t1
 WHERE col1 > 0
 ORDER BY id;

evaluate '2-6. Case C covering index scan: normalized (1, 1, 1) regardless of insert order';
SELECT /*+ RECOMPILE */ col1
  FROM t1
 WHERE col1 > 0
 ORDER BY col1;

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
--@queryplan
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

evaluate '5-5. UNION negative control: equal scales merge but a different value survives';
-- 2.0 and 2.00000 are equal (collapse to one), 2.01 differs and must remain -> two rows
SELECT 2.0 AS v FROM dual
UNION
SELECT 2.00000 FROM dual
UNION
SELECT 2.01 FROM dual
ORDER BY v;

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

/* ------------------------------------------------------------
 * 6-2/6-3. Multiple values with negative controls: equal-value
 *   different-scale rows merge into one group, while a genuinely
 *   different value (2.01) and the opposite sign (-2) stay separate.
 *   The id column lets SUM(id) show which rows fell into each group.
 * ------------------------------------------------------------ */
DROP TABLE IF EXISTS t2;
CREATE TABLE t2 (id INT, col1 NUMERIC);
INSERT INTO t2 VALUES (1, 2);
INSERT INTO t2 VALUES (2, 2.0);
INSERT INTO t2 VALUES (3, 2.00000);
INSERT INTO t2 VALUES (4, 2.0000000000);
INSERT INTO t2 VALUES (5, 2.01);
INSERT INTO t2 VALUES (6, -2.0);
INSERT INTO t2 VALUES (7, -2.00000);

evaluate '6-2. GROUP BY multiple values: equal scales merge, different value and sign stay separate';
-- Expect: three groups -> -2 (count 2), 2 (count 4), 2.01 (count 1)
SELECT col1, COUNT(*) AS cnt FROM t2 GROUP BY col1 ORDER BY col1;

evaluate '6-3. DISTINCT and HAVING over the value-merged groups';
-- Expect: 3 distinct values -> -2, 2, 2.01
SELECT DISTINCT col1 FROM t2 ORDER BY col1;
-- Expect: groups with more than one row -> -2 (sum id 13, count 2), 2 (sum id 10, count 4)
SELECT col1, SUM(id) AS sid, COUNT(*) AS cnt
  FROM t2
 GROUP BY col1
HAVING COUNT(*) > 1
 ORDER BY col1;

DROP TABLE IF EXISTS t2;