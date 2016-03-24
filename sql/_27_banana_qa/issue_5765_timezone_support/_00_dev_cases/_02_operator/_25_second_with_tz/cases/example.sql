--cases from dev

SELECT SECOND('10:05:03');

SELECT SECOND('2000-01-01 10:05:03');

SELECT SECOND('2000-01-01 10:05:03.1234');

--SELECT SECOND(current_date);

-- test for valid date time format
select second(datetimetz'2003-12-31 01:02:03.1234'), if (second(datetimetz'2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second(timestamptz'2003-12-31 01:02:03'), if (second(timestamptz'2003-12-31 01:02:03') = 3, 'ok', 'nok');


-- test for valid date, time string format
select second('2003-12-31 01:02:03.1234'), if (second('2003-12-31 01:02:03.1234') = 3, 'ok', 'nok');
select second('2003-12-31 01:02:03'), if (second('2003-12-31 01:02:03') = 3, 'ok', 'nok');
select second('01:02:03'), if (second('01:02:03') = 3, 'ok', 'nok');


-- test for special case
select second('23:59:59'), if (second('23:59:59') = 59, 'ok', 'nok');
select second('00:00:00'), if (second('00:00:00') = 0, 'ok', 'nok');
select second('00:00:00' - 1), if (second('00:00:00' - 1) = 59, 'ok', 'nok');
select second('23:59:59' + 1), if (second('23:59:59' + 1) = 0, 'ok', 'nok');


-- check if ER_TIME_CONVERSION is occured.
select second('00:00:60');
select second('00:00:-10');
