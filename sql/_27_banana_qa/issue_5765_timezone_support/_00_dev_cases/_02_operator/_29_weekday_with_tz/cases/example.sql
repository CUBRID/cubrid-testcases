--cases from dev

SELECT WEEKDAY('2008-02-03 22:23:00');

SELECT WEEKDAY('2008-02-03 22:23:00.1234');

SELECT WEEKDAY('01:02:03');

-- test for valid date time format
select weekday(datetimetz'2003-08-23 01:02:03.1234'), if (weekday(datetimetz'2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday(timestamptz'2010-08-23 01:02:03'), if (weekday(timestamptz'2010-08-23 01:02:03') = 0, 'ok', 'nok');

-- test for valid date, time string format
select weekday('2010-08-23 01:02:03.1234'), if (weekday('2010-08-23 01:02:03.1234') = 0, 'ok', 'nok');
select weekday('2010-08-23 01:02:03'), if (weekday('2010-08-23 01:02:03') = 0, 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select weekday('2000-01-00 01:02:03');
select weekday('2000-12-32 01:02:03');
select weekday('1999-2-29 01:02:03');
