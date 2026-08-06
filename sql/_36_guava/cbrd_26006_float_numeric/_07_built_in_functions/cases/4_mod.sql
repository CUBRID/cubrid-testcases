/* 4. Verify MOD behavior */

evaluate '1. >=20-digit integers';
-- ------------------------------------------------------------
-- >=20-digit integers (avoid int/bigint path)
-- ------------------------------------------------------------
SELECT MOD(12345678901234567890, 97);
SELECT MOD(123456789012345678901234567890, 97);
SELECT MOD(99999999999999999999, 999999);                   -- 20-digit
SELECT MOD(100000000000000000000, 999999);                  -- 21-digit
SELECT MOD(-100000000000000000000, 999999);

-- divisor > dividend with >=20-digit dividend (still pass)
SELECT MOD(12345678901234567890, 999999999999999999999999); -- should be dividend itself

evaluate '2. 40-digit mantissa';
-- ------------------------------------------------------------
-- 40-digit mantissa style (exactly 40 significant digits)
-- ------------------------------------------------------------
-- 40-digit integer (mantissa boundary)
SELECT MOD(9999999999999999999999999999999999999999, 999999);
SELECT MOD(-9999999999999999999999999999999999999999, 999999);

-- 40-digit mantissa + negative scale region (append many zeros)
SELECT MOD(
  99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  999999
);

SELECT MOD(
 -99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  999999
);

evaluate '3. 41 significant digits (rounded to 40)';
-- ------------------------------------------------------------
-- 41 significant digits -> rounded to 40
-- (These intentionally start with 41 sig digits; engine rounds to 40 and pushes remainder into scale)
-- ------------------------------------------------------------
-- 41-digit integer-like (forces rounding at 41st digit)
SELECT MOD(10000000000000000000000000000000000000005, 9);      -- 41 sig digits (1 + 40 zeros + 5)
SELECT MOD(99999999999999999999999999999999999999995, 9);      -- 41 sig digits (many 9s)

-- 41-digit mantissa + long zeros => negative scale representation
SELECT MOD(
  99999999999999999999999999999999999999995e+213,   -- 41 sig digits * 10^213 (display/parse via sci)
  999999
);
SELECT MOD(
 -99999999999999999999999999999999999999995e+213,
  999999
);

-- user test case
-- C  : 4803709.891017787611124171078542269062590
-- O  : 4803709.8910177876111242
-- PG : 4803709.8910177876111241697179812033294743955419
-- Result differs because the divisor exceeds 40 significant digits and is rounded before MOD.
-- divisor rounded to 40 sig digits (7 int + 33 frac); dividend scale 15
-- 40 - 7 = 33 - 15 = 18
-- 99999991239999999999999990000099234999000000000000000000 % 7349900990009991512311230023412999996390
-- -> 4803709891017787611124171078542269062590
select mod(99999991239999999999999.990000099234999, 7349900.9900099915123112300234129999963900999999);

evaluate '4. positive-scale boundary';
-- ------------------------------------------------------------
-- positive-scale boundary-ish (close to +252 region)
-- ------------------------------------------------------------
-- around 1e-252 magnitude; should still be representable (depends on literal trimming/rounding)
SELECT MOD(1e-252, 9);
SELECT MOD(-1e-252, 9);

-- lots of fractional digits (aiming near max printed precision behavior)
SELECT MOD(
  0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009999999999999999999999999999999999999999,
  0.1
);

SELECT MOD(
 -0.000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000009999999999999999999999999999999999999999,
  0.1
);

-- divisor slightly above 1 (rounding sensitive)
SELECT MOD(
  9999999999999999999999999999999999999999,
  1.000000000000000000000000000000000000001
);

evaluate '5. mixed huge A with fractional divisor';
-- ------------------------------------------------------------
-- mixed huge A with fractional divisor / fractional A with huge divisor
-- ------------------------------------------------------------
SELECT MOD(
  99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  0.000001
);

SELECT MOD(
  0.000001,
  99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
);

evaluate '6. near-boundary negative-scale creation';
-- ------------------------------------------------------------
-- near-boundary negative-scale creation using /0.1 style magnification inside expression
-- (Still MOD itself, but A is computed; if you want pure literal-only, skip this block)
-- ------------------------------------------------------------
SELECT MOD(
  (9999999999999999999999999999999999999999e+213) / 0.1,  -- magnify; may push scale more negative after rounding
  999999
);

evaluate '7. divisor = 0 returns dividend (not an error)';
-- ------------------------------------------------------------
-- divisor = 0 returns the dividend unchanged (per manual: MOD returns m when n is 0)
-- ------------------------------------------------------------
SELECT MOD(123456789012345678901234567890, 0);
SELECT MOD(0.00000000000000000000000000000000000000000000001, 0);
SELECT MOD(COALESCE(NULL, 12345678901234567890), 0);

evaluate '8. NULL diversity';
-- ------------------------------------------------------------
-- NULL diversity (COALESCE + NULLIF patterns)
-- ------------------------------------------------------------
-- pure NULL propagation
SELECT MOD(NULL, 999999);
SELECT MOD(999999, NULL);

-- COALESCE to avoid NULL dividend/divisor
SELECT MOD(COALESCE(NULL, 123456789012345678901234567890), 999999);
SELECT MOD(123456789012345678901234567890, COALESCE(NULL, 999999));

-- NULLIF to intentionally create NULL divisor (should become NULL, not error)
SELECT MOD(123456789012345678901234567890, NULLIF(0,0));
SELECT MOD(123456789012345678901234567890, NULLIF(999999,999999));

-- COALESCE + NULLIF to flip between error and safe path
SELECT MOD(123456789012345678901234567890, COALESCE(NULLIF(0,0), 999999));
SELECT MOD(123456789012345678901234567890, COALESCE(NULLIF(999999,999999), 999999));

-- COALESCE with huge/small values
SELECT MOD(COALESCE(NULL, 9999999999999999999999999999999999999999), 999999);
SELECT MOD(COALESCE(NULL, 1e-252), 999999);
SELECT MOD(COALESCE(NULL, -1e-252), 999999);

evaluate '9. potential overflow (observation)';
-- ------------------------------------------------------------
-- potential overflow via extreme tiny divisor-like behavior
-- (MOD itself may or may not throw; keep as observation tests for scale<-214 paths)
-- ------------------------------------------------------------
SELECT MOD(
  99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  1e-252
);

SELECT MOD(
 -99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000,
  1e-252
);

-- minimal divisor = 0 (returns dividend, not an error)
SELECT MOD(1, 0);
SELECT MOD(0.123, 0);