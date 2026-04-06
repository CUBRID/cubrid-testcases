/**
 * This test case verifies CBRD-26518:
 * adddate()/subdate() should return NULL (not ERROR) on function errors
 * when return_null_on_function_errors=yes.
 */

--+ holdcas on;
--+ server-message on;

-- ============================================================
-- TEST 1: Default Behavior (return_null_on_function_errors=no)
-- Expect: errors are returned as errors (not NULL).
-- ============================================================
set system parameters 'return_null_on_function_errors=no';

evaluate 'Case 1.1: Default Behavior';
SELECT ADDDATE('9999-12-31', 1);
SELECT SUBDATE('9999-12-31', -1);
SELECT ADDDATE('0001-01-01', -500);
SELECT SUBDATE('0001-01-01', INTERVAL 2 YEAR);
SELECT ADDDATE('0001-01-01', INTERVAL -2 YEAR);
-- Result Between: '0000-00-00 00:00:00' & '0001-01-01 00:00:00' => returns a zero DATE/DATETIME value.
SELECT ADDDATE('0001-01-01', interval -1 year); -- Expected: '00/00/0000'
SELECT ADDDATE('0001-01-01', -2);               -- Expected: '00/00/0000'

evaluate 'Case 1.2: Valid Boundary Dates Check';
SELECT ADDDATE('9999-12-30', 1); -- Expected: '12/31/9999'
SELECT SUBDATE('9999-12-31', 1); -- Expected: '12/30/9999'
SELECT ADDDATE('0001-01-01', 1); -- Expected: '01/02/0001'
SELECT SUBDATE('0001-01-02', 1); -- Expected: '01/01/0001'

evaluate 'Case 1.3: Null input check – should return NULL, not error';
SELECT ADDDATE(NULL, 1);
SELECT SUBDATE(NULL, 1);
SELECT ADDDATE('9999-12-31', NULL);
SELECT SUBDATE('0001-01-01', NULL);

-- ============================================================
-- TEST 2: return_null_on_function_errors=yes
-- Expect: NULL is returned instead of ERROR.
-- ============================================================
set system parameters 'return_null_on_function_errors=yes';

evaluate 'Case 2.1: DATE upper boundary overflow';
SELECT ADDDATE('9999-12-31', 1);
SELECT ADDDATE('9999-12-31', 999999);
SELECT ADDDATE('9999-12-31', INTERVAL 1 DAY);
SELECT ADDDATE('9999-12-31', INTERVAL 1 MONTH);
SELECT ADDDATE('9999-12-31', INTERVAL 1 YEAR);
SELECT ADDDATE('9999-06-01', INTERVAL 999999 DAY);
SELECT SUBDATE('9999-12-31', -1);
SELECT SUBDATE('9999-12-31', INTERVAL -1 DAY);
-- ALL Expected: NULL

evaluate 'Case 2.2: DATE lower boundary underflow';
-- Result Between: '0000-00-00 00:00:00' & '0001-01-01 00:00:00' => returns a zero DATE/DATETIME value.
SELECT ADDDATE('0001-01-01', -1);    -- '00/00/0000'
SELECT ADDDATE('0001-01-01', -2);    -- '00/00/0000'
SELECT ADDDATE('0001-01-01', -365);  -- '00/00/0000'
SELECT ADDDATE('0001-01-01', -366);  -- '00/00/0000'
SELECT SUBDATE('0001-01-01', 1);     -- '00/00/0000'
SELECT SUBDATE('0001-01-01', 2);     -- '00/00/0000'
-- INTERVAL DAY: falls in zero-date range
SELECT ADDDATE('0001-01-01', INTERVAL -1 DAY);  -- '00/00/0000'
SELECT ADDDATE('0001-01-01', INTERVAL -2 DAY);  -- '00/00/0000'
SELECT SUBDATE('0001-01-01', INTERVAL 1 DAY);   -- '00/00/0000'
-- INTERVAL YEAR: 1 year back => zero-date range; 2 years back => NULL
SELECT ADDDATE('0001-01-01', INTERVAL -1 YEAR); -- '00/00/0000'
SELECT ADDDATE('0001-01-01', INTERVAL -2 YEAR); -- NULL
SELECT SUBDATE('0001-01-01', INTERVAL 1 YEAR);  -- '00/00/0000'
SELECT SUBDATE('0001-01-01', INTERVAL 2 YEAR);  -- NULL
-- INTERVAL MONTH / DAY beyond zero-date range
SELECT SUBDATE('0001-01-01', INTERVAL 13 MONTH); -- NULL
SELECT SUBDATE('0001-01-01', INTERVAL 500 DAY);  -- NULL
SELECT ADDDATE('0001-01-01', -500);              -- NULL

