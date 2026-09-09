/* 4. Verify UNION / UNION ALL behavior */

-- ===========================================================================
-- Section 1: Simple UNION vs UNION ALL
-- ===========================================================================
evaluate '1-1. Simple UNION vs UNION ALL (dedup)';
-- UNION removes duplicates and applies sorting
SELECT 2222 AS a
UNION
SELECT 2222.0 AS a
UNION
SELECT 222.2 AS a;

evaluate '1-2. Simple UNION vs UNION ALL (all)';
-- UNION ALL returns all rows as-is
SELECT 2222 AS b
UNION ALL
SELECT 2222.0 AS b
UNION ALL
SELECT 222.2 AS b;

-- ===========================================================================
-- Section 2: UNION with large magnitude literals
-- ===========================================================================
evaluate '2-1. UNION between 254-digit integer literal and 252-digit fractional literal';
SELECT
  10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS c
UNION
SELECT
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 AS c;

evaluate '2-2. UNION between 255-digit integer literal and 19-digit fractional literal (error)';
-- Expect error when a 255-digit integer literal exceeds the Float NUMERIC range
SELECT
  (110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000) AS d
UNION
SELECT 1000000000000000000 AS d;

evaluate '2-3. UNION between 255-digit fractional literal and 19-digit integer literal';
-- Fractional literal is truncated at display limit, so UNION succeeds unlike 4-4
SELECT
  (0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001) AS e
UNION
SELECT 1000000000000000000 AS e;

-- ===========================================================================
-- Section 3: dedup equivalence across Float NUMERIC representations
-- ===========================================================================
evaluate '3-1. dedup collapses trailing-zero-only differences';
-- 1.5, 1.50, 1.500 are the same Float NUMERIC value
SELECT 1.5 AS a
UNION
SELECT 1.50 AS a
UNION
SELECT 1.500 AS a;

evaluate '3-2. dedup collapses values equal after 40-significant-digit rounding';
-- both operands have 41 significant digits and round to the same 40-digit value
SELECT 1.0000000000000000000000000000000000000001 AS a
UNION
SELECT 1.0000000000000000000000000000000000000002 AS a;

-- ===========================================================================
-- Section 4: sorting across the full signed Float NUMERIC range
-- ===========================================================================
evaluate '4. UNION sorts negative, tiny, and huge magnitudes in order';
SELECT -1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS a
UNION
SELECT 0 AS a
UNION
SELECT 0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 AS a
UNION
SELECT 1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS a;

-- ===========================================================================
-- Section 5: NULL handling in UNION
-- ===========================================================================
evaluate '5-1. UNION with NULL, duplicate NULLs are dedup and NULL sorts first';
SELECT 99999999999999999999999999999999999999 AS a
UNION
SELECT NULL AS a
UNION
SELECT NULL AS a;

evaluate '5-2. UNION ALL keeps duplicate NULLs';
SELECT 99999999999999999999999999999999999999 AS a
UNION ALL
SELECT NULL AS a
UNION ALL
SELECT NULL AS a;

-- ===========================================================================
-- Section 6: INTERSECT and DIFFERENCE with Float NUMERIC
-- ===========================================================================
evaluate '6-1. INTERSECT matches equal values written differently';
-- 2222 and 2222.0 are equal, so the intersection keeps 2222
(SELECT 2222 AS a UNION ALL SELECT 222.2 AS a)
INTERSECT
SELECT 2222.0 AS a;

evaluate '6-2. DIFFERENCE removes equal values written differently';
-- 2222.0 removes 2222 from the left side, leaving 222.2
(SELECT 2222 AS a UNION ALL SELECT 222.2 AS a)
DIFFERENCE
SELECT 2222.0 AS a;

-- ===========================================================================
-- Section 7: PREPARE with UNION
-- ===========================================================================
evaluate '7. prepare statement with union';
PREPARE st FROM 'SELECT ? as f UNION SELECT ? as f';
EXECUTE st USING 1234567890, 1234567891;

-- After Float NUMERIC was introduced, large-precision bindings are also displayed correctly
EXECUTE st USING
  99999999999999999999999999999999999999,
  0.99999999999999999999999999999999999999;
