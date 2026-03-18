/**
 * This test case verifies CBRD-26457: adddate(), subdate() result error
 * 
 * Improvement:
 * - Align behavior with MySQL
 * - Correct leap year and year-end date calculations
 * - Support for all castable types (not just CHAR/VARCHAR/SHORT/INT/BIGINT/NUMERIC)
 * - MILLISECOND interpretation (single unit & composite unit)
 * - Millisecond padding rules: ≤3 digits pad right, >3 digits trim left zeros
 * - Correct delimiter parsing in composite intervals
 */

-- ============================================================================
-- TEST 1: Incorrect Leap Year Last Day Calculation
-- ============================================================================
evaluate 'Case 1.1: Leap Year Boundaries - adddate';
SELECT 
    rownum, 
    adddate(date'2020-01-01', 362 + rownum) as add_2020,
    adddate(date'2021-01-01', 362 + rownum) as add_2021
FROM table ({1, 2, 3, 4, 5}) x;

evaluate 'Case 1.2: Leap Year Boundaries - subdate';
SELECT 
    rownum, 
    subdate(date'2020-01-01', 362 + rownum) as sub_2020,
    subdate(date'2021-01-01', 362 + rownum) as sub_2021
FROM table ({1, 2, 3, 4, 5}) x;

evaluate 'Case 1.3: Leap Day';
SELECT
    adddate(date'2020-02-29', 1) as leap_day_next,
    subdate(date'2020-02-29', 1) as leap_day_prev,
    subdate(date'2020-03-01', 1) as march_to_leap_day,
    adddate(date'2020-01-01', 365) as leap_plus_365,
    adddate(date'2020-01-01', 366) as leap_plus_366;

evaluate 'Case 1.4: Multiple Leap Year Boundaries';
SELECT 
    adddate(date'2020-01-01', 365) as year_2020_end,
    adddate(date'2020-01-01', 365 + 365) as year_2021_end,
    adddate(date'2020-01-01', 365 + 365 + 365) as year_2022_end,
    adddate(date'2020-01-01', 365 + 365 + 365 + 365) as year_2023_end;

evaluate 'Case 1.5: Century Year Leap Year Rules (100/400 divisibility)';
SELECT
    adddate(date'1900-02-28', 1) as year_1900,  -- NOT leap (divisible by 100, not 400)
    adddate(date'2000-02-28', 1) as year_2000,  -- IS leap (divisible by 400)
    adddate(date'2100-02-28', 1) as year_2100,  -- NOT leap (divisible by 100, not 400)
    adddate(date'2400-02-28', 1) as year_2400;  -- IS leap (divisible by 400)
-- Expected: 1900->03/01, 2000->02/29, 2100->03/01, 2400->02/29

-- ============================================================================
-- TEST 2: REVERSIBILITY VALIDATION
-- ============================================================================
evaluate 'Case 2.1: Short-Range Reversibility (400 days around leap year)';
SELECT COUNT(*) as failure_count FROM (
    SELECT 
        rownum,
        adddate(date'2020-01-01', rownum) as forward,
        subdate(date'2020-01-01', rownum) as backward,
        subdate(adddate(date'2020-01-01', rownum), rownum) as should_be_orig_1,
        adddate(subdate(date'2020-01-01', rownum), rownum) as should_be_orig_2
    FROM table ({1,2,3,4,5,6,7,8,9,0}) a,
         table ({1,2,3,4,5,6,7,8,9,0}) b
    LIMIT 400
) test
WHERE should_be_orig_1 != date'2020-01-01' 
   OR should_be_orig_2 != date'2020-01-01';
-- Expected: failure_count = 0

-- This tests the complete leap year calculation rules (4, 100, 400 year cycles)
evaluate 'Case 2.2: Extended Reversibility (150,000 days = 400+ years)';
SELECT COUNT(*) as failure_count FROM (
    SELECT 
        rownum,
        adddate(date'2020-01-01', rownum) as p,
        subdate(date'2020-01-01', rownum) as m,
        subdate(adddate(date'2020-01-01', rownum), rownum) as x,
        adddate(subdate(date'2020-01-01', rownum), rownum) as y
    FROM table ({1,2,3,4,5,6,7,8,9,0}) a,
         table ({1,2,3,4,5,6,7,8,9,0}) b,
         table ({1,2,3,4,5,6,7,8,9,0}) c,
         table ({1,2,3,4,5,6,7,8,9,0}) d,
         table ({1,2,3,4,5,6,7,8,9,0}) e,
         table ({1,2,3,4,5,6,7,8,9,0}) f
    LIMIT 150000
) xx
WHERE x != date'2020-01-01' OR y != date'2020-01-01';
-- Expected: failure_count = 0