evaluate 'Case 3.1: DATETIME upper boundary overflow';
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 MILLISECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 SECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 DAY);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 YEAR);
SELECT SUBDATE(datetime'9999-12-31 23:59:59.999', INTERVAL -1 MILLISECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59', INTERVAL '1:0' MINUTE_SECOND);
-- ALL Expected: NULL

evaluate 'Case 3.2: DATETIME lower boundary underflow';
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 MILLISECOND);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 SECOND);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 HOUR);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 DAY);
-- ALL Expected: NULL

evaluate 'Case 4.1: TIMESTAMP upper boundary by second returns DATETIME';
SELECT
    ADDDATE(timestamp'2038-01-19 03:14:07', INTERVAL 1 SECOND) AS result,
    ADDDATE(timestamp'2038-01-19 03:14:07', INTERVAL 1 SECOND)
        = datetime'2038-01-19 03:14:08.000' AS expect_ok;
-- Expected: 2038-01-19 03:14:08.0     1

evaluate 'Case 4.2: TIMESTAMP upper boundary by day returns DATETIME';
SELECT
    ADDDATE(timestamp'2038-01-19 03:14:07', INTERVAL 1 DAY) AS result,
    ADDDATE(timestamp'2038-01-19 03:14:07', INTERVAL 1 DAY)
        = datetime'2038-01-20 03:14:07.000' AS expect_ok;
-- Expected: 2038-01-20 03:14:07.0     1

evaluate 'Case 4.3: TIMESTAMP alias DATE_ADD also returns DATETIME';
SELECT
    DATE_ADD(timestamp'2038-01-19 03:14:07', INTERVAL 1 SECOND) AS result,
    DATE_ADD(timestamp'2038-01-19 03:14:07', INTERVAL 1 SECOND)
        = datetime'2038-01-19 03:14:08.000' AS expect_ok;
-- Expected: 2038-01-19 03:14:08.0     1

evaluate 'Case 4.4: TIMESTAMP lower safe boundary by second';
SELECT
    SUBDATE(timestamp'1970-01-01 09:00:02', INTERVAL 1 SECOND) AS result,
    SUBDATE(timestamp'1970-01-01 09:00:02', INTERVAL 1 SECOND)
        = datetime'1970-01-01 09:00:01.000' AS expect_ok;
-- Expected: 1970-01-01 09:00:01.0     1

evaluate 'Case 4.5: TIMESTAMP lower safe boundary by zero interval';
SELECT
    ADDDATE(timestamp'1970-01-01 09:00:01', INTERVAL 0 SECOND) AS result,
    ADDDATE(timestamp'1970-01-01 09:00:01', INTERVAL 0 SECOND)
        = datetime'1970-01-01 09:00:01.000' AS expect_ok;
-- Expected: 1970-01-01 09:00:01.0     1

evaluate 'Case 4.6: TIMESTAMP alias DATE_SUB within valid range';
SELECT
    DATE_SUB(timestamp'1970-01-01 09:00:02', INTERVAL 1 SECOND) AS result,
    DATE_SUB(timestamp'1970-01-01 09:00:02', INTERVAL 1 SECOND)
        = datetime'1970-01-01 09:00:01.000' AS expect_ok;
-- Expected: 1970-01-01 09:00:01.0     1

evaluate 'Case 5.1: Aliases (DATE_ADD / DATE_SUB)';
SELECT DATE_ADD('9999-12-31', INTERVAL 1 DAY);      -- NULL
SELECT DATE_SUB('0001-01-01', INTERVAL 500 DAY);    -- NULL
SELECT DATE_ADD('0001-01-01', INTERVAL -1 YEAR);    -- 00/00/0000
SELECT DATE_ADD('0001-01-01', INTERVAL -2 YEAR);    -- NULL
SELECT DATE_SUB('0001-01-01', INTERVAL 1 YEAR);     -- 00/00/0000
SELECT DATE_SUB('0001-01-01', INTERVAL 2 YEAR);     -- NULL

