--cases from dev

SELECT YEAR('1987-01-01');

--[er]
SELECT YEAR('01:02:03');

SELECT YEAR('1987-01-01 01:02:03');

SELECT YEAR('1987-01-01 01:02:03.1234');

--[er]
select year('0000-00-00');

--[er]
select year('10000-01-01');


-- test for valid date time format
select year(datetime'2003-12-31 01:02:03.1234'), if (year(datetime'2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year(timestamp'2003-12-31 01:02:03'), if (year(timestamp'2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year(date'2003-12-31'), if (year(date'2003-12-31') = 2003, 'ok', 'nok');


-- test for valid date, time string format
select year('2003-12-31 01:02:03.1234'), if (year('2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year('2003-12-31 01:02:03'), if (year('2003-12-31 01:02:03') = 2003, 'ok', 'nok');
select year('2003-12-31'), if (year('2003-12-31') = 2003, 'ok', 'nok');


-- test for valid current_*
select if ((year(current_datetime) - year(current_date)) = 0, 'ok', 'nok');
select if ((year(current_timestamp) - year(current_date)) = 0, 'ok', 'nok');
select if ((year(current_date) - year(current_date)) = 0, 'ok', 'nok');


-- test for special year
select year('9999-12-31 01:02:03'), if (year('9999-12-31 01:02:03') = 9999, 'ok', 'nok');
select year('1999-2-28 01:02:03'), if (year('1999-2-28 01:02:03') = 1999, 'ok', 'nok');
select year('1-1-1'), if (year('1-1-1') = 1, 'ok', 'nok');
select year('01/01/2000'), if (year('01/01/2000') = 2000, 'ok', 'nok');
select year('1/1/1'), if (year('1/1/1') = 1, 'ok', 'nok');
select year('2000-000001-000001'), if (year('2000-000001-000001') = 2000, 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select year('0000-12-31 01:02:03');
select year('10000-12-31 01:02:03');
select year('2000-12-32 01:02:03');
select year('1999-2-29 01:02:03');

select year('01:02:03');
--select year(current_time);



