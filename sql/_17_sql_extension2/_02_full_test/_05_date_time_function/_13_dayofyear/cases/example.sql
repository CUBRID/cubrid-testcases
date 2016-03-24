--cases from dev


SELECT DAYOFYEAR('2007-02-03');

SELECT DAYOFYEAR('2007-02-03 01:02:03');

SELECT DAYOFYEAR('2007-02-03 01:02:03.1234');

SELECT DAYOFYEAR('01:02:03');

-- test for valid date time format
select dayofyear(datetime'2003-08-23 01:02:03.1234'), if (dayofyear(datetime'2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear(timestamp'2010-08-23 01:02:03'), if (dayofyear(timestamp'2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear(date'2010-08-23'), if (dayofyear(date'2010-08-23') = 235, 'ok', 'nok');


-- test for valid date, time string format
select dayofyear('2010-08-23 01:02:03.1234'), if (dayofyear('2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear('2010-08-23 01:02:03'), if (dayofyear('2010-08-23 01:02:03') = 235, 'ok', 'nok');
select dayofyear('2010-08-23'), if (dayofyear('2010-08-23') = 235, 'ok', 'nok');


-- test for valid current_*
select if ((dayofyear(current_datetime) - dayofyear(current_date)) = 0, 'ok', 'nok');
select if ((dayofyear(current_timestamp) - dayofyear(current_date)) = 0, 'ok', 'nok');
select if ((dayofyear(current_date) - dayofyear(current_date)) = 0, 'ok', 'nok');

-- test for normal case
select dayofyear('2010-01-01'), if (dayofyear('2010-01-01') = 1, 'ok', 'nok');
select dayofyear('2010-02-01'), if (dayofyear('2010-02-01') = 32, 'ok', 'nok');
select dayofyear('2010-03-01'), if (dayofyear('2010-03-01') = 60, 'ok', 'nok');
select dayofyear('2010-04-01'), if (dayofyear('2010-04-01') = 91, 'ok', 'nok');
select dayofyear('2010-05-01'), if (dayofyear('2010-05-01') = 121, 'ok', 'nok');
select dayofyear('2010-06-01'), if (dayofyear('2010-06-01') = 152, 'ok', 'nok');
select dayofyear('2010-07-01'), if (dayofyear('2010-07-01') = 182, 'ok', 'nok');
select dayofyear('2010-08-01'), if (dayofyear('2010-08-01') = 213, 'ok', 'nok');
select dayofyear('2010-09-01'), if (dayofyear('2010-09-01') = 244, 'ok', 'nok');
select dayofyear('2010-10-01'), if (dayofyear('2010-10-01') = 274, 'ok', 'nok');
select dayofyear('2010-11-01'), if (dayofyear('2010-11-01') = 305, 'ok', 'nok');
select dayofyear('2010-12-01'), if (dayofyear('2010-12-01') = 335, 'ok', 'nok');


-- test for special case
select dayofyear('2000-01-01'), if (dayofyear('2000-01-01') = 1, 'ok', 'nok');
select dayofyear('2000-01-01' - 1), if (dayofyear('2000-01-01' - 1) = 365, 'ok', 'nok');
select dayofyear(date'2000-01-01' - 1), if (dayofyear(date'2000-01-01' - 1) = 365, 'ok', 'nok');
select dayofyear('2000-12-31'), if (dayofyear('2000-12-31') = 366, 'ok', 'nok');
select dayofyear('2000-12-31' + 1), if (dayofyear('2000-12-31' + 1) = 1, 'ok', 'nok');
select dayofyear(date'2000-12-31' + 1), if (dayofyear(date'2000-12-31' + 1) = 1, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofyear('2000-01-00 01:02:03');
select dayofyear('2000-12-32 01:02:03');
select dayofyear('1999-2-29 01:02:03');

select dayofyear('01:02:03');
--select dayofyear(current_time);

