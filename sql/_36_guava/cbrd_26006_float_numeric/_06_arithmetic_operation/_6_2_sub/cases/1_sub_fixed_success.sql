/* 1. SUB Fixed NUMERIC success */

-- ===========================================================================
-- Section 1: NUMERIC(38,0)
-- ===========================================================================

evaluate '1. SUB Fixed NUMERIC(38,0): boundary sub, cancellation, sign-mix';

DROP TABLE IF EXISTS t_sub_succ_38_0;
DROP TABLE IF EXISTS t_sub_succ_38_m84;
DROP TABLE IF EXISTS t_sub_succ_38_127;
DROP TABLE IF EXISTS t_sub_null_succ;
CREATE TABLE t_sub_succ_38_0 (
  id INT,
  a  NUMERIC(38,0),
  b  NUMERIC(38,0),
  expected NUMERIC(38,0)
);

-- MAX - 1 = MAX-1
INSERT INTO t_sub_succ_38_0 VALUES
  (1,
   99999999999999999999999999999999999999,
   1,
   99999999999999999999999999999999999998);

-- (-MAX) - (-1) = -(MAX-1)
INSERT INTO t_sub_succ_38_0 VALUES
  (2,
   -99999999999999999999999999999999999999,
   -1,
   -99999999999999999999999999999999999998);

-- Cancellation: MAX - MAX = 0
INSERT INTO t_sub_succ_38_0 VALUES
  (3,
   99999999999999999999999999999999999999,
   99999999999999999999999999999999999999,
   0);

SELECT id, a, b, a - b AS actual, expected,
       CASE WHEN a - b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_sub_succ_38_0
ORDER BY id;


-- ===========================================================================
-- Section 2: NUMERIC(38,-84)
-- ===========================================================================

evaluate '2. SUB Fixed NUMERIC(38,-84): negative scale boundary';

DROP TABLE IF EXISTS t_sub_succ_38_m84;
CREATE TABLE t_sub_succ_38_m84 (
  id INT,
  a  NUMERIC(38,-84),
  b  NUMERIC(38,-84),
  expected NUMERIC(38,-84)
);

-- MAX - 0 = MAX
INSERT INTO t_sub_succ_38_m84 VALUES
(
  1,
  99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  0,
  99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000
);

-- MAX - MAX = 0
INSERT INTO t_sub_succ_38_m84 VALUES
(
  2,
  99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  0
);

SELECT id, a, b, a - b AS actual, expected,
       CASE WHEN a - b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_sub_succ_38_m84
ORDER BY id;


-- ===========================================================================
-- Section 3: NUMERIC(38,127)
-- ===========================================================================

evaluate '3. SUB Fixed NUMERIC(38,127): positive scale boundary';

DROP TABLE IF EXISTS t_sub_succ_38_127;
CREATE TABLE t_sub_succ_38_127 (
  id INT,
  a  NUMERIC(38,127),
  b  NUMERIC(38,127),
  expected NUMERIC(38,127)
);

-- MAX_FRAC - 0 = MAX_FRAC
INSERT INTO t_sub_succ_38_127 VALUES
(
  1,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999,
  0,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999
);

-- MAX_FRAC - MAX_FRAC = 0
INSERT INTO t_sub_succ_38_127 VALUES
(
  2,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999,
  0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999,
  0
);

SELECT id, a, b, a - b AS actual, expected,
       CASE WHEN a - b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_sub_succ_38_127
ORDER BY id;


-- ===========================================================================
-- Section 4: NULL propagation (minimal)
-- ===========================================================================

evaluate '4. SUB Fixed NUMERIC: NULL propagation';

DROP TABLE IF EXISTS t_sub_null_succ;
CREATE TABLE t_sub_null_succ (
  id INT,
  actual NUMERIC(38,0),
  expected_is_null INT
);

-- 1 - NULL -> NULL
INSERT INTO t_sub_null_succ
SELECT 1,
       CAST(1 AS NUMERIC(38,0)) - CAST(NULL AS NUMERIC(38,0)),
       1;

-- NULL - 2 -> NULL
INSERT INTO t_sub_null_succ
SELECT 2,
       CAST(NULL AS NUMERIC(38,0)) - CAST(2 AS NUMERIC(38,0)),
       1;

SELECT id,
       CASE WHEN actual IS NULL THEN 1 ELSE 0 END AS actual_is_null,
       expected_is_null,
       CASE WHEN (CASE WHEN actual IS NULL THEN 1 ELSE 0 END) = expected_is_null THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_sub_null_succ
ORDER BY id;

DROP TABLE IF EXISTS t_sub_null_succ;
DROP TABLE IF EXISTS t_sub_succ_38_0;
DROP TABLE IF EXISTS t_sub_succ_38_m84;
DROP TABLE IF EXISTS t_sub_succ_38_127;
