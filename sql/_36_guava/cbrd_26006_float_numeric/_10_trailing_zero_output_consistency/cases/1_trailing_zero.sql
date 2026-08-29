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