evaluate 'Case 6.1: NULL propagation in arithmetic expression';
SELECT ADDDATE('9999-12-31', 1) + 0;
-- Expected: NULL

evaluate 'Case 6.2: NULL propagation in WHERE clause';
SELECT 1
FROM db_root
WHERE ADDDATE('9999-12-31', 1) IS NOT NULL;
-- Expected: no error

evaluate 'Case 6.3: NULL propagation in a subquery';
SELECT *
FROM (SELECT ADDDATE('9999-12-31', 1) AS result) AS sub
WHERE sub.result IS NULL;
-- Expected: NULL

evaluate 'Case 7.1: CASE expression containing an overflow call';
SELECT
    CASE
        WHEN ADDDATE('9999-12-31', 1) IS NULL 
        THEN 
            'overflow detected'
        ELSE 
            'no overflow'
    END;
-- Expected: 'overflow detected'

evaluate 'Case 7.2: CASE using overflow result as input';
SELECT
    CASE
        WHEN ADDDATE('9999-12-31', 1) IS NULL 
        THEN SUBDATE('2000-01-02', 1)
        ELSE ADDDATE('9999-12-31', 1)
    END AS result,
    CASE
        WHEN ADDDATE('9999-12-31', 1) IS NULL 
        THEN SUBDATE('2000-01-02', 1)
        ELSE ADDDATE('9999-12-31', 1)
    END = DATE'2000-01-01' AS expect_ok;

-- ===============================================================
-- Case 8: Repeated overflow calls in a single SELECT
-- Objective:
--      Verify that when the overflow function is called multiple times within the same SELECT
--      some parts are treated as NULL or errors do not recur.
-- Expectation:
--      All overflow/underflow results are NULL.
-- ===========================================================
evaluate 'Case 8.1: Same ADDDATE overflow called twice';
SELECT
    ADDDATE('9999-12-31', 1) AS col1,
    ADDDATE('9999-12-31', 1) AS col2,
    ADDDATE('9999-12-31', 1) IS NULL AS col1_null_ok,
    ADDDATE('9999-12-31', 1) IS NULL AS col2_null_ok;

evaluate 'Case 8.2: Same SUBDATE underflow called twice';
SELECT
    SUBDATE('0001-01-01', 1) AS col1,
    SUBDATE('0001-01-01', 1) AS col2,
    SUBDATE('0001-01-01', 1) IS NULL AS col1_null_ok,
    SUBDATE('0001-01-01', 1) IS NULL AS col2_null_ok;

evaluate 'Case 8.2: Same SUBDATE underflow called twice - REPEAT';
SELECT
    SUBDATE('0001-01-01', 1) AS col1,
    SUBDATE('0001-01-01', 1) AS col2,
    SUBDATE('0001-01-01', 1) = '00/00/0000' AS col1_zero_ok,
    SUBDATE('0001-01-01', 1) = '00/00/0000' AS col2_zero_ok;

evaluate 'Case 8.3: Mixed repeated overflow and underflow calls';
SELECT
    ADDDATE('9999-12-31', 1) AS add_over,
    SUBDATE('0001-01-01', 1) AS sub_under,
    ADDDATE('9999-12-31', 1) AS add_over_again,
    SUBDATE('0001-01-01', 1) AS sub_under_again,
    ADDDATE('9999-12-31', 1) IS NULL AS add_over_ok,
    SUBDATE('0001-01-01', 1) IS NULL AS sub_null_ok;

evaluate 'Case 8.3: Mixed repeated overflow and underflow calls - REPEAT';
SELECT
    ADDDATE('9999-12-31', 1) AS add_over,
    SUBDATE('0001-01-01', 1) AS sub_under,
    ADDDATE('9999-12-31', 1) AS add_over_again,
    SUBDATE('0001-01-01', 1) AS sub_under_again,
    ADDDATE('9999-12-31', 1) IS NULL AS add_over_ok,
    SUBDATE('0001-01-01', 1) = '00/00/0000' AS sub_zero_ok;

evaluate 'Case 8.4: Repeated alias calls';
SELECT
    DATE_ADD('9999-12-31', INTERVAL 1 DAY) AS col1,
    DATE_SUB('0001-01-01', INTERVAL 1 DAY) AS col2,
    DATE_ADD('9999-12-31', INTERVAL 1 DAY) IS NULL AS col1_null_ok,
    DATE_SUB('0001-01-01', INTERVAL 1 DAY) IS NULL AS col2_null_ok,
    DATE_SUB('0001-01-01', INTERVAL 1 DAY) = '00/00/0000' AS col2_zero_ok;

