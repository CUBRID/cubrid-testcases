/* 3. INTEGER implicit conversions */

-- ===========================================================================
-- Section 1: INTEGER conversions
-- ===========================================================================

evaluate '1-1. INT + INT => INT';
SELECT CAST(2 AS INT) + CAST(1 AS INT),
       TYPEOF(CAST(2 AS INT) + CAST(1 AS INT));

evaluate '1-2. INT + BIGINT => BIGINT';
SELECT CAST(2 AS INT) + CAST(1 AS BIGINT),
       TYPEOF(CAST(2 AS INT) + CAST(1 AS BIGINT));

evaluate '1-3. INT + Fixed NUMERIC => Float NUMERIC';
SELECT CAST(2 AS INT) + CAST(1 AS NUMERIC(1)),
       TYPEOF(CAST(2 AS INT) + CAST(1 AS NUMERIC(1)));

evaluate '1-4. INT + Float NUMERIC => Float NUMERIC';
SELECT CAST(2 AS INT) + CAST(1 AS NUMERIC),
       TYPEOF(CAST(2 AS INT) + CAST(1 AS NUMERIC));

evaluate '1-5. INT + FLOAT => FLOAT';
SELECT CAST(2 AS INT) + CAST(2.1 AS FLOAT),
       TYPEOF(CAST(2 AS INT) + CAST(2.1 AS FLOAT));

evaluate '1-6. INT + DOUBLE => DOUBLE';
SELECT CAST(2 AS INT) + CAST(2.1 AS DOUBLE),
       TYPEOF(CAST(2 AS INT) + CAST(2.1 AS DOUBLE));