-- ============================================================================
-- TEST 3: TYPE CASTING IMPROVEMENTS (Support All Castable Types)
-- ============================================================================
-- Setup test table with various types
DROP TABLE IF EXISTS type_test;
CREATE TABLE type_test (
    id INT,
    i INT,
    f FLOAT,
    d DOUBLE,
    n NUMERIC(10,2),
    s VARCHAR(32)
);

INSERT INTO type_test VALUES
    (1, 3, 3.7, 3.7, 3.70, '3.7'),
    (2, 5, 5.3, 5.3, 5.30, '5.3'),
    (3, 10, 10.0, 10.0, 10.00, '10'),
    (4, 30, 30.9, 30.9, 30.90, '30'),
    (5, -5, -5.5, -5.5, -5.50, '-5');

evaluate 'Case 3.1: ADDDATE() - Type Casting';
SELECT 
    id,
    -- single unit
    adddate('2020-01-01', INTERVAL i DAY) as from_int,
    adddate('2020-01-01', INTERVAL f DAY) as from_float,
    adddate('2020-01-01', INTERVAL d DAY) as from_double,
    adddate('2020-01-01', INTERVAL n DAY) as from_numeric,
    -- composite unit
    adddate('2020-01-01 10:00:00', INTERVAL i HOUR_MINUTE) as cs_from_int,
    adddate('2020-01-01 10:00:00', INTERVAL f HOUR_MINUTE) as cs_from_float,
    adddate('2020-01-01 10:00:00', INTERVAL s HOUR_MINUTE) as cs_from_varchar
FROM type_test
ORDER BY id;

evaluate 'Case 3.2: DATE_ADD() - Type Casting';
SELECT 
    id,
    -- single unit
    date_add('2020-01-01', INTERVAL i DAY) as from_int,
    date_add('2020-01-01', INTERVAL f DAY) as from_float,
    date_add('2020-01-01', INTERVAL d DAY) as from_double,
    date_add('2020-01-01', INTERVAL n DAY) as from_numeric,
    -- composite unit
    date_add('2020-01-01 10:00:00', INTERVAL i HOUR_MINUTE) as cs_from_int,
    date_add('2020-01-01 10:00:00', INTERVAL f HOUR_MINUTE) as cs_from_float,
    date_add('2020-01-01 10:00:00', INTERVAL s HOUR_MINUTE) as cs_from_varchar
FROM type_test
ORDER BY id;

evaluate 'Case 3.3: SUBDATE() - Type Casting';
SELECT 
    id,
    -- single unit
    subdate('2020-01-01', INTERVAL i DAY) as from_int,
    subdate('2020-01-01', INTERVAL f DAY) as from_float,
    subdate('2020-01-01', INTERVAL d DAY) as from_double,
    subdate('2020-01-01', INTERVAL n DAY) as from_numeric,
    -- composite unit
    subdate('2020-01-01 10:00:00', INTERVAL i HOUR_MINUTE) as cs_from_int,
    subdate('2020-01-01 10:00:00', INTERVAL f HOUR_MINUTE) as cs_from_float,
    subdate('2020-01-01 10:00:00', INTERVAL s HOUR_MINUTE) as cs_from_varchar
FROM type_test
ORDER BY id;

evaluate 'Case 3.4: DATE_SUB() - Type Casting';
SELECT 
    id,
    -- single unit
    date_sub('2020-01-01', INTERVAL i DAY) as from_int,
    date_sub('2020-01-01', INTERVAL f DAY) as from_float,
    date_sub('2020-01-01', INTERVAL d DAY) as from_double,
    date_sub('2020-01-01', INTERVAL n DAY) as from_numeric,
    -- composite unit
    date_sub('2020-01-01 10:00:00', INTERVAL i HOUR_MINUTE) as cs_from_int,
    date_sub('2020-01-01 10:00:00', INTERVAL f HOUR_MINUTE) as cs_from_float,
    date_sub('2020-01-01 10:00:00', INTERVAL s HOUR_MINUTE) as cs_from_varchar
FROM type_test
ORDER BY id;

evaluate 'Case 3.5: Function Equivalence (ADDDATE = DATE_ADD)';
SELECT 
    id,
    date_add('2020-01-01', INTERVAL f DAY) as date_add_result,
    adddate('2020-01-01', INTERVAL f DAY) as adddate_result,
    date_add('2020-01-01', INTERVAL f DAY) = adddate('2020-01-01', INTERVAL f DAY) as results_equal
FROM type_test
ORDER BY id;

evaluate 'Case 3.6: Function Equivalence (SUBDATE = DATE_SUB)';
SELECT 
    id,
    date_sub('2020-01-01', INTERVAL d DAY) as date_sub_result,
    subdate('2020-01-01', INTERVAL d DAY) as subdate_result,
    date_sub('2020-01-01', INTERVAL d DAY) = subdate('2020-01-01', INTERVAL d DAY) as results_equal
FROM type_test
ORDER BY id;

