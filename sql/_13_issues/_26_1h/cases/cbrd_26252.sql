/**
 * This test case verifies CBRD-26252: Procedure Call Policy Modification
 * 
 * Updated Policy:
 * - Procedure can be used in CALL statements, but cannot be used in SQL statements.
 * - When calling a procedure with the CALL statement, there must be no INTO clause.
 */

--+ server-message on

-- Setup: Create test procedures
CREATE OR REPLACE PROCEDURE proc_no_params AS
BEGIN
    DBMS_OUTPUT.put_line('proc_no_params executed');
END;

CREATE OR REPLACE PROCEDURE proc_with_params(arg1 INT) AS
BEGIN
    DBMS_OUTPUT.put_line('proc_with_params executed with value: ' || arg1);
END;

CREATE OR REPLACE PROCEDURE proc_out_params(arg1 INT, arg2 OUT INT) AS
BEGIN
    arg2 := arg1 * 2;
    DBMS_OUTPUT.put_line('proc_out_params executed');
END;

-- Setup: Create test table
DROP TABLE IF EXISTS tbl1;
CREATE TABLE tbl1 (col1 INT, col2 VARCHAR(10));
INSERT INTO tbl1 VALUES (1, 'test');

-- ==================================================
-- TEST 1: Valid CALL Statements
-- ==================================================

evaluate 'Case 1.1: CALL procedure without parameters';
CALL proc_no_params();

evaluate 'Case 1.2: CALL procedure with IN parameters';
CALL proc_with_params(10);

evaluate 'Case 1.3: CALL procedure with OUT parameters';
SELECT 0 INTO :var;
CALL proc_out_params(5, :var);
SELECT var;

-- ========================================
-- TEST 2: Invalid CALL with INTO clause - ERROR
-- ========================================

evaluate 'Case 2.1: CALL procedure with INTO clause - with IN parameters';
CALL proc_with_params(10) INTO :v;

evaluate 'Case 2.2: CALL procedure with INTO clause - with OUT parameter';
SELECT 0 INTO :var;
CALL proc_out_params(5, :var) INTO :v;
SELECT var;

-- ========================================
-- TEST 3: Procedures in SQL statements - ERROR
-- ========================================

evaluate 'Case 3.1: Procedure in SELECT list with table';
SELECT col1, proc_no_params() FROM tbl1;

evaluate 'Case 3.2: Procedure in WHERE clause';
SELECT * FROM tbl1 WHERE col1 = proc_no_params();

evaluate 'Case 3.3: Procedure in subquery';
SELECT * FROM (SELECT proc_no_params() AS result);

evaluate 'Case 3.4: Procedure in CASE expression';
SELECT CASE WHEN proc_no_params() = 1 THEN 'yes' ELSE 'no' END FROM db_root;

evaluate 'Case 3.5: Procedure in aggregate function';
SELECT COUNT(proc_no_params()) FROM tbl1;

evaluate 'Case 3.6: Procedure in HAVING clause';
SELECT COUNT(*) FROM tbl1 GROUP BY col1 HAVING COUNT(*) = proc_no_params();

evaluate 'Case 3.7: Procedure in UNION query';
SELECT col1 FROM tbl1
UNION
SELECT proc_no_params() FROM db_root;

-- ========================================
-- TEST 4: Procedures in INSERT statements - ERROR
-- ========================================

evaluate 'Case 4.1: Procedure in INSERT VALUES clause';
INSERT INTO tbl1 VALUES (100, proc_no_params());

evaluate 'Case 4.2: Procedure in INSERT with subquery';
INSERT INTO tbl1 VALUES ((SELECT proc_no_params()), 'aaaa');

-- ========================================
-- TEST 5: Procedures in UPDATE statements - ERROR
-- ========================================

evaluate 'Case 5.1: Procedure in UPDATE statement';
UPDATE tbl1 SET col2 = proc_no_params() WHERE col1 = 1;

evaluate 'Case 5.2: Procedure in both SET and WHERE clauses';
UPDATE tbl1 SET col2 = proc_no_params() WHERE col1 = proc_no_params();

-- ========================================
-- TEST 6: Procedures in DELETE statements - ERROR
-- ========================================

evaluate 'Case 6.1: Procedure in DELETE statement';
DELETE FROM tbl1 WHERE col1 = proc_no_params();

evaluate 'Case 6.2: Procedure in DELETE with subquery';
DELETE FROM tbl1 WHERE col1 IN (SELECT proc_no_params());

-- ========================================
-- Cleanup
-- ========================================
DROP PROCEDURE proc_no_params;
DROP PROCEDURE proc_with_params;
DROP PROCEDURE proc_out_params;
DROP TABLE tbl1;

--+ server-message off