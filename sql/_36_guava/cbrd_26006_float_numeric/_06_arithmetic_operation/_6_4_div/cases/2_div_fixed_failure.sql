/* 2. DIV Fixed NUMERIC failure (overflow / div-by-zero) */

-- ===========================================================================
-- Section 1: Division by zero (various numerators)
-- ===========================================================================

evaluate '1. DIV Fixed NUMERIC: division by zero (error)';

-- 1 / 0 -> ERROR: Attempt to divide by zero
SELECT CAST(1 AS NUMERIC(38,0)) / CAST(0 AS NUMERIC(38,0));

-- 0 / 0 -> ERROR: Attempt to divide by zero.
SELECT CAST(0 AS NUMERIC(38,0)) / CAST(0 AS NUMERIC(38,0));
 
-- MAX / 0 -> ERROR: Attempt to divide by zero
SELECT CAST(99999999999999999999999999999999999999 AS NUMERIC(38,0))
     / CAST(0 AS NUMERIC(38,0));

-- MIN / 0 -> ERROR: Attempt to divide by zero
SELECT CAST(-99999999999999999999999999999999999999 AS NUMERIC(38,0))
     / CAST(0 AS NUMERIC(38,0));


-- ===========================================================================
-- Section 2: Overflow by casting result into NUMERIC(38,0)
-- ===========================================================================

evaluate '2. DIV Fixed NUMERIC(38,0): overflow when cast back to fixed domain (error)';

-- (MAX / 0.1) -> overflow when cast back to NUMERIC(38,0)
SELECT CAST(
  CAST(99999999999999999999999999999999999999 AS NUMERIC(38,0))
  /
  CAST(0.1 AS NUMERIC(38,127))
AS NUMERIC(38,0));

-- (MIN / 0.1) -> overflow when cast back to NUMERIC(38,0)
SELECT CAST(
  CAST(-99999999999999999999999999999999999999 AS NUMERIC(38,0))
  /
  CAST(0.1 AS NUMERIC(38,127))
AS NUMERIC(38,0));

-- (MAX / 0.5) = 2*MAX -> overflow when cast back to NUMERIC(38,0)
SELECT CAST(
  CAST(99999999999999999999999999999999999999 AS NUMERIC(38,0))
  /
  CAST(0.5 AS NUMERIC(38,127))
AS NUMERIC(38,0));


-- ===========================================================================
-- Section 3: Division by zero (NUMERIC(38,-84), NUMERIC(38,127))
-- ===========================================================================

evaluate '3. DIV Fixed NUMERIC(38,-84) and (38,127): division by zero (error)';

-- 1 / 0  (38,-84) -> ERROR: Attempt to divide by zero
SELECT CAST(1 AS NUMERIC(38,-84)) / CAST(0 AS NUMERIC(38,-84));

-- 1 / 0  (38,127) -> overflow, NOT divide-by-zero
-- CAST(1 AS NUMERIC(38,127)) overflows before the division ever runs: (38,127) has no integer-part
-- room (p - s = 38 - 127 = -89), so the value 1 cannot be represented and the operand cast fails first
SELECT CAST(1 AS NUMERIC(38,127)) / CAST(0 AS NUMERIC(38,127));

-- MAX_FRAC / 0  (38,127) -> ERROR: Attempt to divide by zero
-- Numerator is representable in (38,127), so evaluation reaches the division and hits divide-by-zero
SELECT CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127)) / CAST(0 AS NUMERIC(38,127));


-- ===========================================================================
-- Section 4: Overflow by casting result into fixed domain
-- ===========================================================================

evaluate '4. DIV Fixed NUMERIC(38,-84) and (38,127): overflow when cast back to fixed domain (error)';

-- (38,-84) MAX / 0.5 = 2*MAX -> overflow when cast back to (38,-84)
SELECT CAST(
  CAST(99999999999999999999999999999999999999000000000000000000000000000000000000000000000000000000000000000000000000000000000000 AS NUMERIC(38,-84))
  /
  CAST(0.5 AS NUMERIC(38,127))
AS NUMERIC(38,-84));

-- (38,127) MAX_FRAC / 0.5 = 2*MAX_FRAC -> overflow when cast back to (38,127)
SELECT CAST(
  CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
  /
  CAST(0.5 AS NUMERIC(38,127))
AS NUMERIC(38,127));

-- (38,127) 1 / very small (still representable) -> overflow when cast back
-- NOTE: This value is intentionally tiny but within (38,127) scale range.
SELECT CAST(
  CAST(1 AS NUMERIC(38,127))
  /
  CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 AS NUMERIC(38,127))
AS NUMERIC(38,127));

-- MAX_FRAC / (~1e-90): both operands fit in (38,127), so the division runs, but the quotient
-- (a / b ~ 9.99) no longer fits in (38,127) -> overflow (Error -427) when cast back
SELECT CAST(
  CAST(0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000099999999999999999999999999999999999999 AS NUMERIC(38,127))
  /
  CAST(0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 AS NUMERIC(38,127))
AS NUMERIC(38,127));