evaluate 'Case 3.7: Type Casting - Boundary Values';
SELECT 
    adddate(date'2020-01-01', INTERVAL 0.1 DAY) as near_zero,
    adddate(date'2020-01-01', INTERVAL 9999.99 DAY) as very_large,
    adddate(date'2020-01-01', INTERVAL -0.5 DAY) as negative_fraction;

evaluate 'Case 3.8: CAST() should still works correctly after the automatic casting improvements';
select 
    adddate(date'2020-01-01', CAST(10 as SMALLINT)) as smallint_test,
    adddate(date'2020-01-01', CAST(10 as INT)) as int_test,
    adddate(date'2020-01-01', CAST(10 as BIGINT)) as bigint_test,
    adddate(date'2020-01-01', CAST(10.5 as NUMERIC(10,2))) as numeric_test,
    adddate(date'2020-01-01', CAST('15' as CHAR(5))) as char_test,
    adddate(date'2020-01-01', CAST('20' as VARCHAR(10))) as varchar_test;

-- ============================================================================
-- TEST 4: MILLISECOND INTERPRETATION (Single vs Composite Unit)
-- ============================================================================
evaluate 'Case 4.1: Single Unit MILLISECOND (interpreted as milliseconds)';
SELECT 
    date_add('2020-01-01 00:00:00.000', INTERVAL 17 MILLISECOND) as milli_17,
    date_add('2020-01-01 00:00:00.000', INTERVAL 100 MILLISECOND) as milli_100,
    date_add('2020-01-01 00:00:00.000', INTERVAL 1000 MILLISECOND) as milli_1000,
    date_add('2020-01-01 00:00:00.000', INTERVAL 1500 MILLISECOND) as milli_1500;

evaluate 'Case 4.2: Composite Unit SECOND_MILLISECOND';
SELECT 
    date_add('2020-01-01 00:00:00.000', INTERVAL '17' SECOND_MILLISECOND) as sec_milli_17,
    date_add('2020-01-01 00:00:00.000', INTERVAL '100' SECOND_MILLISECOND) as sec_milli_100,
    date_add('2020-01-01 00:00:00.000', INTERVAL '1000' SECOND_MILLISECOND) as sec_milli_1000,
    date_add('2020-01-01 00:00:00.000', INTERVAL '1500' SECOND_MILLISECOND) as sec_milli_1500;

evaluate 'Case 4.3: Millisecond Padding Rules (≤3 digits: pad right)';
SELECT 
    '12' as input_value,
    date_add('2020-01-01 00:00:00.000', INTERVAL '12' SECOND_MILLISECOND) as pad_result,
    '1' as input_value_2,
    date_add('2020-01-01 00:00:00.000', INTERVAL '1' SECOND_MILLISECOND) as pad_result_2,
    '123' as input_value_3,
    date_add('2020-01-01 00:00:00.000', INTERVAL '123' SECOND_MILLISECOND) as pad_result_3;

evaluate 'Case 4.4: Millisecond Trimming Rules (>3 digits: trim left zeros)';
SELECT 
    '0012' as input_value,
    date_add('2020-01-01 00:00:00.000', INTERVAL '0012' SECOND_MILLISECOND) as trim_result,
    '0001200' as input_value_2,
    date_add('2020-01-01 00:00:00.000', INTERVAL '0001200' SECOND_MILLISECOND) as trim_result_2,
    '00001' as input_value_3,
    date_add('2020-01-01 00:00:00.000', INTERVAL '00001' SECOND_MILLISECOND) as trim_result_3;

evaluate 'Case 4.5: MINUTE/HOUR_MILLISECOND Padding/Trimming';
SELECT 
    -- Right padding (< 3 digits)
    date_add('2020-01-01 00:00:00.000', INTERVAL '5:3' MINUTE_MILLISECOND) as min_ms_pad,     -- '3'->'300'
    date_add('2020-01-01 00:00:00.000', INTERVAL '2:12' HOUR_MILLISECOND) as hr_ms_pad,       -- '12'->'120'
    -- Left trimming (>= 3 digits)
    date_add('2020-01-01 00:00:00.000', INTERVAL '5:0012' MINUTE_MILLISECOND) as min_ms_trim, -- '0012'->'012'
    date_add('2020-01-01 00:00:00.000', INTERVAL '2:005000' HOUR_MILLISECOND) as hr_ms_trim;  -- 2:005000 = 7 sec

evaluate 'Case 4.6: Other Composite Units with Milliseconds';
SELECT 
    date_add('2020-01-01 00:00:00.000', INTERVAL '5:30' MINUTE_MILLISECOND) as min_milli,
    date_add('2020-01-01 00:00:00.000', INTERVAL '2:15:45' HOUR_MILLISECOND) as hour_milli,
    date_add('2020-01-01 00:00:00.000', INTERVAL '5 10:30:45.250' DAY_MILLISECOND) as day_milli;

