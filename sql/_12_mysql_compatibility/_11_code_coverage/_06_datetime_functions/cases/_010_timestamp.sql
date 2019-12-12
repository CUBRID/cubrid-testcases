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

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '07:00:34 PM', '12/31/2000', NULL, '07:00:34 PM', '05:55:31 PM 03/02/2002', '05:55:31 PM 02/03/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/31/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 3333, 3.3, null, '05:55:31 PM 02/03/2000', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');

SELECT TIMESTAMP(column_datetime, column_char_9) from test_table where column_integer = 333;
SELECT TIMESTAMP(column_datetime, column_varchar_92) from test_table where column_integer = 333;
SELECT TIMESTAMP(column_datetime, null) from test_table where column_integer = 333;
--SELECT TIMESTAMP(123);
select if(TIMESTAMP(123)=concat('12:00:00.000 AM 01/23/',year(sysdate)),'ok','nok');
--SELECT TIMESTAMP(123, 321);
select if(TIMESTAMP(123, 321)=concat('12:03:21.000 AM 01/23/',year(sysdate)),'ok','nok');
SELECT TIMESTAMP(null);
SELECT TIMESTAMP(null, null);
SELECT TIMESTAMP(column_char_9, column_char_9) from test_table where column_integer = 333;
SELECT TIMESTAMP(column_char_9) from test_table where column_integer = 333;
SELECT TIMESTAMP(column_date) from test_table where column_integer = 333;
SELECT TIMESTAMP(column_varchar_92) from test_table where column_integer = 333;
SELECT TIMESTAMP('xxxxxxxxxxxxxxxx');
SELECT TIMESTAMP(column_datetime) from test_table where column_integer = 333;
SELECT TIMESTAMP('05:55:31 PM 02/03/2000', 'xxxxxxxx');


DROP TABLE test_table;
