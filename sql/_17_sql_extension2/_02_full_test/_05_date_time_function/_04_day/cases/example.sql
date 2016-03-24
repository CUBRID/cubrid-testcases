--cases from dev

SELECT DAYOFMONTH('2007-02-03');

SELECT DAYOFMONTH('2007-02-03 01:02:03');

SELECT DAYOFMONTH('2007-02-03 01:02:03.1234');

--[er]
SELECT DAYOFMONTH('01:02:03');

--[er]
select dayofmonth('0000-00-00');

-- test for valid date time format
select dayofmonth(datetime'2003-12-31 01:02:03.1234'), if (dayofmonth(datetime'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth(timestamp'2003-12-31 01:02:03'), if (dayofmonth(timestamp'2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth(date'2003-12-31'), if (dayofmonth(date'2003-12-31') = 31, 'ok', 'nok');


-- test for valid date, time string format
select dayofmonth('2003-12-31 01:02:03.1234'), if (dayofmonth('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31 01:02:03'), if (dayofmonth('2003-12-31 01:02:03') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31'), if (dayofmonth('2003-12-31') = 31, 'ok', 'nok');


-- test for valid current_*
select if ((dayofmonth(current_datetime) - dayofmonth(current_date)) = 0, 'ok', 'nok');
select if ((dayofmonth(current_timestamp) - dayofmonth(current_date)) = 0, 'ok', 'nok');
select if ((dayofmonth(current_date) - dayofmonth(current_date)) = 0, 'ok', 'nok');


-- test for special case
select dayofmonth('1-1-1'), if (dayofmonth('1-1-1') = 1, 'ok', 'nok');
select dayofmonth('1/1/1'), if (dayofmonth('1/1/1') = 1, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select dayofmonth('2000-01-00 01:02:03');
select dayofmonth('2000-12-32 01:02:03');
select dayofmonth('1999-2-29 01:02:03');

select dayofmonth('01:02:03');
--select dayofmonth(current_time);

