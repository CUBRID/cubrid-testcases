--cases from dev


SELECT DAYOFWEEK('2007-02-03');

SELECT DAYOFWEEK('2007-02-03 01:02:03');

SELECT DAYOFWEEK('2007-02-03 01:02:03.1234');

SELECT DAYOFWEEK('01:02:03');

-- test for valid date time format
select dayofweek(datetime'2003-08-23 01:02:03.1234'), if (dayofweek(datetime'2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek(timestamp'2010-08-23 01:02:03'), if (dayofweek(timestamp'2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek(date'2010-08-23'), if (dayofweek(date'2010-08-23') = 2, 'ok', 'nok');


-- test for valid date, time string format
select dayofweek('2010-08-23 01:02:03.1234'), if (dayofweek('2010-08-23 01:02:03.1234') = 2, 'ok', 'nok');
select dayofweek('2010-08-23 01:02:03'), if (dayofweek('2010-08-23 01:02:03') = 2, 'ok', 'nok');
select dayofweek('2010-08-23'), if (dayofweek('2010-08-23') = 2, 'ok', 'nok');


-- test for valid current_*
select if ((dayofweek(current_datetime) - dayofweek(current_date)) = 0, 'ok', 'nok');
select if ((dayofweek(current_timestamp) - dayofweek(current_date)) = 0, 'ok', 'nok');
select if ((dayofweek(current_date) - dayofweek(current_date)) = 0, 'ok', 'nok');

-- test for normal case
select dayofweek('2010-08-01'), if (dayofweek('2010-08-01') = 1, 'ok', 'nok');
select dayofweek('2010-08-02'), if (dayofweek('2010-08-02') = 2, 'ok', 'nok');
select dayofweek('2010-08-03'), if (dayofweek('2010-08-03') = 3, 'ok', 'nok');
select dayofweek('2010-08-04'), if (dayofweek('2010-08-04') = 4, 'ok', 'nok');
select dayofweek('2010-08-05'), if (dayofweek('2010-08-05') = 5, 'ok', 'nok');
select dayofweek('2010-08-06'), if (dayofweek('2010-08-06') = 6, 'ok', 'nok');
select dayofweek('2010-08-07'), if (dayofweek('2010-08-07') = 7, 'ok', 'nok');

select dayofweek('2000-08-01'), if (dayofweek('2000-08-01') = 3, 'ok', 'nok');
select dayofweek('2000-08-02'), if (dayofweek('2000-08-02') = 4, 'ok', 'nok');
select dayofweek('2000-08-03'), if (dayofweek('2000-08-03') = 5, 'ok', 'nok');
select dayofweek('2000-08-04'), if (dayofweek('2000-08-04') = 6, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek('2000-08-07'), if (dayofweek('2000-08-07') = 2, 'ok', 'nok');


-- test for special case
select dayofweek('2000-08-06'), if (dayofweek('2000-08-06') = 1, 'ok', 'nok');
select dayofweek('2000-08-06' - 1), if (dayofweek('2000-08-06' - 1) = 7, 'ok', 'nok');
select dayofweek(date'2000-08-06' - 1), if (dayofweek(date'2000-08-06' - 1) = 7, 'ok', 'nok');
select dayofweek('2000-08-05'), if (dayofweek('2000-08-05') = 7, 'ok', 'nok');
select dayofweek('2000-08-05' + 1), if (dayofweek('2000-08-05' + 1) = 1, 'ok', 'nok');
select dayofweek(date'2000-08-05' + 1), if (dayofweek(date'2000-08-05' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofweek('2000-01-00 01:02:03');
select dayofweek('2000-12-32 01:02:03');
select dayofweek('1999-2-29 01:02:03');

select dayofweek('01:02:03');
--select dayofweek(current_time);

