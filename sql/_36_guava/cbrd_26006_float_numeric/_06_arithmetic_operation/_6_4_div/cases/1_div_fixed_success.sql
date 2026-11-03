/* 1. DIV Fixed NUMERIC success */

-- ===========================================================================
-- Section 1: NUMERIC(38,0)
-- ===========================================================================

evaluate '1. DIV Fixed NUMERIC(38,0): boundary divide, zero dividend';

DROP TABLE IF EXISTS t_div_succ_38_0;
DROP TABLE IF EXISTS t_div_succ_38_m84;
DROP TABLE IF EXISTS t_div_succ_38_127;
DROP TABLE IF EXISTS t_div_null_succ;
CREATE TABLE t_div_succ_38_0 (
  id INT,
  a  NUMERIC(38,0),
  b  NUMERIC(38,0),
  -- expected is Float NUMERIC: the operation promotes to Float and may exceed 38 digits
  expected NUMERIC
);

-- MAX / 1 = MAX
INSERT INTO t_div_succ_38_0 VALUES
  (1,
   99999999999999999999999999999999999999,
   1,
   99999999999999999999999999999999999999);

-- 0 / MAX = 0
INSERT INTO t_div_succ_38_0 VALUES
  (2,
   0,
   99999999999999999999999999999999999999,
   0);

-- (-MAX) / 1 = -MAX
INSERT INTO t_div_succ_38_0 VALUES
  (3,
   -99999999999999999999999999999999999999,
   1,
   -99999999999999999999999999999999999999);

-- 1 / 3 = 0.(40 threes): Fixed(38,0) / Fixed(38,0) promotes to a 40-significant-digit
-- Float quotient (a fixed(38,0) result would truncate the fractional part)
INSERT INTO t_div_succ_38_0 VALUES
  (4,
   1,
   3,
   0.3333333333333333333333333333333333333333);

SELECT id, a, b, a / b AS actual, expected,
       TYPEOF(a) AS a_type, TYPEOF(a / b) AS result_type,
       CASE WHEN a / b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_div_succ_38_0
ORDER BY id;

evaluate '1-rt. Round-trip: store the quotient into a Fixed(38,0) column (integer id 1-3 lossless, fractional id 4 truncates)';
-- Same shape as t_div_succ_38_0, but expected is Fixed NUMERIC(38,0) and is populated by
-- storing a / b into it (Float result -> Fixed(38,0) conversion). For a fitting result the
-- stored value equals the recomputed a / b, so PASS means the round-trip is lossless.
-- Below, id 4 (the fractional quotient) is also stored, to show it truncates rather than overflowing.
DROP TABLE IF EXISTS t_div_rt_38_0;
CREATE TABLE t_div_rt_38_0 (
  id INT,
  a  NUMERIC(38,0),
  b  NUMERIC(38,0),
  expected NUMERIC(38,0)
);
INSERT INTO t_div_rt_38_0
SELECT id, a, b, a / b FROM t_div_succ_38_0 WHERE id <= 3;

SELECT id, a, b, a / b AS actual, expected,
       TYPEOF(a) AS a_type, TYPEOF(a / b) AS result_type,
       CASE WHEN a / b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_div_rt_38_0
ORDER BY id;

-- id 4: the fractional quotient (1 / 3) does NOT overflow -- it truncates to 0 when stored
-- into Fixed(38,0). So a / b (Float 0.333...) differs from the stored value (precision loss).
INSERT INTO t_div_rt_38_0
SELECT id, a, b, a / b FROM t_div_succ_38_0 WHERE id = 4;

SELECT id, a, b, a / b AS float_quotient, expected AS stored_fixed,
       CASE WHEN a / b = expected THEN 'no loss' ELSE 'truncated (precision lost)' END AS effect
FROM t_div_rt_38_0
WHERE id = 4
ORDER BY id;
DROP TABLE IF EXISTS t_div_rt_38_0;


-- ===========================================================================
-- Section 2: NUMERIC(38,-84)
-- ===========================================================================

evaluate '2. DIV Fixed NUMERIC(38,-84): coercion to 0, zero dividend';

CREATE TABLE t_div_succ_38_m84 (
  id INT,
  a  NUMERIC(38,-84),
  b  NUMERIC(38,-84),
  expected NUMERIC(38,-84)
);

-- 1 / MAX = 0
-- (1 -> 0), 0 / (38,-84) = 0
INSERT INTO t_div_succ_38_m84 VALUES
  (1,
   1,
   99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
   0);

-- 0 / MAX = 0
INSERT INTO t_div_succ_38_m84 VALUES
  (2,
   0,
   99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
   0);

SELECT id, a, b, a / b AS actual, expected,
       CASE WHEN a / b = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_div_succ_38_m84
ORDER BY id;


-- ===========================================================================
-- Section 3: NUMERIC(38,127)
-- ===========================================================================

evaluate '3. DIV Fixed NUMERIC(38,127): positive scale boundary';

CREATE TABLE t_div_succ_38_127 (
  id INT,
  a  NUMERIC(38,127),
  b  NUMERIC(38,127),
  expected NUMERIC
);

-- MAX_FRAC / 1 = MAX_FRAC
INSERT INTO t_div_succ_38_127 VALUES
  (1,
   0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999,
   0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001,
   9.999999999999999999999999999999999999900);

-- 0 / MAX_FRAC = 0
INSERT INTO t_div_succ_38_127 VALUES
  (2,
   0,
   0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999,
   0);

SELECT id, a, b, cast(a / b as numeric) AS actual, expected,
       CASE WHEN cast(a / b as numeric) = expected THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_div_succ_38_127
ORDER BY id;


-- ===========================================================================
-- Section 4: NULL
-- ===========================================================================

evaluate '4. DIV Fixed NUMERIC: NULL propagation';

CREATE TABLE t_div_null_succ (
  id INT,
  actual NUMERIC(38,0),
  expected_is_null INT
);

-- 1 / NULL -> NULL  (no error)
INSERT INTO t_div_null_succ
SELECT 1,
       CAST(1 AS NUMERIC(38,0)) / CAST(NULL AS NUMERIC(38,0)),
       1;

-- NULL / 2 -> NULL  (no error)
INSERT INTO t_div_null_succ
SELECT 2,
       CAST(NULL AS NUMERIC(38,0)) / CAST(2 AS NUMERIC(38,0)),
       1;

SELECT id,
       CASE WHEN actual IS NULL THEN 1 ELSE 0 END AS actual_is_null,
       expected_is_null,
       CASE WHEN (CASE WHEN actual IS NULL THEN 1 ELSE 0 END) = expected_is_null THEN 'PASS' ELSE 'FAIL' END AS result
FROM t_div_null_succ
ORDER BY id;

DROP TABLE IF EXISTS t_div_null_succ;
DROP TABLE IF EXISTS t_div_succ_38_0;
DROP TABLE IF EXISTS t_div_succ_38_m84;
DROP TABLE IF EXISTS t_div_succ_38_127;
