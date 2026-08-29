/* 4. BIGINT implicit conversions */

-- ===========================================================================
-- Section 1: BIGINT conversions
-- ===========================================================================

evaluate '1-1. BIGINT + BIGINT => BIGINT';
SELECT CAST(2 AS BIGINT) + CAST(1 AS BIGINT),
       TYPEOF(CAST(2 AS BIGINT) + CAST(1 AS BIGINT));

evaluate '1-2. BIGINT + Fixed NUMERIC => Float NUMERIC';
SELECT CAST(2 AS BIGINT) + CAST(1 AS NUMERIC(1)),
       TYPEOF(CAST(2 AS BIGINT) + CAST(1 AS NUMERIC(1)));

evaluate '1-3. BIGINT + Float NUMERIC => Float NUMERIC';
SELECT CAST(2 AS BIGINT) + CAST(1 AS NUMERIC),
       TYPEOF(CAST(2 AS BIGINT) + CAST(1 AS NUMERIC));

evaluate '1-4. BIGINT + FLOAT => FLOAT';
SELECT CAST(2 AS BIGINT) + CAST(1 AS FLOAT),
       TYPEOF(CAST(2 AS BIGINT) + CAST(1 AS FLOAT));

evaluate '1-5. BIGINT + DOUBLE => DOUBLE';
SELECT CAST(2 AS BIGINT) + CAST(1 AS DOUBLE),
       TYPEOF(CAST(2 AS BIGINT) + CAST(1 AS DOUBLE));
