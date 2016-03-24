--cases from dev

SELECT TIME_TO_SEC('22:23:00');

SELECT TIME_TO_SEC('00:39:38');

select time_to_sec('2000-01-01');

select time_to_sec('2000-01-01 00:39:38');

select time_to_sec('2000-01-01 00:39:38.1234');

-- test for valid date time format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec(datetime'2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(timestamp'2000-12-31 17:34:23'), if (time_to_sec(timestamp'2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec(time'17:34:23'), if (time_to_sec(time'17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid date, time string format
select time_to_sec('2000-12-31 17:34:23.1234'), if (time_to_sec('2000-12-31 17:34:23.1234') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('2000-12-31 17:34:23'), if (time_to_sec('2000-12-31 17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');
select time_to_sec('17:34:23'), if (time_to_sec('17:34:23') = 17*3600 + 34*60 + 23, 'ok', 'nok');


-- test for valid current_*
select if (time_to_sec(current_datetime) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_timestamp) - time_to_sec(current_time) = 0, 'ok', 'nok');
select if (time_to_sec(current_time) - time_to_sec(current_time) = 0, 'ok', 'nok');


-- test for normal case
select time_to_sec('00:00:00'), if (time_to_sec('00:00:00') = 0, 'ok', 'nok');
select time_to_sec('00:00:01'), if (time_to_sec('00:00:01') = 1, 'ok', 'nok');
select time_to_sec('00:01:00'), if (time_to_sec('00:01:00') = 60, 'ok', 'nok');
select time_to_sec('01:00:00'), if (time_to_sec('01:00:00') = 60*60, 'ok', 'nok');
select time_to_sec('03:12:30'), if (time_to_sec('03:12:30') = 3*60*60 + 12*60 + 30, 'ok', 'nok');



-- check if ER_TIME_CONVERSION is occured.
select time_to_sec('24:00:01');
select time_to_sec('00:00:60');


