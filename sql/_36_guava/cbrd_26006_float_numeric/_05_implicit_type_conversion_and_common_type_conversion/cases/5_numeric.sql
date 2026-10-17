/* 5. NUMERIC implicit conversions */

-- ===========================================================================
-- Section 1: Fixed NUMERIC
-- ===========================================================================

evaluate '1-1. Fixed NUMERIC + Fixed NUMERIC => Float NUMERIC';
SELECT CAST(2 AS NUMERIC(1)) + CAST(1.1 AS NUMERIC(2,1)),
       TYPEOF(CAST(2 AS NUMERIC(1)) + CAST(1.1 AS NUMERIC(2,1)));

evaluate '1-2. Fixed NUMERIC + Float NUMERIC => Float NUMERIC';
SELECT CAST(2 AS NUMERIC(1)) + CAST(1.1 AS NUMERIC),
       TYPEOF(CAST(2 AS NUMERIC(1)) + CAST(1.1 AS NUMERIC));

evaluate '1-3. Fixed NUMERIC + FLOAT => DOUBLE';
SELECT CAST(2 AS NUMERIC(1)) + CAST(1.1 AS FLOAT),
       TYPEOF(CAST(2 AS NUMERIC(1)) + CAST(1.1 AS FLOAT));

evaluate '1-4. Fixed NUMERIC + DOUBLE => DOUBLE';
SELECT CAST(2 AS NUMERIC(1)) + CAST(1.1 AS DOUBLE),
       TYPEOF(CAST(2 AS NUMERIC(1)) + CAST(1.1 AS DOUBLE));

-- ===========================================================================
-- Section 2: Float NUMERIC
-- ===========================================================================

evaluate '2-1. Float NUMERIC + Float NUMERIC => Float NUMERIC';
SELECT CAST(2 AS NUMERIC) + CAST(1.1 AS NUMERIC),
       TYPEOF(CAST(2 AS NUMERIC) + CAST(1.1 AS NUMERIC));

evaluate '2-2. Float NUMERIC + FLOAT => DOUBLE';
SELECT CAST(2 AS NUMERIC) + CAST(1.1 AS FLOAT),
       TYPEOF(CAST(2 AS NUMERIC) + CAST(1.1 AS FLOAT));

evaluate '2-3. Float NUMERIC + DOUBLE => DOUBLE';
SELECT CAST(2 AS NUMERIC) + CAST(1.1 AS DOUBLE),
       TYPEOF(CAST(2 AS NUMERIC) + CAST(1.1 AS DOUBLE));

-- ===========================================================================
-- Section 3: precision, operators, and overflow
-- ===========================================================================
evaluate '3-1. high-precision Float NUMERIC + Float NUMERIC preserves full precision';
SELECT CAST(0.12345678901234567890123456789012345678 AS NUMERIC) + CAST(1 AS NUMERIC),
       TYPEOF(CAST(0.12345678901234567890123456789012345678 AS NUMERIC) + CAST(1 AS NUMERIC));

evaluate '3-2. high-precision Float NUMERIC + DOUBLE collapses to DOUBLE (precision loss)';
SELECT CAST(0.12345678901234567890123456789012345678 AS NUMERIC) + CAST(1 AS DOUBLE),
       TYPEOF(CAST(0.12345678901234567890123456789012345678 AS NUMERIC) + CAST(1 AS DOUBLE));

evaluate '3-3. NUMERIC with -, *, / (division is numeric, not integer)';
SELECT CAST(2 AS NUMERIC) - CAST(1 AS NUMERIC),
       TYPEOF(CAST(2 AS NUMERIC) - CAST(1 AS NUMERIC));
SELECT CAST(2 AS NUMERIC) * CAST(3 AS NUMERIC),
       TYPEOF(CAST(2 AS NUMERIC) * CAST(3 AS NUMERIC));
SELECT CAST(1 AS NUMERIC) / CAST(3 AS NUMERIC),
       TYPEOF(CAST(1 AS NUMERIC) / CAST(3 AS NUMERIC));

evaluate '3-4. NUMERIC arithmetic overflow beyond Float NUMERIC range (error)';
-- each operand rounds to 10^128 and the product 10^256 exceeds the Float NUMERIC range
SELECT CAST(99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 AS NUMERIC) * CAST(99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999 AS NUMERIC);