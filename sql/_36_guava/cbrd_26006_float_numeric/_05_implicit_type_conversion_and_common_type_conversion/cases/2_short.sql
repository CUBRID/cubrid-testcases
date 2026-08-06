/* 2. SHORT implicit conversions */

-- ===========================================================================
-- Section 1: SHORT conversions
-- ===========================================================================

evaluate '1-1. SHORT + SHORT => SHORT';
SELECT CAST(2 AS SHORT) + CAST(1 AS SHORT),
       TYPEOF(CAST(2 AS SHORT) + CAST(1 AS SHORT));

evaluate '1-2. SHORT + INT => INT';
SELECT CAST(2 AS SHORT) + CAST(1 AS INT),
       TYPEOF(CAST(2 AS SHORT) + CAST(1 AS INT));

evaluate '1-3. SHORT + BIGINT => BIGINT';
SELECT CAST(2 AS SHORT) + CAST(1 AS BIGINT),
       TYPEOF(CAST(2 AS SHORT) + CAST(1 AS BIGINT));

evaluate '1-4. SHORT + Fixed NUMERIC => Float NUMERIC';
SELECT CAST(2 AS SHORT) + CAST(1 AS NUMERIC(1)),
       TYPEOF(CAST(2 AS SHORT) + CAST(1 AS NUMERIC(1)));

evaluate '1-5. SHORT + Float NUMERIC => Float NUMERIC';
SELECT CAST(2 AS SHORT) + CAST(1 AS NUMERIC),
       TYPEOF(CAST(2 AS SHORT) + CAST(1 AS NUMERIC));

evaluate '1-6. SHORT + FLOAT => FLOAT';
SELECT CAST(2 AS SHORT) + CAST(2.1 AS FLOAT),
       TYPEOF(CAST(2 AS SHORT) + CAST(2.1 AS FLOAT));

evaluate '1-7. SHORT + DOUBLE => DOUBLE';
SELECT CAST(2 AS SHORT) + CAST(2.1 AS DOUBLE),
       TYPEOF(CAST(2 AS SHORT) + CAST(2.1 AS DOUBLE));
