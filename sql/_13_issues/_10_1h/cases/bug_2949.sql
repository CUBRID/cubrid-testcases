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

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '2/28/2001', '12/31/2002', NULL, '07:00:34 PM', '05:55:31 PM 05/04/2002', '05:55:31 PM 05/04/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/12/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 3333, 3.3, '333', '05:55:31 PM 05/04/2002', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');

SELECT TIME_FORMAT(column_datetime, '%H %k %h %I %l %T %r') from test_table where column_integer = 1;
SELECT TIME_FORMAT(column_timestamp, '%H %k %h %I %l %T %r') from test_table where column_integer = 1;
SELECT TIME_FORMAT(column_time, '%H %k %h %I %l %T %r') from test_table where column_integer = 1;
SELECT TIME_FORMAT(column_varchar_92, '%H %k %h %I %l %T %r') from test_table where column_integer = 1;
SELECT TIME_FORMAT('2008-12-31 10:00:00 pm', '%H %k %h %I %l %T %r');
SELECT TIME_FORMAT('2008-12-31 100:00:00.123456', '%H %k %h %I %l'); 
SELECT TIME_FORMAT(TO_TIMESTAMP('10:30:20 AM 12/25/1999'), '%H %h %i %S %s %r');

DROP TABLE test_table;