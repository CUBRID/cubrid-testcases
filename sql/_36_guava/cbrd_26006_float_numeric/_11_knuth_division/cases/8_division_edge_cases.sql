evaluate '8. Knuth division: deterministic edge cases (integer vs numeric path, zero, scale boundary)';
/*
 * These deterministic edge cases complement the randomized batteries 1-7.
 * IMPORTANT: when both operands are integers within BIGINT range CUBRID performs
 * INTEGER division (the fraction is truncated). To exercise the 40-significant-digit
 * Float NUMERIC division, at least one operand must be a decimal literal, or an
 * operand must exceed the BIGINT range (>= 20 digits) so it is parsed as NUMERIC.
 */

evaluate '8-1. Division by zero and zero dividend';
-- Expect: division by zero -> Error:-494
SELECT 1 AS scenario, 12345 / 0;
-- Expect: 0 (zero dividend, integer path)
SELECT 2 AS scenario, 0 / 12345;
-- Expect: 0 (zero dividend, numeric path)
SELECT 3 AS scenario, 0.0 / 12345.678;
-- Expect: division by zero -> Error:-494
SELECT 4 AS scenario, 0 / 0;

evaluate '8-2. Identity and exact division (integer path vs numeric path)';
-- 27-digit dividend exceeds BIGINT -> numeric division path.  x / 1 = x
SELECT 5 AS scenario, 987654321987654321987654321 / 1;
-- numeric path.  x / x = 1
SELECT 6 AS scenario, 987654321987654321987654321 / 987654321987654321987654321;
-- Expect: 25 (integer division, exact)
SELECT 7 AS scenario, 100 / 4;
-- Expect: 12 (integer division truncates the .5, NOT 12.5)
SELECT 8 AS scenario, 100 / 8;
-- Expect: 12.5 (numeric division: decimal literal keeps the fraction)
SELECT 9 AS scenario, 100 / 8.0;
-- Expect: 312 (integer division truncates the .5)
SELECT 10 AS scenario, 1000000 / 3200;
-- Expect: 312.5 (numeric division: decimal literal keeps the fraction)
SELECT 11 AS scenario, 1000000 / 3200.0;
-- Expect: -1 (integer division, exact)
SELECT 12 AS scenario, -100 / 100;

evaluate '8-3. Repeating decimals via numeric path, cut/rounded at 40 significant digits (half-up)';
-- A decimal literal (x.0) forces the numeric path so the repeating fraction is produced
-- and then cut/rounded to 40 significant digits.  Integer operands would truncate to 0/3.
-- Expect: 0.(threes), cut at 40 significant digits
SELECT 13 AS scenario, 1 / 3.0;
-- Expect: 0.(sixes) with the 40th significant digit rounded half-up (...7)
SELECT 14 AS scenario, 2 / 3.0;
-- Expect: 3.(threes) at 40 significant digits
SELECT 15 AS scenario, 10 / 3.0;
-- Expect: 0.142857... rounded at the 40th significant digit
SELECT 16 AS scenario, 1 / 7.0;
-- Expect: 0.285714... at 40 significant digits
SELECT 17 AS scenario, 2 / 7.0;

evaluate '8-4. Same value on the integer path vs the numeric path (BIGINT boundary)';
-- 19-digit dividend is within BIGINT -> integer division
SELECT 18 AS scenario, 1000000000000000000 / 3;
-- 20-digit dividend exceeds BIGINT -> numeric division (40 sig digits)
SELECT 19 AS scenario, 10000000000000000000 / 3;

evaluate '8-5. Float NUMERIC scale boundary (scale range -214 .. 252, numeric path)';
-- operands exceed BIGINT / are decimals, so all of D takes the numeric division path
-- 10^-250: within the scale limit -> value 10^-250, printed at scale 252 (ends ...0100)
SELECT 20 AS scenario, 1 / 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
-- 10^-500 = 10^-250 / 10^250: below the smallest representable magnitude (scale > 252)
-- Expect: 0 (underflow to zero)
SELECT 21 AS scenario, 0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001 / 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
-- 10^500 = 10^250 / 10^-250: beyond the largest representable magnitude (scale < -214)
-- Expect: overflow -> Error:-494
SELECT 22 AS scenario, 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 / 0.0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
-- identity at extreme magnitude
-- Expect: 1
SELECT 23 AS scenario, 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000 / 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
