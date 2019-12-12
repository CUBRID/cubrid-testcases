CREATE TABLE test_table(column_integer INTEGER,
column_smallint SMALLINT,
column_numeric_9_2 NUMERIC(9,2),
column_char_9 CHAR(9),
column_varchar_92 VARCHAR(92),
column_date DATE,
column_bit BIT(4),
column_time TIME,
column_timestamp TIMESTAMP,
column_datetime datetime,
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '12/31/1988', '12/31/2002', NULL, '00:00:34 PM', '05:55:31 PM 05/04/2002', '05:55:31 PM 05/04/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '12/31/1888', '12/31/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 3333, 3.3, null, '12/31/1888', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');

-- should fail
select datediff('2010-10-10','1x');
select datediff(333, 666);
select datediff(null, null);
select datediff(column_char_9, column_char_9) from test_table where column_integer = 333;
SELECT column_datetime, datediff(column_datetime, column_datetime) FROM test_table where column_integer = 1;
SELECT column_timestamp, datediff(column_timestamp, column_timestamp) FROM test_table where column_integer = 1;
SELECT column_date, datediff(column_date, column_date) FROM test_table where column_integer = 1;
SELECT column_varchar_92, datediff(column_varchar_92, '13/31/2004') FROM test_table where column_integer = 1;
SELECT column_varchar_92, datediff('12/32/2004', column_varchar_92) FROM test_table where column_integer = 1;

DROP TABLE test_table;