-- ==============================================================
-- Case 9: ORDER BY / DISTINCT / GROUP BY context
-- Objective:
--      Verify that no errors occur again during the sorting, duplicate removal, and grouping
--      processes after the function error has been changed to NULL
-- Expectation:
--      Execute without errors
-- ===========================================================
evaluate 'Case 9.1: ORDER BY overflow result';
SELECT
    r,
    r IS NULL AS null_ok
FROM (
    SELECT ADDDATE('9999-12-31', 1) AS r
    FROM db_root
) x
ORDER BY r;

evaluate 'Case 9.2: ORDER BY underflow result';
SELECT
    r,
    r IS NULL AS null_ok
FROM (
    SELECT SUBDATE('0001-01-01', 1) AS r
    FROM db_root
) x
ORDER BY r;

evaluate 'Case 9.3: DISTINCT on overflow result';
SELECT
    r,
    r IS NULL AS null_ok
FROM (
    SELECT DISTINCT ADDDATE('9999-12-31', 1) AS r
    FROM db_root
) x;

evaluate 'Case 9.4: GROUP BY overflow result';
SELECT
    r,
    COUNT(*) AS cnt,
    r IS NULL AS null_ok
FROM (
    SELECT ADDDATE('9999-12-31', 1) AS r
    FROM db_root
) x
GROUP BY r;

evaluate 'Case 9.5: GROUP BY mixed valid and invalid';
SELECT
    x.r,
    COUNT(*) AS cnt,
    CASE WHEN x.r IS NULL THEN 1 ELSE x.r = DATE'9999-12-31' END AS bucket_ok
FROM (
    SELECT ADDDATE('9999-12-31', 1) AS r FROM db_root
    UNION ALL
    SELECT ADDDATE('9999-12-30', 1) AS r FROM db_root
) x
GROUP BY x.r
ORDER BY x.r;

-- ==============================================================
-- Case 10: Aggregate context
-- Objective:
--      Verify that when an overflow result NULL is used with an aggregate function,
--      it leads to a normal NULL/aggregate result rather than an exception
-- Expectation:
--      Perform without errors
-- ===========================================================
evaluate 'Case 10.1: COALESCE wrapping an overflow call';
SELECT COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01');    -- Expected: '01/01/2000'
SELECT GREATEST(ADDDATE('9999-12-31', 1), DATE'2000-01-01');    -- Expected: NULL

