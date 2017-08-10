CREATE TABLE test_table(column_integer INTEGER,
column_smallint SMALLINT,
column_numeric_9_2 NUMERIC(9,2),
column_char_9 CHAR(9),
column_varchar_92 VARCHAR(92),
column_date DATE,
column_bit BIT(4),
column_time TIME,
column_timestamp timestamptz,
column_datetime datetimetz,
monet monetary, 
big bigint, 
float_num float, 
double_num double, 
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '2/28/2001', '12/31/2002', NULL, '07:00:34 PM', '05:55:31 PM 05/04/2002', '05:55:31 PM 05/04/2000', 123.3, 4444444444444, 44.44, 44.44);
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/12/2000', NULL, '00:00:35 AM', NULL, '05:55:31 PM 05/04/2002', 123.3, 4444444444444, 44.44, 44.44);
INSERT INTO test_table VALUES(333, 3333, 3.3, '333', '05:55:31 PM 05/04/2002', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004', 123.3, 4444444444444, 44.44, 44.44);

SELECT DATE_ADD('2008-01-02', INTERVAL 31000000 DAY);
SELECT DATE_ADD('2008-01-02', INTERVAL -31000000 DAY);
SELECT DATE_ADD(column_timestamp, INTERVAL 18 SECOND) from test_table where column_integer = 22;
SELECT DATE_ADD(123, INTERVAL 18 HOUR_MINUTE);
SELECT DATE_ADD(null, INTERVAL 18 HOUR_MINUTE);
SELECT DATE_ADD('1/31/2000', INTERVAL 18 HOUR_MINUTE);
SELECT column_varchar_92, DATE_ADD(column_varchar_92, INTERVAL -1 YEAR) from test_table where column_integer = 1;
SELECT column_varchar_92, DATE_ADD(column_varchar_92, INTERVAL '-1 -1:-1:8000000' DAY_SECOND) from test_table where column_integer = 333;
SELECT column_varchar_92, DATE_ADD(column_date, INTERVAL '99999' DAY) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 MILLISECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 SECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 MINUTE) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 HOUR) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 WEEK) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 MONTH) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 QUARTER) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL 18 YEAR) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '123.-4' SECOND_MILLISECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '99:-400.199' MINUTE_MILLISECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '78:87' MINUTE_SECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '777:888:999.123' HOUR_MILLISECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '-999:444:-23' HOUR_SECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '677:9' HOUR_MINUTE) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '-99999 1:2:3.4' DAY_MILLISECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '44444 1:2:3' DAY_SECOND) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '412 1:2' DAY_MINUTE) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '-1 24' DAY_HOUR) from test_table where column_integer = 333;
SELECT DATE_ADD(column_timestamp, INTERVAL '-55-84' YEAR_MONTH) from test_table where column_integer = 333;
SELECT DATE_ADD(column_time, INTERVAL 18 DAY) from test_table where column_integer = 333;
SELECT DATE_ADD(column_date, INTERVAL 18 HOUR) from test_table where column_integer = 333;
SELECT DATE_ADD('1/31/2000', INTERVAL 1 MONTH);
SELECT DATE_ADD('2/29/2000', INTERVAL 1 YEAR);
SELECT DATE_ADD('12/29/2000', INTERVAL 12 MONTH);
SELECT DATE_ADD('7:23:24 AM', INTERVAL 18 SECOND);
SELECT DATE_ADD('05:55:31 PM 05/04/2000', INTERVAL 18 SECOND);
SELECT DATE_ADD('burzum', INTERVAL 18 SECOND);
SELECT DATE_ADD('12/29/2000', INTERVAL 18 HOUR);
SELECT DATE_ADD('1/1/2000', INTERVAL -1 DAY);
SELECT DATE_ADD('1/1/2000', INTERVAL -1 MONTH);
SELECT DATE_ADD('1/1/2000', INTERVAL -10 MONTH);
SELECT DATE_ADD('1/1/2000', INTERVAL -13 MONTH);
SELECT DATE_ADD('1/1/2000', INTERVAL 13 MONTH);
SELECT DATE_ADD('1/1/2000', INTERVAL 13.47 MONTH);
SELECT DATE_ADD('1/1/2000', INTERVAL big MONTH) from test_table where column_integer = 333;
SELECT DATE_ADD('1/1/2000', INTERVAL column_smallint MONTH) from test_table where column_integer = 333;
SELECT DATE_ADD('1/1/2000', INTERVAL float_num MONTH) from test_table where column_integer = 333;
SELECT DATE_ADD('1/1/2000', INTERVAL double_num MONTH) from test_table where column_integer = 333;

DROP TABLE test_table;