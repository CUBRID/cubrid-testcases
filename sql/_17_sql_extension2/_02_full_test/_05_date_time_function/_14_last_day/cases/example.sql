--cases from dev

SELECT LAST_DAY('2003-02-05');

SELECT LAST_DAY('2004-02-05');

SELECT LAST_DAY('2004-01-01 01:01:01');

SELECT LAST_DAY('2004-01-01 01:01:01.1234');

SELECT LAST_DAY('2003-03-32');

SELECT LAST_DAY('01:02:03');

-- test for valid date time format
select last_day(datetime'2003-08-23 01:02:03.1234'), if (last_day(datetime'2010-08-23 01:02:03.1234') = '2010-08-31', 'ok', 'nok');
select last_day(timestamp'2010-08-23 01:02:03'), if (last_day(timestamp'2010-08-23 01:02:03') = '2010-08-31', 'ok', 'nok');
select last_day(date'2010-08-23'), if (last_day(date'2010-08-23') = '2010-08-31', 'ok', 'nok');


-- test for valid date, time string format
select last_day('2010-08-23 01:02:03.1234'), if (last_day('2010-08-23 01:02:03.1234') = '2010-08-31', 'ok', 'nok');
select last_day('2010-08-23 01:02:03'), if (last_day('2010-08-23 01:02:03') = '2010-08-31', 'ok', 'nok');
select last_day('2010-08-23'), if (last_day('2010-08-23') = '2010-08-31', 'ok', 'nok');


-- test for valid current_*
select if ((last_day(current_datetime) - last_day(current_date)) = 0, 'ok', 'nok');
select if ((last_day(current_timestamp) - last_day(current_date)) = 0, 'ok', 'nok');
select if ((last_day(current_date) - last_day(current_date)) = 0, 'ok', 'nok');

-- test for normal case
select last_day('2010-01-01'), if (last_day('2010-01-01') = '2010-01-31', 'ok', 'nok');
select last_day('2010-02-01'), if (last_day('2010-02-01') = '2010-02-28', 'ok', 'nok');
select last_day('2010-03-01'), if (last_day('2010-03-01') = '2010-03-31', 'ok', 'nok');
select last_day('2010-04-01'), if (last_day('2010-04-01') = '2010-04-30', 'ok', 'nok');
select last_day('2010-05-01'), if (last_day('2010-05-01') = '2010-05-31', 'ok', 'nok');
select last_day('2010-06-01'), if (last_day('2010-06-01') = '2010-06-30', 'ok', 'nok');
select last_day('2010-07-01'), if (last_day('2010-07-01') = '2010-07-31', 'ok', 'nok');
select last_day('2010-08-01'), if (last_day('2010-08-01') = '2010-08-31', 'ok', 'nok');
select last_day('2010-09-01'), if (last_day('2010-09-01') = '2010-09-30', 'ok', 'nok');
select last_day('2010-10-01'), if (last_day('2010-10-01') = '2010-10-31', 'ok', 'nok');
select last_day('2010-11-01'), if (last_day('2010-11-01') = '2010-11-30', 'ok', 'nok');
select last_day('2010-12-01'), if (last_day('2010-12-01') = '2010-12-31', 'ok', 'nok');


-- test for special case
select last_day('2000-12-31'), if (last_day('2000-12-31') = '2000-12-31', 'ok', 'nok');
select last_day('2000-12-31' + 1), if (last_day('2000-12-31' + 1) = '2001-01-31', 'ok', 'nok');
select last_day(date'2000-12-31' + 1), if (last_day(date'2000-12-31' + 1) = '2001-01-31', 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select last_day('2000-01-00 01:02:03');
select last_day('2000-12-32 01:02:03');
select last_day('1999-2-29 01:02:03');

select last_day('01:02:03');
--select last_day(current_time);

