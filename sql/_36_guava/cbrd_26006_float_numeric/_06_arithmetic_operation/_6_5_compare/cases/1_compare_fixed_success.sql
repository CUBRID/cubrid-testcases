/* 1. COMPARE Fixed NUMERIC success */

-- ===========================================================================
-- Section 1: NUMERIC(38,0)
-- ===========================================================================

evaluate '1. COMPARE Fixed NUMERIC(38,0): boundary comparisons';
DROP TABLE IF EXISTS t_cmp_succ;
DROP TABLE IF EXISTS t_cmp_null_succ;
CREATE TABLE t_cmp_succ (
  id INT,
  actual INT,
  expected INT
);

-- 2 > 1  => TRUE
INSERT INTO t_cmp_succ
SELECT 1,
       CASE WHEN CAST(2 AS NUMERIC(38,0)) > CAST(1 AS NUMERIC(38,0)) THEN 1 ELSE 0 END,
       1;

-- 2 = 2  => TRUE
INSERT INTO t_cmp_succ
SELECT 2,
       CASE WHEN CAST(2 AS NUMERIC(38,0)) = CAST(2 AS NUMERIC(38,0)) THEN 1 ELSE 0 END,
       1;

-- -1 < 1 => TRUE
INSERT INTO t_cmp_succ
SELECT 3,
       CASE WHEN CAST(-1 AS NUMERIC(38,0)) < CAST(1 AS NUMERIC(38,0)) THEN 1 ELSE 0 END,
       1;


-- ===========================================================================
-- Section 2: NUMERIC(38,-84)
-- ===========================================================================

evaluate '2. COMPARE Fixed NUMERIC(38,-84): negative scale boundary';

-- MAX > 0 => TRUE
INSERT INTO t_cmp_succ
SELECT 4,
       CASE WHEN
         CAST(99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS NUMERIC(38,-84))
         >
         CAST(0 AS NUMERIC(38,-84))
       THEN 1 ELSE 0 END,
       1;

-- (-MAX) < 0 => TRUE
INSERT INTO t_cmp_succ
SELECT 5,
       CASE WHEN
         CAST(-99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS NUMERIC(38,-84))
         <
         CAST(0 AS NUMERIC(38,-84))
       THEN 1 ELSE 0 END,
       1;


-- ===========================================================================
-- Section 3: NUMERIC(38,127)
-- ===========================================================================

evaluate '3. COMPARE Fixed NUMERIC(38,127): positive scale boundary';

-- MAX_FRAC > 0 => TRUE
INSERT INTO t_cmp_succ
SELECT 6,
       CASE WHEN
         CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
         >
         CAST(0 AS NUMERIC(38,127))
       THEN 1 ELSE 0 END,
       1;

-- (-MAX_FRAC) < 0 => TRUE
INSERT INTO t_cmp_succ
SELECT 7,
       CASE WHEN
         CAST(-0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
         <
         CAST(0 AS NUMERIC(38,127))
       THEN 1 ELSE 0 END,
       1;

-- Equality: X = X => TRUE
INSERT INTO t_cmp_succ
SELECT 8,
       CASE WHEN
         CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
         =
         CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
       THEN 1 ELSE 0 END,
       1;

SELECT id, actual, expected,
       CASE WHEN actual = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_cmp_succ
ORDER BY id;


-- ===========================================================================
-- Section 4: NULL comparison semantics (minimal)
-- ===========================================================================

evaluate '4. COMPARE Fixed NUMERIC: NULL comparison semantics';

CREATE TABLE t_cmp_null_succ (
  id INT,
  actual_cnt INT,
  expected_cnt INT
);

-- NULL = 1 -> UNKNOWN -> filtered out -> 0 rows
INSERT INTO t_cmp_null_succ
SELECT 1,
       (SELECT COUNT(*) FROM db_root
         WHERE CAST(NULL AS NUMERIC(38,0)) = CAST(1 AS NUMERIC(38,0))),
       0;

-- NULL IS NULL -> TRUE -> 1 row
INSERT INTO t_cmp_null_succ
SELECT 2,
       (SELECT COUNT(*) FROM db_root
         WHERE CAST(NULL AS NUMERIC(38,0)) IS NULL),
       1;

SELECT id, actual_cnt, expected_cnt,
       CASE WHEN actual_cnt = expected_cnt THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_cmp_null_succ
ORDER BY id;

DROP TABLE IF EXISTS t_cmp_null_succ;
DROP TABLE IF EXISTS t_cmp_succ;
