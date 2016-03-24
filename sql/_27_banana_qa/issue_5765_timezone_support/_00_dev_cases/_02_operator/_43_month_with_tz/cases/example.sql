--cases from dev

--[er]
SELECT MONTH('00:00:00');

--[er]
select month('2008-12-01' + 40);

-- test for valid date time format
select month(datetimetz'2003-12-31 01:02:03.1234'), if (month(datetimetz'2003-12-31 01:02:03.1234') = 12, 'ok', 'nok');
select month(timestamptz'2003-12-31 01:02:03'), if (month(timestamptz'2003-12-31 01:02:03') = 12, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select month('2000-00-31 01:02:03');
select month('2000-13-31 01:02:03');
select month('2000-12-32 01:02:03');
select month('1999-2-29 01:02:03');