-- ============================================================================
-- TEST 5: COMPOSITE UNIT SEPARATOR
-- ============================================================================
evaluate 'Case 5.1: FIXED - Separator Parsing Bug';
SELECT 
    date_add('2020-01-01 10:00:00', INTERVAL '1xyz3' HOUR_MINUTE) as result_xyz,
    date_add('2020-01-01 10:00:00', INTERVAL '2abc5' HOUR_MINUTE) as result_abc,
    date_add('2020-01-01 10:00:00', INTERVAL '10def30' MINUTE_SECOND) as result_def,
    date_add('2020-01-01 00:00:00', INTERVAL '5xxxxxxxxx45' MINUTE_SECOND) as result_xxxxxxxxx;

evaluate 'Case 5.2: Various Separators';
SELECT
    date_add('2020-01-01 10:00:00', INTERVAL '1:3' HOUR_MINUTE) as with_colon,
    date_add('2020-01-01 10:00:00', INTERVAL '1-3' HOUR_MINUTE) as with_dash,
    date_add('2020-01-01 10:00:00', INTERVAL '1.3' HOUR_MINUTE) as with_dot,
    date_add('2020-01-01 10:00:00', INTERVAL '1 3' HOUR_MINUTE) as with_space;

evaluate 'Case 5.3: Multiple Separators';
SELECT 
    date_add('2020-01-01 10:00:00', INTERVAL '1::3' HOUR_MINUTE) as double_colon,
    date_add('2020-01-01 10:00:00', INTERVAL '1--3' HOUR_MINUTE) as double_dash,
    date_add('2020-01-01 10:00:00', INTERVAL '1abc::def3' HOUR_MINUTE) as double_ch;

evaluate 'Case 5.4: Composite Unit with Three Parts';
SELECT 
    date_add('2020-01-01 00:00:00', INTERVAL '2:15:30' HOUR_SECOND) as with_colon,
    date_add('2020-01-01 00:00:00', INTERVAL '2xyz15abc30' HOUR_SECOND) as with_letters;

evaluate 'Case 5.5: Whitespace tolerance';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1 :20' HOUR_MINUTE) AS space_result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:20' HOUR_MINUTE) AS normal_result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1 :20' HOUR_MINUTE)
        = adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:20' HOUR_MINUTE) AS space_tolerant_ok;

-- ============================================================================
-- TEST 6: NEGATIVE VALUE HANDLING IN COMPOSITE UNITS
-- ============================================================================
evaluate 'Case 6.1: Negative Composite Unit Values';
SELECT 
    date_add('2020-01-01 12:00:00', INTERVAL '-2:30' HOUR_MINUTE) as neg_hour_min,
    date_add('2020-01-01 12:00:00', INTERVAL '-5:45' MINUTE_SECOND) as neg_min_sec,
    date_add('2020-01-01 12:00:00', INTERVAL '-1 5' DAY_HOUR) as neg_day_hour,
    date_add('2020-01-01 12:00:00', INTERVAL '-1-3' YEAR_MONTH) as neg_year;

evaluate 'Case 6.2: Negative with Incomplete Data';
SELECT 
    date_add('2020-01-01 12:00:00', INTERVAL '-5' HOUR_MINUTE) as neg_incomp_1,
    date_add('2020-01-01 12:00:00', INTERVAL '-10' MINUTE_SECOND) as neg_incomp_2,
    date_add('2020-01-01', INTERVAL '-3' YEAR_MONTH) as neg_incomp_3;

evaluate 'Case 6.3: Negative Multi-Part Composite';
SELECT 
    date_add('2020-01-01 12:30:45', INTERVAL '-2:15:30' HOUR_SECOND) as three_part_neg,
    date_add('2020-01-01 12:30:45', INTERVAL '-1 2:15' DAY_MINUTE) as day_time_neg;

evaluate 'Case 6.4: Negative Zero';
SELECT 
    date_add('2020-01-01 12:00:00', INTERVAL '-0' HOUR_MINUTE) as neg_zero,
    date_add('2020-01-01 12:00:00', INTERVAL '0' HOUR_MINUTE) as pos_zero;

evaluate 'Case 6.5: Negative in the middle ignored';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '3:-2' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '3:-2' HOUR_MINUTE)
        = datetime'2025-01-01 13:02:00' AS sign_middle_ignored_ok;

-- ============================================================================
-- TEST 7: Other Cases
-- ============================================================================
evaluate 'Case 7.1: Null Values';
SELECT 
    adddate(NULL, INTERVAL 1 DAY) as null_date,
    adddate(date'2020-01-01', INTERVAL NULL DAY) as null_interval;

evaluate 'Case 7.2: DateTime Time Overflow';
SELECT 
    adddate(datetime'2020-12-31 23:59:59', INTERVAL 1 SECOND) as second_overflow,
    adddate(datetime'2020-12-31 23:59:00', INTERVAL 60 SECOND) as minute_boundary,
    adddate(datetime'2020-12-31 23:00:00', INTERVAL 60 MINUTE) as hour_boundary,
    adddate(datetime'2020-12-31 12:00:00', INTERVAL 12 HOUR) as day_boundary;

