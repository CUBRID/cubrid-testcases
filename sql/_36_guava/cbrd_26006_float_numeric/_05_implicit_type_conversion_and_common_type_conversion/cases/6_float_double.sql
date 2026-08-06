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