evaluate 'Case 10.2: COALESCE with aggregate input';
SELECT
    COUNT(COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01')) AS cnt,
    COUNT(COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01')) = 1 AS expect_ok
FROM db_root;

evaluate 'Case 10.3: COUNT on overflow result';
SELECT
    COUNT(ADDDATE('9999-12-31', 1)) AS cnt,
    COUNT(ADDDATE('9999-12-31', 1)) = 0 AS expect_ok
FROM db_root;

evaluate 'Case 10.4: COUNT on underflow result';
SELECT
    COUNT(SUBDATE('0001-01-01', 1)) AS cnt,
    COUNT(SUBDATE('0001-01-01', 1)) = 0 AS expect_ok
FROM db_root;

evaluate 'Case 10.5: MIN and MAX on overflow result';
SELECT
    MIN(ADDDATE('9999-12-31', 1)) AS min_val,
    MAX(ADDDATE('9999-12-31', 1)) AS max_val,
    MIN(ADDDATE('9999-12-31', 1)) IS NULL AS min_null_ok,
    MAX(ADDDATE('9999-12-31', 1)) IS NULL AS max_null_ok
FROM db_root;

evaluate 'Case 10.6: Mixed aggregate valid and invalid';
SELECT
    MIN(x.r) AS min_val,
    MAX(x.r) AS max_val,
    COUNT(x.r) AS cnt_not_null,
    MIN(x.r) = DATE'9999-12-31' AS min_ok,
    MAX(x.r) = DATE'9999-12-31' AS max_ok,
    COUNT(x.r) = 1 AS cnt_ok
FROM (
    SELECT ADDDATE('9999-12-31', 1) AS r FROM db_root
    UNION ALL
    SELECT ADDDATE('9999-12-30', 1) AS r FROM db_root
) x;

-- ===============================================================
-- Case 11: CAST inputs with overflow / underflow
-- Objective: 
--      Verify that NULL is treated
--      even when an overflow occurs during the function evaluation phase after casting. 
-- Expectation: 
--      Return NULL without error. 
-- Caution: 
--      Cases where the casting to TIMESTAMP itself is invalid are outside the scope of this issue. 
-- ===========================================================

evaluate 'Case 11.1: CAST string to DATE - overflow';
SELECT
    ADDDATE(CAST('9999-12-31' AS DATE), 1) AS result,
    ADDDATE(CAST('9999-12-31' AS DATE), 1) IS NULL AS expect_ok;

evaluate 'Case 11.2: CAST string to DATE - underflow';
SELECT
    SUBDATE(CAST('0001-01-01' AS DATE), 1) AS result,
    SUBDATE(CAST('0001-01-01' AS DATE), 1) IS NULL AS expect_ok;

evaluate 'Case 11.3: CAST string to DATETIME - overflow';
SELECT
    ADDDATE(CAST('9999-12-31 23:59:59.999' AS DATETIME), INTERVAL 1 MILLISECOND) AS result,
    ADDDATE(CAST('9999-12-31 23:59:59.999' AS DATETIME), INTERVAL 1 MILLISECOND) IS NULL AS expect_ok;

evaluate 'Case 11.4: CAST string to DATETIME - underflow';
SELECT
    SUBDATE(CAST('0001-01-01 00:00:00.000' AS DATETIME), INTERVAL 1 MILLISECOND) AS result,
    SUBDATE(CAST('0001-01-01 00:00:00.000' AS DATETIME), INTERVAL 1 MILLISECOND) IS NULL AS expect_ok;

evaluate 'Case 11.5: CAST valid TIMESTAMP then safe arithmetic';
SELECT
    ADDDATE(CAST('2038-01-19 03:14:07' AS TIMESTAMP), INTERVAL 1 SECOND) AS result,
    ADDDATE(CAST('2038-01-19 03:14:07' AS TIMESTAMP), INTERVAL 1 SECOND)
        = datetime'2038-01-19 03:14:08.000' AS expect_ok;

evaluate 'Case 11.6: CAST valid TIMESTAMP then safe subtraction';
SELECT
    SUBDATE(CAST('1970-01-01 00:00:02' AS TIMESTAMP), INTERVAL 1 SECOND) AS result,
    SUBDATE(CAST('1970-01-01 00:00:02' AS TIMESTAMP), INTERVAL 1 SECOND)
        = datetime'1970-01-01 00:00:01.000' AS expect_ok;

-- ==============================================================
-- Case 12: Nested expression stability
-- Objective:
--      Verify that when a function result is NULL
--      no error occurs again even when nested within another function/expression
-- Expectation:
--      Return NULL or a valid replacement value without error
-- ===========================================================

evaluate 'Case 12.1: Nested ADDDATE overflow inside ADDDATE';
SELECT
    ADDDATE(ADDDATE('9999-12-31', 1), 1) AS result,
    ADDDATE(ADDDATE('9999-12-31', 1), 1) IS NULL AS expect_ok;

evaluate 'Case 12.2: Nested SUBDATE underflow inside SUBDATE';
SELECT
    SUBDATE(SUBDATE('0001-01-01', 1), 1) AS result,
    SUBDATE(SUBDATE('0001-01-01', 1), 1) IS NULL AS expect_ok;

evaluate 'Case 12.3: Overflow result inside COALESCE with ADDDATE';
SELECT
    ADDDATE(COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01'), 1) AS result,
    ADDDATE(COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01'), 1)
        = DATE'2000-01-02' AS expect_ok;

evaluate 'Case 12.4: Underflow result inside COALESCE with SUBDATE';
SELECT
    SUBDATE(COALESCE(SUBDATE('0001-01-01', 1), DATE'2000-01-02'), 1) AS result,
    SUBDATE(COALESCE(SUBDATE('0001-01-01', 1), DATE'2000-01-02'), 1)
        = DATE'2000-01-01' AS expect_ok;

evaluate 'Case 12.5: Arithmetic expression over COALESCE wrapped overflow';
SELECT
    COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01') + 1 AS result,
    COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01') + 1
        = DATE'2000-01-02' AS expect_ok;

set system parameters 'return_null_on_function_errors=no';
commit;

--+ server-message off;
--+ holdcas off;