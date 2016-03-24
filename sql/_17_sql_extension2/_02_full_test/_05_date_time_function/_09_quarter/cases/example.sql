--cases from dev

SELECT QUARTER('2008-04-01');

SELECT QUARTER('2008-04-01 01:02:03');

--SELECT QUARTER(current_time);

-- test for valid date time format
select quarter(datetime'2003-12-31 01:02:03.1234'), if (quarter(datetime'2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter(timestamp'2003-12-31 01:02:03'), if (quarter(timestamp'2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter(date'2003-12-31'), if (quarter(date'2003-12-31') = 4, 'ok', 'nok');


-- test for valid date, time string format
select quarter('2003-12-31 01:02:03.1234'), if (quarter('2003-12-31 01:02:03.1234') = 4, 'ok', 'nok');
select quarter('2003-12-31 01:02:03'), if (quarter('2003-12-31 01:02:03') = 4, 'ok', 'nok');
select quarter('2003-12-31'), if (quarter('2003-12-31') = 4, 'ok', 'nok');


-- test for valid current_*
select if ((quarter(current_datetime) - quarter(current_date)) = 0, 'ok', 'nok');
select if ((quarter(current_timestamp) - quarter(current_date)) = 0, 'ok', 'nok');
select if ((quarter(current_date) - quarter(current_date)) = 0, 'ok', 'nok');


-- test for special case
select quarter('1-1-1'), if (quarter('1-1-1') = 1, 'ok', 'nok');
select quarter('1/1/1'), if (quarter('1/1/1') = 1, 'ok', 'nok');
select quarter('2000-12-31'), if (quarter('2000-12-31') = 4, 'ok', 'nok');
select quarter('2000-12-31' + 1), if (quarter('2000-12-31' + 1) = 1, 'ok', 'nok');
select quarter('2000-1-1' - 1), if (quarter('2000-1-1' - 1) = 4, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select quarter('2000-01-00 01:02:03');
select quarter('2000-12-32 01:02:03');
select quarter('1999-2-29 01:02:03');

select quarter('01:02:03');
--select quarter(current_time);