evaluate 'Case 7.3: Multiple Sequential Operations';
SELECT 
    base_date,
    adddate(base_date, INTERVAL 100 DAY) as step1,
    adddate(adddate(base_date, INTERVAL 100 DAY), INTERVAL 100 DAY) as step2,
    adddate(adddate(adddate(base_date, INTERVAL 100 DAY), INTERVAL 100 DAY), INTERVAL 100 DAY) as step3
FROM (SELECT date'2020-01-01' as base_date) x;

evaluate 'Case 7.4: Simple Two-Argument Syntax (no INTERVAL keyword)';
SELECT 
    adddate(date'2020-01-01', 10) as adddate_simple,
    subdate(date'2020-01-01', 10) as subdate_simple,
    adddate(date'2020-02-28', 1) as leap_year_simple,
    subdate(date'2020-03-01', 1) as leap_year_simple_sub,
    adddate(date'2020-01-01', 365) as add_365_leap,
    subdate(date'2020-01-01', 365) as sub_365;

-- ============================================================================
-- TEST 8: MONTH INTERVAL
-- ============================================================================
evaluate 'Case 8.1: End of Month - January 31 -> February (Leap vs Non-Leap)';
SELECT
    adddate(date'2020-01-31', INTERVAL 1 MONTH) AS leap_year_result,
    adddate(date'2021-01-31', INTERVAL 1 MONTH) AS non_leap_result,
    adddate(date'2020-01-31', INTERVAL 1 MONTH) = date'2020-02-29' AS leap_ok,
    adddate(date'2021-01-31', INTERVAL 1 MONTH) = date'2021-02-28' AS non_leap_ok;

evaluate 'Case 8.2: End of Month - Backward Month';
SELECT
    subdate(date'2020-03-31', INTERVAL 1 MONTH) AS leap_year_result,
    subdate(date'2021-03-31', INTERVAL 1 MONTH) AS non_leap_result,
    subdate(date'2020-03-31', INTERVAL 1 MONTH) = date'2020-02-29' AS leap_ok,
    subdate(date'2021-03-31', INTERVAL 1 MONTH) = date'2021-02-28' AS non_leap_ok;

evaluate 'Case 8.3: Multiple Month Carry';
SELECT
    adddate(date'2020-01-31', INTERVAL 2 MONTH) AS result_date,
    adddate(date'2020-01-31', INTERVAL 2 MONTH) = date'2020-03-31' AS carry_ok;

evaluate 'Case 8.4: Month Interval Across Year Boundary';
SELECT
    adddate(date'2020-10-31', INTERVAL 4 MONTH) AS result_date,
    adddate(date'2020-10-31', INTERVAL 4 MONTH) = date'2021-02-28' AS boundary_ok;

-- ============================================================================
-- TEST 9: NEGATIVE LEAP YEAR BOUNDARIES
-- Purpose: Verify backward traversal across leap years and correct borrow logic.
-- ============================================================================
evaluate 'Case 9.1: Reverse Across Leap Year';
SELECT
    subdate(date'2021-01-01', 366) AS result_date,
    subdate(date'2021-01-01', 366) = date'2020-01-01' AS reverse_ok;

evaluate 'Case 9.2: Reverse Across Leap Year';
SELECT
    subdate(date'2021-01-01', 366) AS result_date,
    subdate(date'2021-01-01', 366) = date'2020-01-01' AS reverse_ok;

evaluate 'Case 9.3: Negative Interval Equivalent';
SELECT
    adddate(date'2021-01-01', -366) AS negative_result,
    adddate(date'2021-01-01', -366) = date'2020-01-01' AS negative_ok;

evaluate 'Case 9.4: Reverse Leap Boundary Multiple';
SELECT
    subdate(date'2024-03-01', 1) AS prev_day,
    subdate(date'2024-03-01', 1) = date'2024-02-29' AS leap_ok;

-- ============================================================================
-- TEST 10: MONTH / YEAR INTERVAL ARITHMETIC
-- Purpose: Verify calendar-field arithmetic for month and year intervals.
-- ============================================================================
evaluate 'Case 10.1: Add One Year from Leap Day';
SELECT
    adddate(date'2020-02-29', INTERVAL 1 YEAR) AS result_date,
    adddate(date'2020-02-29', INTERVAL 1 YEAR) = date'2021-02-28' AS leap_adjust_ok;

evaluate 'Case 10.2: Subtract One Year from Leap Day';
SELECT
    subdate(date'2021-02-28', INTERVAL 1 YEAR) AS result_date,
    subdate(date'2021-02-28', INTERVAL 1 YEAR) = date'2020-02-28' AS year_ok;

