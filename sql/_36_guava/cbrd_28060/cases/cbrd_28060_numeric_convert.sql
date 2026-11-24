/**
 *  This test case verifies CBRD-28060: Make hashing follow comparison and remove its inefficiencies
 *
 *  Before the change, a NUMERIC with 16 or more digits and a scale converted to DOUBLE through two roundings, so
 *  NUMERIC(24,4) 495038888524330534.0000 and BIGINT 495038888524330534 became two DOUBLEs. A NUMERIC or a string
 *  converted to FLOAT through DOUBLE as well, and a string of a subnormal DOUBLE (1e-310) was an overflow error. The
 *  change rounds each conversion once, and converts the subnormal string to the DOUBLE. Each column of a query compares
 *  two conversions and prints 1 when they agree.
 *
 *  Coverage:
 *    Case 1:  NUMERIC to DOUBLE - one value converts to one DOUBLE whatever its type and scale
 *    Case 2:  NUMERIC and string to FLOAT - a value just off the midpoint of two FLOATs converts to the nearest one
 *    Case 3:  string to DOUBLE - a subnormal value converts to it, not to an overflow error
 */

evaluate 'Case 1: NUMERIC to DOUBLE - one value converts to one DOUBLE whatever its type and scale';
-- each column compares two conversions of one value and prints 1 when they give one DOUBLE;
-- the DOUBLE nearest to 495038888524330534 is 495038888524330560, and rounding twice gives 495038888524330496
SELECT
  CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE) = CAST (CAST (495038888524330534 AS BIGINT) AS DOUBLE) numeric_bigint,
  CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE) = CAST (CAST (495038888524330534 AS NUMERIC (18, 0)) AS DOUBLE) numeric_scale,
  CAST (CAST (0.1 AS NUMERIC (38, 30)) AS DOUBLE) = CAST (0.1 AS DOUBLE) numeric_fraction;

SELECT TO_CHAR (CAST (CAST (495038888524330534.0000 AS NUMERIC (24, 4)) AS DOUBLE), '999999999999999999');

evaluate 'Case 2: NUMERIC and string to FLOAT - a value just off the midpoint of two FLOATs converts to the nearest one';
-- the FLOAT nearest to 1.0000000596046447753906250001 is 1 + 2^-23 (1.00000011920928955078125) and the one nearest to
-- 5189924.749999999751703 is 5189924.5; a conversion through DOUBLE rounds each to the midpoint and then to the even
-- FLOAT, 1 and 5189925. Each column prints 1 when the conversion gives the nearest FLOAT
SELECT
  CAST (1.0000000596046447753906250001 AS FLOAT) = CAST (1.00000011920928955078125 AS FLOAT) numeric_up,
  CAST (5189924.749999999751703 AS FLOAT) = CAST (5189924.5 AS FLOAT) numeric_down,
  CAST ('1.0000000596046447753906250001' AS FLOAT) = CAST (1.00000011920928955078125 AS FLOAT) string_up,
  CAST ('5189924.749999999751703' AS FLOAT) = CAST (5189924.5 AS FLOAT) string_down;

evaluate 'Case 3: string to DOUBLE - a subnormal value converts to it, not to an overflow error';
-- 1e-310 lies between 0 and the smallest normal DOUBLE, 2.2250738585072014e-308; each column prints 1 when the
-- conversion lies in that range
SELECT CAST ('1e-310' AS DOUBLE) > 0 above_zero, CAST ('1e-310' AS DOUBLE) < 2.2250738585072014e-308 below_normal;
