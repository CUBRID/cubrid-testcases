/* 1. Verify CAST behavior */

evaluate '1. Large magnitude';
-- ------------------------------------------------------------
-- Large magnitude: exponent literal parses as DOUBLE, then casts to NUMERIC
-- ------------------------------------------------------------
-- The e+213 literal is parsed as DOUBLE, so the 40-nine mantissa is rounded to 1.0E253
-- (the 40 nines are NOT preserved). CAST AS NUMERIC then stores 10^253 (negative scale).
SELECT  9999999999999999999999999999999999999999e+213,
        CAST(9999999999999999999999999999999999999999e+213 AS NUMERIC);

SELECT -9999999999999999999999999999999999999999e+213,
        CAST(-9999999999999999999999999999999999999999e+213 AS NUMERIC);

-- 1e+253 should still fit (edge of range)
SELECT  1e+253, CAST(1e+253 AS NUMERIC);
SELECT -1e+253, CAST(-1e+253 AS NUMERIC);

evaluate '2. Small magnitude';
-- ------------------------------------------------------------
-- Small magnitude: positive scale
-- ------------------------------------------------------------
SELECT CAST(1e-40 AS NUMERIC);
SELECT 12345678901234567890e-40, CAST(12345678901234567890e-40 AS NUMERIC);

SELECT 1.234e-41, CAST(1.234e-41 AS NUMERIC);
-- The 20-digit mantissa cannot survive DOUBLE (guarantees only 15 sig digits), so the
-- literal is truncated at parsing and NUMERIC keeps just what DOUBLE gave it.
-- To preserve all digits, use a bare decimal literal (no e-notation) instead.
SELECT 12345678901234567890e-41, CAST(12345678901234567890e-41 AS NUMERIC);

-- NOTE:
-- Some values are printed in scientific notation as DOUBLE, which may mislead scale intuition.
-- Example: the engine may parse as DOUBLE first, then cast to NUMERIC.
-- Reading E notation: aEb means a x 10^b (negative b = tiny number).
-- Below, 40 nines x 10^-213 is about 10^-173, but DOUBLE guarantees only 15 significant digits,
-- so the 40-nine mantissa rounds up to 10 and the result prints as 1.0E-173 (mantissa 1.0, not 9.99...).
SELECT 9999999999999999999999999999999999999999e-213,
       CAST(9999999999999999999999999999999999999999e-213 AS NUMERIC);

-- Boundary: 1e-252 is still representable
SELECT 1e-252, CAST(1e-252 AS NUMERIC);

evaluate '3. Underflow-to-zero at NUMERIC cast';
-- ------------------------------------------------------------
-- Underflow to zero at the DOUBLE -> NUMERIC cast
-- ------------------------------------------------------------
-- These literals are perfectly representable as DOUBLE (see the first column: 1e-253 etc.),
-- so this is NOT a DOUBLE underflow. The cast result becomes 0 because float NUMERIC has a
-- max scale of 252, so any magnitude below ~10^-252 has no representable digit and rounds to 0.
-- IMPORTANT: This is a NUMERIC-stage underflow (scale limit), not DOUBLE underflow and not NUMERIC overflow.
SELECT 1e-253, CAST(1e-253 AS NUMERIC);
SELECT 1e-260, CAST(1e-260 AS NUMERIC);
SELECT 1e-280, CAST(1e-280 AS NUMERIC);
SELECT 1e-300, CAST(1e-300 AS NUMERIC);
SELECT 1e-307, CAST(1e-307 AS NUMERIC);

evaluate '4. cast-in-cast';
-- ------------------------------------------------------------
-- cast-in-cast: float/double -> numeric
-- ------------------------------------------------------------
SELECT CAST(CAST(1677.217 AS FLOAT)  AS NUMERIC);
SELECT CAST(CAST(1677.2171111 AS DOUBLE) AS NUMERIC);

evaluate '5. mixed arithmetic + typeof';
-- ------------------------------------------------------------
-- mixed arithmetic + typeof
-- ------------------------------------------------------------
SELECT 999999.999999 + CAST(0.00000001 AS DOUBLE),
       TYPEOF(999999.999999 + CAST(0.00000001 AS DOUBLE));

SELECT 999999.999999 + CAST(0.00000001 AS FLOAT),
       TYPEOF(999999.999999 + CAST(0.00000001 AS FLOAT));

-- numeric + int keeps numeric (legacy behavior)
SELECT 999999.999999 + CAST(0.00000001 AS INT),
       TYPEOF(999999.999999 + CAST(0.00000001 AS INT));

-- numeric + varchar => DOUBLE (string coerces to double in arithmetic)
SELECT 999999.999999 + CAST('0.00000001' AS VARCHAR),
       TYPEOF(999999.999999 + CAST('0.00000001' AS VARCHAR));

evaluate '6. float/double precision loss demonstration';
-- ------------------------------------------------------------
-- float/double precision loss demonstration
-- ------------------------------------------------------------
-- float/double -> numeric can lose digits before cast.
SELECT CAST(CAST(0.00000001 AS FLOAT) AS NUMERIC);
SELECT CAST(CAST(0.01       AS FLOAT) AS NUMERIC);
SELECT CAST(CAST(0.090000000000000000000000000000000000000009 AS FLOAT) AS NUMERIC);
SELECT CAST(CAST(0.090909090909 AS FLOAT) AS NUMERIC);

SELECT 999999.999999 + CAST(0.00000001 AS FLOAT);

SELECT CAST(CAST(123.0001 AS INT) AS NUMERIC);

SELECT CAST(CAST(0.0000000000000000000000001 AS DOUBLE) AS NUMERIC);
SELECT CAST(CAST(0.999999999999999  AS DOUBLE) AS NUMERIC);
SELECT CAST(CAST(0.9999999999999999 AS DOUBLE) AS NUMERIC); -- may become 1 due to DOUBLE rounding
SELECT CAST(CAST(0.090000000000000000000000000000000000000009 AS DOUBLE) AS NUMERIC);
SELECT CAST(CAST(0.090909090909 AS DOUBLE) AS NUMERIC);

SELECT 999999.999999 + CAST(0.00000001 AS DOUBLE);

-- double -> numeric max
SELECT 999999999999999999999999999999999999999e+214, CAST(999999999999999999999999999999999999999e+214 AS NUMERIC);
SELECT 9.99999999999999e+253, CAST(9.99999999999999e+253 AS NUMERIC);

-- 9.99e254 is a valid DOUBLE (prints fine); only the NUMERIC cast overflows (error)
SELECT 9.99999999999999e+254;
SELECT CAST(9.99999999999999e+254 AS NUMERIC);

evaluate '7. Overflow (error)';
-- ------------------------------------------------------------
-- Overflow on NUMERIC range (true overflow) (error)
-- ------------------------------------------------------------
-- 1e+254 exceeds float-numeric max => should overflow (expect error)
SELECT CAST(1e+254 AS NUMERIC);

-- 40-digit mantissa + 214 zeros => effectively pushes beyond max => expect error
SELECT CAST(9999999999999999999999999999999999999999e+214 AS NUMERIC);

evaluate '8. DOUBLE literal out-of-range (error)';
-- ------------------------------------------------------------
-- DOUBLE literal below the smallest normal double -> parse-stage failure (error)
-- ------------------------------------------------------------
-- 1e-308 is below the smallest normal double (~2.2e-308), so CUBRID rejects it at parse
-- time with a syntax error (-493). This is a DOUBLE-stage (underflow) failure at parsing,
-- not a NUMERIC cast overflow.
SELECT 1e-308;