--cases from dev


select to_days('1970-01-01');

select to_days('0001-01-01');

select to_days('10000-01-01');

select to_days('1969-12-31');

SELECT TO_DAYS('2007-10-07');

SELECT TO_DAYS('2007-10-07 01:02:03');

SELECT TO_DAYS('2007-10-07 01:02:03.1234');

SELECT TO_DAYS('01:02:03');

-- test for valid date time format
select to_days(datetime'2003-12-31 01:02:03.1234'), if (to_days(datetime'2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days(timestamp'2003-12-31 01:02:03'), if (to_days(timestamp'2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days(date'2003-12-31'), if (to_days(date'2003-12-31') = 731945, 'ok', 'nok');


-- test for valid date, time string format
select to_days('2003-12-31 01:02:03.1234'), if (to_days('2003-12-31 01:02:03.1234') = 731945, 'ok', 'nok');
select to_days('2003-12-31 01:02:03'), if (to_days('2003-12-31 01:02:03') = 731945, 'ok', 'nok');
select to_days('2003-12-31'), if (to_days('2003-12-31') = 731945, 'ok', 'nok');


-- test for valid current_*
select if ((to_days(current_datetime) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_timestamp) - to_days(current_date)) = 0, 'ok', 'nok');
select if ((to_days(current_date) - to_days(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select to_days('2000-02-17') - to_days('1998-06-30'), if (to_days('2000-02-17') - to_days('1998-06-30') = date'2000-02-17' - date'1998-06-30', 'ok', 'nok');
select to_days('3772-02-17') - to_days('1898-06-30'), if (to_days('3772-02-17') - to_days('1898-06-30') = date'3772-02-17' - date'1898-06-30', 'ok', 'nok');
select to_days('2009-02-17') - to_days('2003-02-01'), if (to_days('2009-02-17') - to_days('2003-02-01') = date'2009-02-17' - date'2003-02-01', 'ok', 'nok');


-- test for special case
select to_days('1-1-1'), if (to_days('1-1-1') = 366, 'ok', 'nok');
select to_days('1/1/1'), if (to_days('1/1/1') = 366, 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select to_days('2000-01-00 01:02:03');
select to_days('2000-12-32 01:02:03');
select to_days('1999-2-29 01:02:03');

select to_days('01:02:03');
--select to_days(current_time);

