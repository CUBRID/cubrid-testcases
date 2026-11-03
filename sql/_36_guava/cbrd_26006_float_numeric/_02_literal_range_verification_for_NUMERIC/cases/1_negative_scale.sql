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

evaluate '1-3. Negative operands (sign preserved, round half away from zero)';
SELECT CAST(-12345 AS NUMERIC(3,-2));
SELECT CAST(-1254 AS NUMERIC(3,-2));
SELECT CAST(-0.001235 AS NUMERIC(3,5));
SELECT CAST(-0.123 AS NUMERIC(3,3));

evaluate '1-4. Half-way tie rounds up (round half away from zero)';
-- exact .5 tie, half-even rounding would instead pick the even neighbor
SELECT CAST(12250 AS NUMERIC(3,-2));
SELECT CAST(0.001225 AS NUMERIC(3,5));

evaluate '1-5. Rounding down to zero and tie at the zero boundary';
SELECT CAST(49 AS NUMERIC(1,-2));
SELECT CAST(50 AS NUMERIC(1,-2));
SELECT CAST(-50 AS NUMERIC(1,-2));

evaluate '1-6. Rounding carry just below the precision boundary succeeds';
-- one unit below the values that overflow via rounding carry in 2-2
SELECT CAST(99949 AS NUMERIC(3,-2));
SELECT CAST(0.0094 AS NUMERIC(1,3));
SELECT CAST(0.009994 AS NUMERIC(3,5));

-- ===========================================================================
-- Section 2: Overflow
-- ===========================================================================
evaluate '2-1. Overflow behavior (error)';
-- Expect error when the cast result exceeds the target NUMERIC precision
SELECT CAST(1234 AS NUMERIC(1,-2));
SELECT CAST(123456 AS NUMERIC(3,-2));
SELECT CAST(0.012 AS NUMERIC(1,3));
SELECT CAST(1.001 AS NUMERIC(1,3));
SELECT CAST(1.23 AS NUMERIC(3,3));
SELECT CAST(0.0123 AS NUMERIC(3,5));

evaluate '2-2. Overflow caused by rounding carry (error)';
-- value is within range but the rounding carry pushes the digit count past the precision
SELECT CAST(99950 AS NUMERIC(3,-2));
SELECT CAST(0.0095 AS NUMERIC(1,3));
SELECT CAST(0.009995 AS NUMERIC(3,5));
