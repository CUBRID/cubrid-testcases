/* 1. CHAR/VARCHAR implicit conversions */

-- ===========================================================================
-- Section 1: Character string conversions
-- ===========================================================================

evaluate '1-1. CHAR/VARCHAR + CHAR/VARCHAR => string concatenation';
SELECT CAST('2' AS VARCHAR) + CAST('1' AS VARCHAR),
       TYPEOF(CAST('2' AS VARCHAR) + CAST('1' AS VARCHAR));

SELECT CAST('2' AS CHAR) + CAST('1' AS CHAR),
       TYPEOF(CAST('2' AS CHAR) + CAST('1' AS CHAR));

evaluate '1-2. CHAR/VARCHAR with -, *, / => DOUBLE (implicit conversion)';
SELECT CAST('2' AS CHAR) - CAST('1' AS CHAR),
       TYPEOF(CAST('2' AS CHAR) - CAST('1' AS CHAR));
SELECT CAST('2' AS CHAR) * CAST('1' AS CHAR),
       TYPEOF(CAST('2' AS CHAR) * CAST('1' AS CHAR));
SELECT CAST('2' AS CHAR) / CAST('1' AS CHAR),
       TYPEOF(CAST('2' AS CHAR) / CAST('1' AS CHAR));

SELECT CAST('2' AS VARCHAR) - CAST('1' AS VARCHAR),
       TYPEOF(CAST('2' AS VARCHAR) - CAST('1' AS VARCHAR));
SELECT CAST('2' AS VARCHAR) * CAST('1' AS VARCHAR),
       TYPEOF(CAST('2' AS VARCHAR) * CAST('1' AS VARCHAR));
SELECT CAST('2' AS VARCHAR) / CAST('1' AS VARCHAR),
       TYPEOF(CAST('2' AS VARCHAR) / CAST('1' AS VARCHAR));

evaluate '1-3. VARCHAR + integer types (SHORT/INT/BIGINT) => DOUBLE';
SELECT CAST('1' AS VARCHAR) + CAST(2 AS SHORT),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2 AS SHORT));

SELECT CAST('1' AS VARCHAR) + CAST(2 AS INT),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2 AS INT));

SELECT CAST('1' AS VARCHAR) + CAST(2 AS BIGINT),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2 AS BIGINT));

evaluate '1-4. VARCHAR + Fixed NUMERIC => DOUBLE';
SELECT CAST('1' AS VARCHAR) + CAST(2 AS NUMERIC(1)),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2 AS NUMERIC(1)));

evaluate '1-5. VARCHAR + Float NUMERIC => DOUBLE';
SELECT CAST('1' AS VARCHAR) + CAST(2 AS NUMERIC),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2 AS NUMERIC));

evaluate '1-6. VARCHAR + FLOAT/DOUBLE => DOUBLE';
-- VARCHAR is implicitly converted to DOUBLE (same behavior as Oracle)
SELECT CAST('1' AS VARCHAR) + CAST(2.1 AS FLOAT),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2.1 AS FLOAT));

SELECT CAST('1' AS VARCHAR) + CAST(2.1 AS DOUBLE),
       TYPEOF(CAST('1' AS VARCHAR) + CAST(2.1 AS DOUBLE));
