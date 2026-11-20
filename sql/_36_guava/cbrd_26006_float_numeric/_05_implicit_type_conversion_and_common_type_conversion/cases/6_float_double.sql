/* 6. FLOAT/DOUBLE implicit conversions */

-- ===========================================================================
-- Section 1: FLOAT
-- ===========================================================================

evaluate '1-1. FLOAT + FLOAT => FLOAT';
SELECT CAST(2 AS FLOAT) + CAST(1.1 AS FLOAT),
       TYPEOF(CAST(2 AS FLOAT) + CAST(1.1 AS FLOAT));

evaluate '1-2. FLOAT + DOUBLE => DOUBLE';
SELECT CAST(2 AS FLOAT) + CAST(1.1 AS DOUBLE),
       TYPEOF(CAST(2 AS FLOAT) + CAST(1.1 AS DOUBLE));

-- ===========================================================================
-- Section 2: DOUBLE
-- ===========================================================================

evaluate '2-1. DOUBLE + DOUBLE => DOUBLE';
SELECT CAST(2 AS DOUBLE) + CAST(1.1 AS DOUBLE),
       TYPEOF(CAST(2 AS DOUBLE) + CAST(1.1 AS DOUBLE));

-- ===========================================================================
-- Section 3: precision difference, operators, and overflow
-- ===========================================================================
evaluate '3-1. FLOAT keeps fewer significant digits than DOUBLE';
SELECT CAST(1.12345678901234567 AS FLOAT),
       CAST(1.12345678901234567 AS DOUBLE);

evaluate '3-2. FLOAT and DOUBLE with -, *, / (floating-point division)';
SELECT CAST(1 AS FLOAT) / CAST(3 AS FLOAT),
       TYPEOF(CAST(1 AS FLOAT) / CAST(3 AS FLOAT));
SELECT CAST(1 AS DOUBLE) / CAST(3 AS DOUBLE),
       TYPEOF(CAST(1 AS DOUBLE) / CAST(3 AS DOUBLE));
SELECT CAST(2 AS DOUBLE) - CAST(1.1 AS DOUBLE),
       TYPEOF(CAST(2 AS DOUBLE) - CAST(1.1 AS DOUBLE));

evaluate '3-3. FLOAT and DOUBLE overflow behavior';
SELECT CAST(3.4e38 AS FLOAT) * CAST(10 AS FLOAT);
SELECT CAST(1.7e308 AS DOUBLE) * CAST(10 AS DOUBLE);