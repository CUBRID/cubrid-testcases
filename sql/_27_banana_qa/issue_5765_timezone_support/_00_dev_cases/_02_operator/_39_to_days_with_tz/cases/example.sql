--cases from dev

SELECT TO_DAYS('2007-10-07 01:02:03');

SELECT TO_DAYS('2007-10-07 01:02:03.1234');

SELECT TO_DAYS('01:02:03');

-- test for valid datetimetz format
select to_days(datetimetz'2003-12-31 01:02:03.1234'), if (to_days(datetimetz'2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days(timestamptz'2003-12-31 01:02:03'), if (to_days(timestamptz'2003-12-31 01:02:03') = 731945, 'ok', 'nok');

-- test for valid date, time string format
select to_days('2003-12-31 01:02:03.1234'), if (to_days('2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days('2003-12-31 01:02:03'), if (to_days('2003-12-31 01:02:03') = 731945, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select to_days('2000-01-00 01:02:03');
select to_days('2000-12-32 01:02:03');
select to_days('1999-2-29 01:02:03');

select to_days('01:02:03');
