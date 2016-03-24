--cases from dev

SELECT MONTH('2008-02-03');

--[er]
SELECT MONTH('00:00:00');

SELECT MONTH('2008-02-03 01:02:03');

SELECT MONTH('2008-02-03 01:02:03.1234');

--[er]
SELECT MONTH('01:02:03');

--[er]
select month('2008-13-01');

select month('2008-12-01' + 40);

-- test for valid date time format
select month(datetime'2003-12-31 01:02:03.1234'), if (month(datetime'2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month(timestamp'2003-12-31 01:02:03'), if (month(timestamp'2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month(date'2003-12-31'), if (month(date'2003-12-31') = 12, 'ok', 'nok');


-- test for valid date, time string format
select month('2003-12-31 01:02:03.1234'), if (month('2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month('2003-12-31 01:02:03'), if (month('2003-12-31 01:02:03') = 12, 'ok', 'nok');
select month('2003-12-31'), if (month('2003-12-31') = 12, 'ok', 'nok');


-- test for valid current_*
select if ((month(current_datetime) - month(current_date)) = 0, 'ok', 'nok');
select if ((month(current_timestamp) - month(current_date)) = 0, 'ok', 'nok');
select if ((month(current_date) - month(current_date)) = 0, 'ok', 'nok');


-- test for special case
select month('1-1-1'), if (month('1-1-1') = 1, 'ok', 'nok');
select month('1/1/1'), if (month('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select month('2000-00-31 01:02:03');
select month('2000-13-31 01:02:03');
select month('2000-12-32 01:02:03');
select month('1999-2-29 01:02:03');

select month('01:02:03');
--select month(current_time);

