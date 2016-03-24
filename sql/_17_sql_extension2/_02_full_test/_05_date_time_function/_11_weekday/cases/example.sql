--cases from dev

SELECT WEEKDAY('2008-02-03 22:23:00');

SELECT WEEKDAY('2008-02-03 22:23:00.1234');

SELECT WEEKDAY('2007-11-06');

SELECT WEEKDAY('01:02:03');

-- test for valid date time format
select weekday(datetime'2003-08-23 01:02:03.1234'), if (weekday(datetime'2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday(timestamp'2010-08-23 01:02:03'), if (weekday(timestamp'2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday(date'2010-08-23'), if (weekday(date'2010-08-23') = 0, 'ok', 'nok');


-- test for valid date, time string format
select weekday('2010-08-23 01:02:03.1234'), if (weekday('2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday('2010-08-23 01:02:03'), if (weekday('2010-08-23 01:02:03') = 0, 'ok', 'nok');
select weekday('2010-08-23'), if (weekday('2010-08-23') = 0, 'ok', 'nok');


-- test for valid current_*
select if ((weekday(current_datetime) - weekday(current_date)) = 0, 'ok', 'nok');
select if ((weekday(current_timestamp) - weekday(current_date)) = 0, 'ok', 'nok');
select if ((weekday(current_date) - weekday(current_date)) = 0, 'ok', 'nok');

-- test for normal case
select weekday('2010-08-01'), if (weekday('2010-08-01') = 6, 'ok', 'nok');
select weekday('2010-08-02'), if (weekday('2010-08-02') = 0, 'ok', 'nok');
select weekday('2010-08-03'), if (weekday('2010-08-03') = 1, 'ok', 'nok');
select weekday('2010-08-04'), if (weekday('2010-08-04') = 2, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-05') = 3, 'ok', 'nok');
select weekday('2010-08-05'), if (weekday('2010-08-06') = 4, 'ok', 'nok');
select weekday('2010-08-07'), if (weekday('2010-08-07') = 5, 'ok', 'nok');

select weekday('2000-08-01'), if (weekday('2000-08-01') = 1, 'ok', 'nok');
select weekday('2000-08-02'), if (weekday('2000-08-02') = 2, 'ok', 'nok');
select weekday('2000-08-03'), if (weekday('2000-08-03') = 3, 'ok', 'nok');
select weekday('2000-08-04'), if (weekday('2000-08-04') = 4, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-05') = 5, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');


-- test for special case
select weekday('2000-08-07'), if (weekday('2000-08-07') = 0, 'ok', 'nok');
select weekday('2000-08-07' - 1), if (weekday('2000-08-07' - 1) = 6, 'ok', 'nok');
select weekday(date'2000-08-07' - 1), if (weekday(date'2000-08-07' - 1) = 6, 'ok', 'nok');
select weekday('2000-08-05'), if (weekday('2000-08-06') = 6, 'ok', 'nok');
select weekday('2000-08-05' + 1), if (weekday('2000-08-06' + 1) = 0, 'ok', 'nok');
select weekday(date'2000-08-05' + 1), if (weekday(date'2000-08-06' + 1) = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select weekday('2000-01-00 01:02:03');
select weekday('2000-12-32 01:02:03');
select weekday('1999-2-29 01:02:03');

--select weekday(current_time);

