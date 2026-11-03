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

evaluate '1-7. INT + high-precision Float NUMERIC preserves full precision';
-- integer + Float NUMERIC stays NUMERIC (not DOUBLE), so all 38 digits survive
SELECT CAST(1 AS INT) + CAST(0.12345678901234567890123456789012345678 AS NUMERIC),
       TYPEOF(CAST(1 AS INT) + CAST(0.12345678901234567890123456789012345678 AS NUMERIC));

evaluate '1-8. INT with -, *, / and NUMERIC, and INT / INT integer division';
SELECT CAST(2 AS INT) - CAST(1 AS NUMERIC),
       TYPEOF(CAST(2 AS INT) - CAST(1 AS NUMERIC));
SELECT CAST(2 AS INT) * CAST(3 AS NUMERIC),
       TYPEOF(CAST(2 AS INT) * CAST(3 AS NUMERIC));
SELECT CAST(1 AS INT) / CAST(3 AS NUMERIC),
       TYPEOF(CAST(1 AS INT) / CAST(3 AS NUMERIC));
SELECT CAST(1 AS INT) / CAST(3 AS INT),
       TYPEOF(CAST(1 AS INT) / CAST(3 AS INT));

evaluate '1-9. INT + INT overflow behavior';
SELECT CAST(2147483647 AS INT) + CAST(1 AS INT),
       TYPEOF(CAST(2147483647 AS INT) + CAST(1 AS INT));
