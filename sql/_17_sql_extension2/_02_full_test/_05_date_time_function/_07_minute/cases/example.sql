--cases from dev

SELECT MINUTE('2008-02-03 10:05:03');

SELECT MINUTE('2008-02-03 10:05:03.1234');

--[er]
SELECT MINUTE('2008-02-03');

SELECT MINUTE('10:05:03');

--[er]
--SELECT MINUTE(current_date);


-- test for valid date time format
select minute(datetime'2003-12-31 01:02:03.1234'), if (minute(datetime'2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute(timestamp'2003-12-31 01:02:03'), if (minute(timestamp'2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute(time'01:02:03'), if (minute(time'01:02:03') = 2, 'ok', 'nok');


-- test for valid date, time string format
select minute('2003-12-31 01:02:03.1234'), if (minute('2003-12-31 01:02:03.1234') = 2, 'ok', 'nok');
select minute('2003-12-31 01:02:03'), if (minute('2003-12-31 01:02:03') = 2, 'ok', 'nok');
select minute('01:02:03'), if (minute('01:02:03') = 2, 'ok', 'nok');


-- test for valid current_*
select if ((minute(current_datetime) - minute(current_time)) = 0, 'ok', 'nok');
select if ((minute(current_timestamp) - minute(current_time)) = 0, 'ok', 'nok');
select if ((minute(current_time) - minute(current_time)) = 0, 'ok', 'nok');


-- test for special case
select minute('23:59:59'), if (minute('23:59:59') = 59, 'ok', 'nok');
select minute('00:00:00'), if (minute('00:00:00') = 0, 'ok', 'nok');
select minute('00:00:00' - 1), if (minute('00:00:00' - 1) = 59, 'ok', 'nok');
select minute('23:59:59' + 1), if (minute('23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select minute('00:61:00');
select minute('00:-10:10');
select minute('2003-12-31');
--select minute(current_date);

