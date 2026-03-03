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

evaluate 'Case 7.5: Invalid Input Handling';
SELECT 
    adddate('invalid-date', INTERVAL 1 DAY) as invalid_date;
SELECT
    adddate(date'2020-01-01', INTERVAL 'abc' DAY) as invalid_interval;

DROP TABLE type_test;