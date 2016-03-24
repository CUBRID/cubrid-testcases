--cases from dev

SELECT DAYOFMONTH('2007-02-03 01:02:03');

SELECT DAYOFMONTH('2007-02-03 01:02:03.1234');

--[er]
SELECT DAYOFMONTH('01:02:03');


-- test for valid date time format
select dayofmonth(datetimetz'2003-12-31 01:02:03.1234'), if (dayofmonth(datetimetz'2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth(timestamptz'2003-12-31 01:02:03'), if (dayofmonth(timestamptz'2003-12-31 01:02:03') = 31, 'ok', 'nok');

-- test for valid date, time string format
select dayofmonth('2003-12-31 01:02:03.1234'), if (dayofmonth('2003-12-31 01:02:03.1234') = 31, 'ok', 'nok');
select dayofmonth('2003-12-31 01:02:03'), if (dayofmonth('2003-12-31 01:02:03') = 31, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select dayofmonth('2000-01-00 01:02:03');
select dayofmonth('2000-12-32 01:02:03');
select dayofmonth('1999-2-29 01:02:03');

select dayofmonth('01:02:03');
