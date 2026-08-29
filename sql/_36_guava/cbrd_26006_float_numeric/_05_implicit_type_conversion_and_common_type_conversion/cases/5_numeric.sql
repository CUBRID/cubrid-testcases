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
