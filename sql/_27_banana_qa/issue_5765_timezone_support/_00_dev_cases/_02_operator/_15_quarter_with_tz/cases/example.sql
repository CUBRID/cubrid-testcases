--cases from dev

SELECT QUARTER('2008-04-01 01:02:03 Asia/Seoul');

--SELECT QUARTER(current_time);

-- test for valid date-time-tz format
select quarter(datetimetz'2003-12-31 01:02:03.1234 Europe/Paris'), if (quarter(datetimetz'2003-12-31 01:02:03.1234 Europe/Paris') = 4, 'ok', 'nok');
select quarter(timestamptz'2003-12-31 01:02:03 Asia/Seoul'), if (quarter(timestamptz'2003-12-31 01:02:03 Asia/Seoul') = 4, 'ok', 'nok');

-- test for valid date-time-tz string format
select quarter('2003-12-31 01:02:03.1234'), if (quarter('2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter('2003-12-31 01:02:03'), if (quarter('2003-12-31 01:02:03') = 4, 'ok', 'nok');

-- test for special case
select quarter('1-1-1 10:10:10 AM'), if (quarter('1-1-1 10:10:10 AM') = 1, 'ok', 'nok');
select quarter('2000-12-31 10:10:10 AM'), if (quarter('2000-12-31 10:10:10') = 4, 'ok', 'nok');

-- check if ER_DATE_CONVERSION is occured.
select quarter('2000-01-00 01:02:03');
select quarter('2000-12-32 01:02:03');
select quarter('1999-2-29 01:02:03');

select quarter('01:02:03');
