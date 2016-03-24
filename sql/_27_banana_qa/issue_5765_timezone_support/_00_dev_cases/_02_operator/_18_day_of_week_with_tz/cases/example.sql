--cases from dev

SELECT DAYOFWEEK('2007-02-03 01:02:03 Asia/Seoul');
SELECT DAYOFWEEK('2007-02-03 01:02:03.1234 Asia/Seoul');

-- test for valid date time format
select dayofweek(datetimetz'2003-08-23 01:02:03.1234 Asia/Seoul'), if (dayofweek(datetimetz'2010-08-23 01:02:03.1234 Asia/Seoul') = 2, 'ok', 'nok');
select dayofweek(timestamptz'2010-08-23 01:02:03 Asia/Seoul'), if (dayofweek(timestamptz'2010-08-23 01:02:03 Asia/Seoul') = 2, 'ok', 'nok');

-- test for valid date, time string format
select dayofweek('2010-08-23 01:02:03.1234 Asia/Seoul'), if (dayofweek('2010-08-23 01:02:03.1234 Asia/Seoul') = 2, 'ok', 'nok');
select dayofweek('2010-08-23 01:02:03 Asia/Seoul'), if (dayofweek('2010-08-23 01:02:03 Asia/Seoul') = 2, 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select dayofweek('2000-01-00 01:02:03 Asia/Seoul');
select dayofweek('2000-12-32 01:02:03 Asia/Seoul');
select dayofweek('1999-2-29 01:02:03 Asia/Seoul');

select dayofweek('01:02:03 Asia/Seoul');