evaluate 'Case 10.3: YEAR_MONTH Composite Interval';
SELECT
    adddate(date'2020-01-31', INTERVAL '1-2' YEAR_MONTH) AS result_date,
    adddate(date'2020-01-31', INTERVAL '1-2' YEAR_MONTH) = date'2021-03-31' AS composite_ok;
 
evaluate 'Case 10.4: Reverse YEAR_MONTH Composite';
SELECT
    subdate(date'2021-03-31', INTERVAL '1-2' YEAR_MONTH) AS result_date,
    subdate(date'2021-03-31', INTERVAL '1-2' YEAR_MONTH) = date'2020-01-31' AS reverse_ok;

-- ============================================================================
-- TEST 11: LARGE INTERVAL RANGE / OVERFLOW STABILITY
-- Purpose: 
-- Verify that large intervals do not produce incorrect arithmetic
-- and that step-by-step calculation matches one-shot calculation.
-- ============================================================================
evaluate 'Case 11.1: Large Positive Interval';
SELECT
    adddate(date'2000-01-01', INTERVAL 10000 DAY) AS result_date,
    adddate(date'2000-01-01', INTERVAL 10000 DAY)
        = adddate(adddate(date'2000-01-01', INTERVAL 9999 DAY), INTERVAL 1 DAY) AS stable_ok;

evaluate 'Case 11.2: Large Negative Interval';
SELECT
    subdate(date'2000-01-01', INTERVAL 10000 DAY) AS result_date,
    subdate(date'2000-01-01', INTERVAL 10000 DAY)
        = subdate(subdate(date'2000-01-01', INTERVAL 9999 DAY), INTERVAL 1 DAY) AS stable_ok;

evaluate 'Case 11.3: Symmetric Interval Reversibility';
SELECT
    subdate(adddate(date'2000-01-01', INTERVAL 5000 DAY), INTERVAL 5000 DAY) AS result_date,
    subdate(adddate(date'2000-01-01', INTERVAL 5000 DAY), INTERVAL 5000 DAY)
        = date'2000-01-01' AS reversible_ok;

evaluate 'Case 11.4: Large Positive Interval with DATETIME';
SELECT
    adddate(datetime'2000-01-01 00:00:00', INTERVAL 10000 DAY) AS result_dt,
    adddate(datetime'2000-01-01 00:00:00', INTERVAL 10000 DAY)
        = adddate(adddate(datetime'2000-01-01 00:00:00', INTERVAL 9999 DAY), INTERVAL 1 DAY) AS stable_ok;

evaluate 'Case 11.5: Large Negative Interval with DATETIME';
SELECT
    subdate(datetime'2000-01-01 00:00:00', INTERVAL 10000 DAY) AS result_dt,
    subdate(datetime'2000-01-01 00:00:00', INTERVAL 10000 DAY)
        = subdate(subdate(datetime'2000-01-01 00:00:00', INTERVAL 9999 DAY), INTERVAL 1 DAY) AS stable_ok;

-- ============================================================================
-- TEST 12: NUMERIC PART NORMALIZATION
-- Purpose: Verify that large numeric parts normalize correctly.
-- ============================================================================
evaluate 'Case 12.1: Large minute value normalization';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '12:500' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '12:500' HOUR_MINUTE)
        = datetime'2025-01-02 06:20:00' AS normalize_ok;

evaluate 'Case 12.2: Large second normalization';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '10:120' MINUTE_SECOND) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '10:120' MINUTE_SECOND)
        = datetime'2025-01-01 10:12:00' AS normalize_ok;

-- ============================================================================
-- TEST 13: NUMERIC TOKEN COUNT VALIDATION
-- Purpose: Verify NULL result when numeric token count exceeds expected parts.
-- ============================================================================
evaluate 'Case 13.1: Too many tokens in HOUR_MINUTE';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:2:3' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:2:3' HOUR_MINUTE) IS NULL AS token_overflow_ok;

evaluate 'Case 13.2: Too many tokens in DAY_SECOND';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1 2:3:4:5' DAY_SECOND) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1 2:3:4:5' DAY_SECOND) IS NULL AS token_overflow_ok;

-- ============================================================================
-- TEST 14: TYPE CAST BEHAVIOR
-- Purpose: Verify casting behavior for single-unit intervals.
-- ============================================================================
evaluate 'Case 14.1: Boolean casting';
SELECT
    adddate(date'2020-01-01', INTERVAL true DAY) AS result,
    adddate(date'2020-01-01', INTERVAL true DAY) = date'2020-01-02' AS cast_ok;

evaluate 'Case 14.2: Invalid numeric string';
SELECT
    adddate(date'2020-01-01', INTERVAL 'abc' DAY) as invalid_inter_s,
    adddate(date'2020-01-01', INTERVAL '10abc' DAY) as invalid_inter_sn;
-- Expected: ERROR (cannot cast to bigint)

evaluate 'Case 14.3: Invalid date';
SELECT 
    adddate('invalid-date', INTERVAL 1 DAY) as invalid_date;
