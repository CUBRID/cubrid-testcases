--This is a test case to test whether javasp functions can be used in group by and having clauses

DROP TABLE IF EXISTS sales_tbl;

CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION test_fc2(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';

CREATE TABLE sales_tbl
(dept_no INT, name VARCHAR(20), sales_month INT, sales_amount INT DEFAULT 100, PRIMARY KEY (dept_no, name, sales_month));

INSERT INTO sales_tbl VALUES
(201, 'George' , 1, 450), (201, 'George' , 2, 250), (201, 'Laura'  , 1, 100), (201, 'Laura'  , 2, 500),
(301, 'Max'    , 1, 300), (301, 'Max'    , 2, 300),
(501, 'Stephan', 1, 300), (501, 'Stephan', 2, DEFAULT), (501, 'Chang'  , 1, 150),(501, 'Chang'  , 2, 150),
(501, 'Sue'    , 1, 150), (501, 'Sue'    , 2, 200);

-- selecting and sorting rows with using column alias. success
SELECT test_fc(dept_no) AS a1, avg(sales_amount) AS a2
FROM sales_tbl
WHERE sales_amount > 200 
GROUP BY a1 HAVING a2 > 200
ORDER BY a2;

-- without column alias. success(It works normally in csql, but the operation is wrong in CTP)
SELECT test_fc(dept_no), avg(sales_amount)
FROM sales_tbl
WHERE test_fc(sales_amount) > 200 
GROUP BY test_fc(dept_no) HAVING test_fc(avg(sales_amount)) > 200
ORDER BY test_fc(avg(sales_amount));

-- check WITH ROLLUP using javasp functions. (bug report CBRD-24658)
SELECT test_fc(dept_no), test_fc2(name), avg(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY test_fc(dept_no), test_fc2(name) WITH ROLLUP;

-- not using javasp function. (expect result)
SELECT dept_no, name, avg(sales_amount)
FROM sales_tbl
WHERE sales_amount > 100
GROUP BY dept_no, name WITH ROLLUP;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP TABLE IF EXISTS sales_tbl;
