/* 1. Verify cases with negative scale and scale > precision */

-- ===========================================================================
-- Section 1: CAST with negative scale / scale > precision
-- ===========================================================================
evaluate '1-1. CAST with negative scale';
SELECT CAST(12345 AS NUMERIC(3,-2));
SELECT CAST(0.001 AS NUMERIC(1,3));
SELECT CAST(0.00123 AS NUMERIC(3,5));
SELECT CAST(0.123 AS NUMERIC(3,3));

evaluate '1-2. Rounding behavior';
SELECT CAST(1254 AS NUMERIC(3,-2));
SELECT CAST(0.001235 AS NUMERIC(3,5));

-- ===========================================================================
-- Section 2: Overflow
-- ===========================================================================
evaluate '2. Overflow behavior (error)';
-- Expect error when the cast result exceeds the target NUMERIC precision
SELECT CAST(1234 AS NUMERIC(1,-2));
SELECT CAST(123456 AS NUMERIC(3,-2));
SELECT CAST(0.012 AS NUMERIC(1,3));
SELECT CAST(1.001 AS NUMERIC(1,3));
SELECT CAST(1.23 AS NUMERIC(3,3));
SELECT CAST(0.0123 AS NUMERIC(3,5));