-- Expected: ERROR

-- ============================================================================
-- TEST 15: DATE + TIME INTERVAL PROMOTION
-- Purpose: Verify correct DATE -> DATETIME promotion when time interval is used.
-- ============================================================================
evaluate 'Case 15.1: DATE + SECOND';
SELECT
    adddate(date'2025-01-01', INTERVAL 1 SECOND) AS result,
    adddate(date'2025-01-01', INTERVAL 1 SECOND)
        = datetime'2025-01-01 00:00:01' AS promotion_ok;

evaluate 'Case 15.2: DATE + HOUR';
SELECT
    adddate(date'2025-01-01', INTERVAL 2 HOUR) AS result,
    adddate(date'2025-01-01', INTERVAL 2 HOUR)
        = datetime'2025-01-01 02:00:00' AS promotion_ok;

-- ============================================================================
-- TEST 16: DAY_HOUR CARRY
-- Purpose: Verify carry from hours to day in composite intervals.
-- ============================================================================
evaluate 'Case 16.1: Hour overflow into day';
SELECT
    adddate(datetime'2025-01-01 00:00:00', INTERVAL '1 24' DAY_HOUR) AS result,
    adddate(datetime'2025-01-01 00:00:00', INTERVAL '1 24' DAY_HOUR)
        = datetime'2025-01-03 00:00:00' AS carry_ok;

-- ============================================================================
-- TEST 17: DATE-DATETIME ROUNDTRIP DRIFT
-- ============================================================================
evaluate 'Case 17.1: Basic roundtrip';
SELECT
    cast(adddate(cast(date'2025-01-01' as datetime), INTERVAL 0 SECOND) as date) AS result,
    cast(adddate(cast(date'2025-01-01' as datetime), INTERVAL 0 SECOND) as date)
        = date'2025-01-01' AS drift_ok;

evaluate 'Case 17.2: With second addition and rollback';
SELECT
    cast(subdate(adddate(cast(date'2025-01-01' as datetime), INTERVAL 1 SECOND), INTERVAL 1 SECOND) as date) AS result,
    cast(subdate(adddate(cast(date'2025-01-01' as datetime), INTERVAL 1 SECOND), INTERVAL 1 SECOND) as date)
        = date'2025-01-01' AS drift_ok;

evaluate 'Case 17.3: Leap day roundtrip';
SELECT
    cast(adddate(cast(date'2020-02-29' as datetime), INTERVAL 0 SECOND) as date) AS result,
    cast(adddate(cast(date'2020-02-29' as datetime), INTERVAL 0 SECOND) as date)
        = date'2020-02-29' AS drift_ok;

evaluate 'Case 17.4: Year boundary roundtrip';
SELECT
    cast(subdate(adddate(cast(date'2025-12-31' as datetime), INTERVAL 1 DAY), INTERVAL 1 DAY) as date) AS result,
    cast(subdate(adddate(cast(date'2025-12-31' as datetime), INTERVAL 1 DAY), INTERVAL 1 DAY) as date)
        = date'2025-12-31' AS drift_ok;

evaluate 'Case 17.5: Multiple chained conversions';
SELECT
    cast(adddate(cast(adddate(cast(date'2025-01-01' as datetime), INTERVAL 10 SECOND) as datetime), INTERVAL -10 SECOND) as date) AS result,
    cast(adddate(cast(adddate(cast(date'2025-01-01' as datetime), INTERVAL 10 SECOND) as datetime), INTERVAL -10 SECOND) as date)
        = date'2025-01-01' AS drift_ok;

-- ============================================================================
-- TEST 18: CROSS-UNIT NORMALIZATION ORDER
-- ============================================================================
evaluate 'Case 18.1: Second + millisecond carry';
SELECT
    date_add(datetime'2025-01-01 10:00:59.900', INTERVAL '0:200' SECOND_MILLISECOND) AS result,
    date_add(datetime'2025-01-01 10:00:59.900', INTERVAL '0:200' SECOND_MILLISECOND)
        = datetime'2025-01-01 10:01:00.100' AS normalize_ok;

evaluate 'Case 18.2: Millisecond overflow to next second';
SELECT
    date_add(datetime'2025-01-01 10:00:59.999', INTERVAL 2 MILLISECOND) AS result,
    date_add(datetime'2025-01-01 10:00:59.999', INTERVAL 2 MILLISECOND)
        = datetime'2025-01-01 10:01:00.001' AS normalize_ok;

evaluate 'Case 18.3: Minute + second carry';
SELECT
    date_add(datetime'2025-01-01 10:59:59', INTERVAL '0:2' MINUTE_SECOND) AS result,
    date_add(datetime'2025-01-01 10:59:59', INTERVAL '0:2' MINUTE_SECOND)
        = datetime'2025-01-01 11:00:01' AS normalize_ok;

