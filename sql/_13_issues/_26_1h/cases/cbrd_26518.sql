/**
 * This test case verifies CBRD-26518:
 * adddate()/subdate() should return NULL (not ERROR) on function errors
 * when return_null_on_function_errors=yes.
 */
 --+ holdcas on;

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

evaluate 'Case 2.2: DATE lower boundary underflow';
SELECT ADDDATE('0001-01-01', INTERVAL -2 year);
SELECT ADDDATE('0001-01-01', -500);
SELECT SUBDATE('0001-01-01', INTERVAL 2 YEAR);
SELECT SUBDATE('0001-01-01', INTERVAL 13 MONTH);
SELECT SUBDATE('0001-01-01', INTERVAL 500 DAY);

evaluate 'Case 2.3: DATETIME upper boundary overflow';
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 MILLISECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 SECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 DAY);
SELECT ADDDATE(datetime'9999-12-31 23:59:59.999', INTERVAL 1 YEAR);
SELECT SUBDATE(datetime'9999-12-31 23:59:59.999', INTERVAL -1 MILLISECOND);
SELECT ADDDATE(datetime'9999-12-31 23:59:59', INTERVAL '1:0' MINUTE_SECOND);

evaluate 'Case 2.4: DATETIME lower boundary underflow';
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 MILLISECOND);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 SECOND);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 HOUR);
SELECT SUBDATE(datetime'0001-01-01 00:00:00.000', INTERVAL 1 DAY);

evaluate 'Case 2.5: Aliases (DATE_ADD / DATE_SUB)';
SELECT DATE_ADD('9999-12-31', INTERVAL 1 DAY);
SELECT DATE_SUB('0001-01-01', INTERVAL 500 DAY);

evaluate 'Case 2.6: NULL propagation in arithmetic expression';
SELECT ADDDATE('9999-12-31', 1) + 0;
-- Expected: NULL

evaluate 'Case 2.7: COALESCE wrapping an overflow call';
SELECT COALESCE(ADDDATE('9999-12-31', 1), DATE'2000-01-01'); 
-- Expected: '01/01/2000'

evaluate 'Case 2.8: CASE expression containing an overflow call';
SELECT
    CASE
        WHEN ADDDATE('9999-12-31', 1) IS NULL 
        THEN 
            'overflow detected'
        ELSE 
            'no overflow'
    END;
-- Expected: 'overflow detected'

evaluate 'Case 2.9: Null propagation in WHERE clause';
SELECT 1
FROM db_root
WHERE ADDDATE('9999-12-31', 1) IS NOT NULL;
-- Expected: no error

evaluate 'Case 2.10: Overflow inside a subquery';
SELECT *
FROM (SELECT ADDDATE('9999-12-31', 1) AS result) AS sub
WHERE sub.result IS NULL;
-- Expected: NULL

evaluate 'Case 2.11: Multiple overflow calls in the same SELECT';
SELECT ADDDATE('9999-12-31', 1)  AS col1,
       SUBDATE('0001-01-01', 500)  AS col2,
       ADDDATE('0001-01-01', -500) AS col3;
-- Expected: NULL  NULL  NULL

set system parameters 'return_null_on_function_errors=no';
commit;

--+ holdcas off;