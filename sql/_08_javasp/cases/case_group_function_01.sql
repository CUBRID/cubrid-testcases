--This is a test case to test whether javasp functions support max, min, avg, count, and group_concat functions

DROP TABLE IF EXISTS sales_mon_tbl;

CREATE OR REPLACE FUNCTION test_fc(i int) RETURN int as language java name 'SpTest7.typetestint(int) return int';
CREATE FUNCTION test_fc2(i string) RETURN string as language java name 'jdbc_cubrid415.main1(java.lang.String) return java.lang.String';

CREATE TABLE sales_mon_tbl (
    yyyy INT,
    mm INT,
    sales_sum INT
);
INSERT INTO sales_mon_tbl VALUES
    (2000, 1, 1000), (2000, 2, 770), (2000, 3, 630), (2000, 4, 890),
    (2000, 5, 500), (2000, 6, 900), (2000, 7, 1300), (2000, 8, 1800),
    (2000, 9, 2100), (2000, 10, 1300), (2000, 11, 1500), (2000, 12, 1610),
    (2001, 1, 1010), (2001, 2, 700), (2001, 3, 600), (2001, 4, 900),
    (2001, 5, 1200), (2001, 6, 1400), (2001, 7, 1700), (2001, 8, 1110),
    (2001, 9, 970), (2001, 10, 690), (2001, 11, 710), (2001, 12, 880),
    (2002, 1, 980), (2002, 2, 750), (2002, 3, 730), (2002, 4, 980),
    (2002, 5, 1110), (2002, 6, 570), (2002, 7, 1630), (2002, 8, 1890),
    (2002, 9, 2120), (2002, 10, 970), (2002, 11, 420), (2002, 12, 1300);

SELECT test_fc(yyyy), MAX(test_fc(sales_sum)), MIN(test_fc(sales_sum)), AVG(test_fc(sales_sum)), COUNT(test_fc(yyyy)) FROM sales_mon_tbl GROUP BY test_fc(yyyy);

SELECT COUNT(test_fc(yyyy)), COUNT(DISTINCT (test_fc(yyyy))) FROM sales_mon_tbl;
SELECT GROUP_CONCAT(test_fc(mm)) FROM sales_mon_tbl;
SELECT GROUP_CONCAT(DISTINCT test_fc(mm)) FROM sales_mon_tbl;

SELECT COUNT(test_fc2('select mm from sales_mon_tbl where yyyy='''||2000||''' ')), COUNT(DISTINCT (test_fc2('select mm from sales_mon_tbl where yyyy='''||2000||''' '))) from sales_mon_tbl;
SELECT GROUP_CONCAT(test_fc2('select mm from sales_mon_tbl where yyyy='''||2000||''' limit 1')) FROM sales_mon_tbl;
SELECT GROUP_CONCAT(DISTINCT test_fc2('select mm from sales_mon_tbl where yyyy='''||2000||''' limit 1')) FROM sales_mon_tbl;

DROP FUNCTION test_fc;
DROP FUNCTION test_fc2;
DROP TABLE IF EXISTS sales_mon_tbl;