evaluate 'Case 18.4: Hour + minute carry';
SELECT
    date_add(datetime'2025-01-01 23:59:00', INTERVAL '0:2' HOUR_MINUTE) AS result,
    date_add(datetime'2025-01-01 23:59:00', INTERVAL '0:2' HOUR_MINUTE)
        = datetime'2025-01-02 00:01:00' AS normalize_ok;

evaluate 'Case 18.5: Multi-level carry';
SELECT
    date_add(datetime'2025-01-01 23:59:59.900', INTERVAL '0:200' SECOND_MILLISECOND) AS result,
    date_add(datetime'2025-01-01 23:59:59.900', INTERVAL '0:200' SECOND_MILLISECOND)
        = datetime'2025-01-02 00:00:00.100' AS normalize_ok;

-- ============================================================================
-- TEST 19: YEAR-MONTH + DAY INTERACTION
-- ============================================================================
evaluate 'Case 19.1: Month then day';
SELECT
    adddate(adddate(date'2020-01-31', INTERVAL 1 MONTH), INTERVAL 1 DAY) AS result,
    adddate(adddate(date'2020-01-31', INTERVAL 1 MONTH), INTERVAL 1 DAY)
        = date'2020-03-01' AS normalize_ok;

evaluate 'Case 19.2: Day then month';
SELECT
    adddate(adddate(date'2020-01-31', INTERVAL 1 DAY), INTERVAL 1 MONTH) AS result,
    adddate(adddate(date'2020-01-31', INTERVAL 1 DAY), INTERVAL 1 MONTH)
        = date'2020-03-01' AS normalize_ok;

evaluate 'Case 19.3: Non-leap year interaction';
SELECT
    adddate(adddate(date'2021-01-31', INTERVAL 1 MONTH), INTERVAL 1 DAY) AS result,
    adddate(adddate(date'2021-01-31', INTERVAL 1 MONTH), INTERVAL 1 DAY)
        = date'2021-03-01' AS normalize_ok;

evaluate 'Case 19.4: Reverse interaction';
SELECT
    subdate(subdate(date'2020-03-01', INTERVAL 1 DAY), INTERVAL 1 MONTH) AS result,
    subdate(subdate(date'2020-03-01', INTERVAL 1 DAY), INTERVAL 1 MONTH)
        = date'2020-01-29' AS normalize_ok;

evaluate 'Case 19.5: Multi-month interaction';
SELECT
    adddate(adddate(date'2020-01-31', INTERVAL 2 MONTH), INTERVAL 1 DAY) AS result,
    adddate(adddate(date'2020-01-31', INTERVAL 2 MONTH), INTERVAL 1 DAY)
        = date'2020-04-01' AS normalize_ok;

-- ============================================================================
-- TEST 20: SIGN + CAST INTERACTION
-- ============================================================================
evaluate 'Case 20.1: Negative via varchar cast';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-130 as VARCHAR(10)) HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-130 as VARCHAR(10)) HOUR_MINUTE)
        = datetime'2025-01-01 07:50:00' AS cast_sign_ok;

evaluate 'Case 20.2: Positive via varchar cast';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(130 as VARCHAR(10)) HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(130 as VARCHAR(10)) HOUR_MINUTE)
        = datetime'2025-01-01 12:10:00' AS cast_sign_ok;

evaluate 'Case 20.3: Negative float cast';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-130.0 as VARCHAR(10)) HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-130.0 as VARCHAR(10)) HOUR_MINUTE)
        = datetime'2024-12-27 00:00:00' AS cast_sign_ok;

evaluate 'Case 20.4: Negative zero';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-0 as VARCHAR(10)) HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL CAST(-0 as VARCHAR(10)) HOUR_MINUTE)
        = datetime'2025-01-01 10:00:00' AS cast_sign_ok;

-- ============================================================================
-- TEST 21: PARTIAL PARSE FAILURE
-- ============================================================================
evaluate 'Case 21.1: Mixed tokens -> numeric extraction';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1a:xx' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1a:xx' HOUR_MINUTE)
        = datetime'2025-01-01 10:01:00' AS parse_ok;

evaluate 'Case 21.2: No numeric tokens -> zero interval';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL ':' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL ':' HOUR_MINUTE)
        = datetime'2025-01-01 10:00:00' AS parse_ok;

evaluate 'Case 21.3: Partial numeric';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL 'abc:20' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL 'abc:20' HOUR_MINUTE)
        = datetime'2025-01-01 10:20:00' AS parse_ok;

evaluate 'Case 21.4: Multiple delimiters';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:::' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '1:::' HOUR_MINUTE)
        = datetime'2025-01-01 10:01:00' AS parse_ok;

evaluate 'Case 21.5: Empty string';
SELECT
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '' HOUR_MINUTE) AS result,
    adddate(datetime'2025-01-01 10:00:00', INTERVAL '' HOUR_MINUTE)
        = datetime'2025-01-01 10:00:00' AS parse_ok;
  
DROP TABLE type_test;