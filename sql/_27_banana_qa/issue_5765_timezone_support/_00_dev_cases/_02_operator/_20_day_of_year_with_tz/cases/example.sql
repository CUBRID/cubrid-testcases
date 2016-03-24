--cases from dev

SELECT DAYOFYEAR('2007-02-03 01:02:03');

SELECT DAYOFYEAR('2007-02-03 01:02:03.1234');

-- test for valid datetimetz format
select dayofyear(datetimetz'2003-08-23 01:02:03.1234'), if (dayofyear(datetimetz'2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear(timestamptz'2010-08-23 01:02:03'), if (dayofyear(timestamptz'2010-08-23 01:02:03') = 235, 'ok', 'nok');


-- test for valid timetz string format
select dayofyear('2010-08-23 01:02:03.1234'), if (dayofyear('2010-08-23 01:02:03.1234') = 235, 'ok', 'nok');
select dayofyear('2010-08-23 01:02:03'), if (dayofyear('2010-08-23 01:02:03') = 235, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofyear('2000-01-00 01:02:03');
select dayofyear('2000-12-32 01:02:03');
select dayofyear('1999-2-29 01:02:03');
