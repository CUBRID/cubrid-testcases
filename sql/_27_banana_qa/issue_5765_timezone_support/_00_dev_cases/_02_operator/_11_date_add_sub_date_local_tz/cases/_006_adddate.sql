CREATE TABLE test_table(column_integer INTEGER,
column_smallint SMALLINT,
column_numeric_9_2 NUMERIC(9,2),
column_char_9 CHAR(9),
column_varchar_92 VARCHAR(92),
column_date DATE,
column_bit BIT(4),
column_time TIME,
column_timestamp timestampltz,
column_datetime datetimeltz,
PRIMARY KEY (column_integer)
);

INSERT INTO test_table VALUES(1, 11, 1.1, '1', '2/28/2001', '12/31/2002', NULL, '07:00:34 PM', '05:55:31 PM 05/04/2002', '05:55:31 PM 05/04/2000');
INSERT INTO test_table VALUES(22, 222, 2.2, '22', '-07:-15:-34.-13 PM', '12/12/2000', NULL, '00:00:35 AM', '05:55:31 PM 05/04/2004', '05:55:31 PM 05/04/2002');
INSERT INTO test_table VALUES(333, 3333, 3.3, NULL, '05:55:31 PM 05/04/2002', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31 PM 05/04/2004');
INSERT INTO test_table VALUES(4444, 444, 4.4, NULL, '05:55:31.421 PM 05/04/2002', '12/31/2004', NULL, '00:00:36 AM', '05:55:31 PM 05/04/2000', '05:55:31.421 PM 05/04/2004');

select * from test_table order by column_smallint;

SELECT ADDDATE('2008-01-02', 31000000);
SELECT ADDDATE('2008-01-02', -31000000);
SELECT ADDDATE(null, 1);
--SELECT ADDDATE(123, 1);
select if(ADDDATE(123, 1)=concat('01/24/',year(sysdate)),'ok','nok');  
SELECT ADDDATE(column_char_9, 1)  from test_table where column_integer = 333;
SELECT ADDDATE(column_varchar_92, 999) from test_table where column_integer = 333;
SELECT ADDDATE(column_varchar_92, -999) from test_table where column_integer = 333;
SELECT ADDDATE(column_datetime, 999) from test_table where column_integer = 333;
SELECT ADDDATE(column_timestamp, 999) from test_table where column_integer = 333;
SELECT ADDDATE(column_timestamp, -999) from test_table where column_integer = 333;
SELECT ADDDATE('05:55:31 PM 05/04/2000', 18);
SELECT ADDDATE(column_time, 18) from test_table where column_integer = 333;
SELECT ADDDATE(column_date, 19) from test_table where column_integer = 333;
SELECT ADDDATE('1/31/2000', 30);
SELECT ADDDATE('7:23:24 AM', 10);
SELECT ADDDATE('burzum', 18);
SELECT ADDDATE('12/29/2000', 18);
SELECT ADDDATE('1/1/2000', -1);

SELECT ADDDATE(column_varchar_92, -999) from test_table order by column_smallint;
SELECT ADDDATE(column_datetime, 999) from test_table order by column_smallint;
SELECT ADDDATE(column_timestamp, 999) from test_table order by column_smallint;
SELECT ADDDATE(column_timestamp, -999) from test_table order by column_smallint;
select adddate('05:55:31.112 PM 05/04/2000', interval 1 day);

DROP TABLE test_table;
