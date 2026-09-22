/* 2. COMPARE Fixed NUMERIC failure */

-- ===========================================================================
-- Section 1: invalid coercion
-- ===========================================================================

evaluate '1. COMPARE Fixed NUMERIC: invalid coercion (string -> fixed numeric) (error)';

-- non-numeric string to fixed numeric (expect error)
SELECT CAST('not_a_number' AS NUMERIC(38,0)) = CAST(1 AS NUMERIC(38,0));

-- non-numeric string to scaled fixed numeric (expect error)
SELECT CAST('x' AS NUMERIC(38,127)) < CAST(0 AS NUMERIC(38,127));


-- ===========================================================================
-- Section 2: out-of-range cast
-- ===========================================================================

evaluate '2. COMPARE Fixed NUMERIC: out-of-range cast during comparison (error)';

-- numeric(39) is out of fixed range (expect error)
SELECT CAST(999999999999999999999999999999999999999 AS NUMERIC(38,0)) = 0;

-- (38,-85) scale below min for fixed numeric (expect error)
SELECT CAST(1 AS NUMERIC(38,-85)) = 0;

-- (38,128) scale above max for fixed numeric (expect error)
SELECT CAST(1 AS NUMERIC(38,128)) = 0;


-- ===========================================================================
-- Section 3: overflow inside comparison
-- ===========================================================================

evaluate '3. COMPARE Fixed NUMERIC: overflow inside comparison expression (error)';

-- (MAX + 1) forced into NUMERIC(38,0) inside comparison -> overflow
SELECT
  CASE
    WHEN CAST(
      CAST(99999999999999999999999999999999999999 AS NUMERIC(38,0)) + CAST(1 AS NUMERIC(38,0))
    AS NUMERIC(38,0)) > 0
    THEN 1 ELSE 0
  END;

-- (MAX_FRAC + MAX_FRAC) forced into NUMERIC(38,127) inside comparison -> overflow
SELECT
  CASE
    WHEN CAST(
      CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
      +
      CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
    AS NUMERIC(38,127)) = 0
    THEN 1 ELSE 0
  END;


-- ===========================================================================
-- Section 4: division by zero
-- ===========================================================================

evaluate '4. COMPARE Fixed NUMERIC: division by zero inside comparison (error)';

-- (1/0) inside comparison (expect error)
SELECT (CAST(1 AS NUMERIC(38,0)) / CAST(0 AS NUMERIC(38,0))) = 0;

-- (0/0) inside comparison (expect error)
SELECT (CAST(0 AS NUMERIC(38,0)) / CAST(0 AS NUMERIC(38,0))) = 0;
