/* 13. SUM / AVG over Float NUMERIC: accumulation, boundary overflow, AVG rounding */

-- Engine: CUBRID (Float NUMERIC)
-- Policy:
--   - aggregate over rows (SUM/AVG), unlike _06 which is scalar literal OP literal
--   - focus: SUM keeps the Float NUMERIC value+scale, SUM overflows at the boundary,
--            and AVG returns DOUBLE (the division inside AVG casts to DOUBLE, so the
--            result is NOT a 40-significant-digit Float NUMERIC)
-- NOTE:
--   - v is declared NUMERIC (Float NUMERIC): the inserted scale is kept per row
--   - AVG(v) is DOUBLE, so its printed form differs between JDBC (shortest round-trip,
--     ~17 digits) and CCI (~10 digits) -> hence the separate 13_sum_avg.answer_cci
--   - SUM accumulation overflow raises Error:-458 (data overflow), which differs from
--     the scalar Float NUMERIC scale/range Error:-494 used in _06
--   - the overflow literal below is the 9s(40,-214) value = the largest representable
--     Float NUMERIC magnitude, the exact literal reused from
--     _06_arithmetic_operation/_6_4_div/cases/4_div_float_failure.sql

DROP TABLE IF EXISTS agg_fn;
CREATE TABLE agg_fn (id INT, v NUMERIC);

INSERT INTO agg_fn VALUES (1, 1.0);
INSERT INTO agg_fn VALUES (2, 0.0);
INSERT INTO agg_fn VALUES (3, 0.0);
INSERT INTO agg_fn VALUES (4, NULL);
INSERT INTO agg_fn VALUES (5, 2.00000);
INSERT INTO agg_fn VALUES (6, 3.140000000000000000000000000000000000000);

-- ===========================================================================
-- Section 1: NULL is skipped by SUM/AVG (count of non-null denominator)
-- ===========================================================================
evaluate '1. SUM/AVG skip NULL';
-- Expect: SUM = 6.14 (Float NUMERIC), COUNT(v) = 5 (NULL row excluded),
--         AVG = SUM/5 = 1.228 returned as DOUBLE (JDBC 1.2280000000000002 / CCI 1.228)
SELECT SUM(v) AS s, COUNT(v) AS c, AVG(v) AS a FROM agg_fn;

-- ===========================================================================
-- Section 2: AVG returns DOUBLE, not a 40-significant-digit Float NUMERIC
-- ===========================================================================
evaluate '2. AVG of a repeating decimal is DOUBLE, not 40-significant-digit numeric';
-- rows 1..3 only: SUM = 1.0 over 3 rows -> AVG = 1/3 as DOUBLE
--   (JDBC 0.3333333333333333 / CCI 0.333333333), NOT 0.(40 threes)
SELECT AVG(v) FROM agg_fn WHERE id IN (1, 2, 3);

-- ===========================================================================
-- Section 3: SUM accumulation overflow at the scale boundary (Error:-458 data overflow)
-- ===========================================================================
DROP TABLE IF EXISTS agg_ovf;
CREATE TABLE agg_ovf (id INT, v NUMERIC);
-- two rows each = 9s(40,-214) (largest magnitude), their SUM exceeds the range
INSERT INTO agg_ovf VALUES (1, 99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);
INSERT INTO agg_ovf VALUES (2, 99999999999999999999999999999999999999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000);

evaluate '3. SUM of two max-magnitude values overflows (error)';
-- Expect: overflow -> Error:-458 (aggregate data overflow, unlike the scalar -494 in _06)
SELECT SUM(v) FROM agg_ovf;

-- ===========================================================================
-- Section 4: exact accumulation keeps value (positive control, no overflow)
-- ===========================================================================
evaluate '4. SUM exact, no overflow (control)';
-- Expect: 3.00000 (2.00000 + 1.0 by value, scale per Float NUMERIC rules)
SELECT SUM(v) FROM agg_fn WHERE id IN (1, 5);

-- clean up
DROP TABLE agg_fn;
DROP TABLE agg_ovf;
