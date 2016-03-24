--cases from dev


SELECT WEEK('2008-02-20 01:02:03');
SELECT WEEK('2008-02-20 01:02:03.1234');

-- test for valid date time format
select week(datetimeltz'2003-12-31 01:02:03.1234'), if (week(datetimeltz'2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week(timestampltz'2003-12-31 01:02:03'), if (week(timestampltz'2003-12-31 01:02:03') = 52, 'ok', 'nok');


-- test for valid date, time string format
select week('2003-12-31 01:02:03.1234'), if (week('2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week('2003-12-31 01:02:03'), if (week('2003-12-31 01:02:03') = 52, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select week('2000-01-00 01:02:03');
select week('2000-12-32 01:02:03');
select week('1999-2-29 01:02:03');

select week('01:02:03');
--select week(current_time);

