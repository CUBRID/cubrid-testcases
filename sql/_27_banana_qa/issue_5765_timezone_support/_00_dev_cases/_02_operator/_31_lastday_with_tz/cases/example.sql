--cases from dev

SELECT LAST_DAY('2004-01-01 01:01:01');

SELECT LAST_DAY('2004-01-01 01:01:01.1234');

SELECT LAST_DAY('01:02:03');

-- test for valid date time format
select last_day(datetimetz'2003-08-23 01:02:03.1234'), if (last_day(datetimetz'2010-08-23 01:02:03.1234') = '2010-08-31', 'ok', 'nok');
select last_day(timestamptz'2010-08-23 01:02:03'), if (last_day(timestamptz'2010-08-23 01:02:03') = '2010-08-31', 'ok', 'nok');

-- test for valid date, time string format
select last_day('2010-08-23 01:02:03.1234'), if (last_day('2010-08-23 01:02:03.1234') = '2010-08-31', 'ok', 'nok');
select last_day('2010-08-23 01:02:03'), if (last_day('2010-08-23 01:02:03') = '2010-08-31', 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select last_day('2000-01-00 01:02:03');
select last_day('2000-12-32 01:02:03');
select last_day('1999-2-29 01:02:03');

select last_day('01:02:03');
