-- This test case verifies the following issue: CBRD-25748
-- When a stored procedure is called in the query, the following line is added to the trace:
-- FUNC (time: ?, fetches: ?, ioreads: ?, calls: ?) 

DROP TABLE IF EXISTS sales_tbl;
CREATE TABLE sales_tbl
(dept_no INT, name VARCHAR(20), sales_month INT, sales_amount INT DEFAULT 100, PRIMARY KEY (dept_no, name, sales_month));

INSERT INTO sales_tbl VALUES
(201, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500),
(301, 'Max'    , 1, 300), (301, 'Max'    , 2, 300),
(501, 'Stephan', 1, 300), (501, 'Stephan', 2, DEFAULT), (501, 'Chang'  , 1, 150),(501, 'Chang'  , 2, 150),
(501, 'Sue'    , 1, 150), (501, 'Sue'    , 2, 200);

-- Stored function definitions
CREATE OR REPLACE FUNCTION fn_string (s string) RETURN string AS
BEGIN
    RETURN s;
END;

CREATE OR REPLACE FUNCTION fn_int (i int) RETURN int AS
BEGIN
    RETURN i;
END;

SET TRACE ON;

evaluate '1. Calling a stored procedure in the SELECT list';
SELECT fn_string(name) FROM sales_tbl ORDER BY 1 LIMIT 3;
SHOW TRACE;

evaluate '2. Calling a stored procedure in the WHERE clause';
SELECT name FROM sales_tbl WHERE fn_string(name) = 'George' ORDER BY 1;
SHOW TRACE;

evaluate '3. Calling a stored procedure in the WHERE clause with LIMIT';
SELECT name FROM sales_tbl WHERE fn_int(sales_amount) < 300 ORDER BY 1 LIMIT 5;
SHOW TRACE;

evaluate '4. Calling a stored procedure with CONCAT in the WHERE clause';
SELECT name FROM sales_tbl WHERE CONCAT(fn_string(name), '') = 'George' ORDER BY 1;
SHOW TRACE;

evaluate '5. Calling a stored procedure in both SELECT and WHERE clauses';
SELECT fn_string(name) FROM sales_tbl WHERE fn_int(sales_amount) < 300 ORDER BY 1 LIMIT 5;
SHOW TRACE;

evaluate '6. Calling a stored procedure in the GROUP BY clause';
SELECT dept_no, sum(fn_int(sales_amount))
FROM sales_tbl
GROUP BY fn_int(dept_no)
ORDER BY 1;
SHOW TRACE;

SET TRACE OFF;
DROP FUNCTION fn_string;
DROP FUNCTION fn_int;
DROP TABLE IF EXISTS sales_tbl;
