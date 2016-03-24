--cases from dev


SELECT WEEK('2008-02-20');

SELECT WEEK('2008-02-20 01:02:03');

SELECT WEEK('2008-02-20 01:02:03.1234');

SELECT WEEK('01:02:03');

SELECT WEEK('2008-02-20',0);

SELECT WEEK('2008-02-20',1);

SELECT WEEK('2008-12-31',1);

select week('2010-01-01', 0);
select week('2010-01-01', 1);
select week('2010-01-01', 2);
select week('2010-01-01', 3);
select week('2010-01-01', 4);
select week('2010-01-01', 5);
select week('2010-01-01', 6);
select week('2010-01-01', 7);
select week('2010-01-01', 8);

select week('2012-01-01', 0);
select week('2012-01-01', 1);
select week('2012-01-01', 2);
select week('2012-01-01', 3);
select week('2012-01-01', 4);
select week('2012-01-01', 5);
select week('2012-01-01', 6);
select week('2012-01-01', 7);

select week('2011-01-01', 0);
select week('2011-01-01', 1);
select week('2011-01-01', 2);
select week('2011-01-01', 3);
select week('2011-01-01', 4);
select week('2011-01-01', 5);
select week('2011-01-01', 6);
select week('2011-01-01', 7);

select week('01-01-01', 0);
select week('01-01-01', 1);
select week('01-01-01', 2);
select week('01-01-01', 3);
select week('01-01-01', 4);
select week('01-01-01', 5);
select week('01-01-01', 6);
select week('01-01-01', 7);

select week('2008-01-01', 0);
select week('2008-01-01', 1);
select week('2008-01-01', 2);
select week('2008-01-01', 3);
select week('2008-01-01', 4);
select week('2008-01-01', 5);
select week('2008-01-01', 6);
select week('2008-01-01', 7);


-- test for valid date time format
select week(datetime'2003-12-31 01:02:03.1234'), if (week(datetime'2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week(timestamp'2003-12-31 01:02:03'), if (week(timestamp'2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week(date'2003-12-31'), if (week(date'2003-12-31') = 52, 'ok', 'nok');


-- test for valid date, time string format
select week('2003-12-31 01:02:03.1234'), if (week('2003-12-31 01:02:03.1234') = 52, 'ok', 'nok');
select week('2003-12-31 01:02:03'), if (week('2003-12-31 01:02:03') = 52, 'ok', 'nok');
select week('2003-12-31'), if (week('2003-12-31') = 52, 'ok', 'nok');


-- test for valid current_*
select if ((week(current_datetime) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_timestamp) - week(current_date)) = 0, 'ok', 'nok');
select if ((week(current_date) - week(current_date)) = 0, 'ok', 'nok');

-- test for valid input
select week('2000-12-01') - week(date'2000-12-01'-7*14), if (week('2000-12-01') - week(date'2000-12-01'-7*14) = 14, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*8),  if (week('2000-12-01') - week(date'2000-12-01'-7*8)  =  8, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*20), if (week('2000-12-01') - week(date'2000-12-01'-7*20) = 20, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*22), if (week('2000-12-01') - week(date'2000-12-01'-7*22) = 22, 'ok', 'nok');
select week('2000-12-01') - week(date'2000-12-01'-7*35), if (week('2000-12-01') - week(date'2000-12-01'-7*35) = 35, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*14), if (week('1973-12-01') - week(date'1973-12-01'-7*14) = 14, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*8),  if (week('1973-12-01') - week(date'1973-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*20), if (week('1973-12-01') - week(date'1973-12-01'-7*20) = 20, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*22), if (week('1973-12-01') - week(date'1973-12-01'-7*22) = 22, 'ok', 'nok');
select week('1973-12-01') - week(date'1973-12-01'-7*35), if (week('1973-12-01') - week(date'1973-12-01'-7*35) = 35, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*14), if (week('1936-12-01') - week(date'1936-12-01'-7*14) = 14, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*8),  if (week('1936-12-01') - week(date'1936-12-01'-7*8)  =  8, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*20), if (week('1936-12-01') - week(date'1936-12-01'-7*20) = 20, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*22), if (week('1936-12-01') - week(date'1936-12-01'-7*22) = 22, 'ok', 'nok');
select week('1936-12-01') - week(date'1936-12-01'-7*35), if (week('1936-12-01') - week(date'1936-12-01'-7*35) = 35, 'ok', 'nok');


-- test for valid option

select week('2010-01-02', 0), if (week('2010-01-02', 0) = 0, 'ok', 'nok');  -- 0-53 sunday (sunday)
select week('2010-01-03', 0), if (week('2010-01-03', 0) = 1, 'ok', 'nok');

select week('2010-01-02', 2), if (week('2010-01-02', 2) = 52, 'ok', 'nok'); -- 1-53 sunday (sunday)
select week('2010-01-03', 2), if (week('2010-01-03', 2) = 1, 'ok', 'nok');

select week('2010-01-03', 5), if (week('2010-01-03', 5) = 0, 'ok', 'nok'); -- 0-53 sunday (monday)
select week('2010-01-04', 5), if (week('2010-01-04', 5) = 1, 'ok', 'nok');

select week('2010-01-03', 7), if (week('2010-01-03', 7) = 52, 'ok', 'nok'); -- 1-53 sunday (monday)
select week('2010-01-04', 7), if (week('2010-01-04', 7) = 1, 'ok', 'nok');


select week('2010-01-01', 1), if (week('2010-01-01', 1) = 0, 'ok', 'nok');  -- 0-53 3day, monday
select week('2010-01-03', 1), if (week('2010-01-03', 1) = 0, 'ok', 'nok'); 
select week('2010-01-04', 1), if (week('2010-01-04', 1) = 1, 'ok', 'nok'); 
select week('2008-01-01', 1), if (week('2008-01-01', 1) = 1, 'ok', 'nok');
select week('2008-01-06', 1), if (week('2008-01-06', 1) = 1, 'ok', 'nok');
select week('2008-01-07', 1), if (week('2008-01-07', 1) = 2, 'ok', 'nok');

select week('2010-01-01', 3), if (week('2010-01-01', 3) = 53, 'ok', 'nok');  -- 1-53 3day, monday
select week('2010-01-03', 3), if (week('2010-01-03', 3) = 53, 'ok', 'nok'); 
select week('2010-01-04', 3), if (week('2010-01-04', 3) = 1, 'ok', 'nok'); 
select week('2008-01-01', 3), if (week('2008-01-01', 3) = 1, 'ok', 'nok');
select week('2008-01-06', 3), if (week('2008-01-06', 3) = 1, 'ok', 'nok');
select week('2008-01-07', 3), if (week('2008-01-07', 3) = 2, 'ok', 'nok');

select week('2010-01-01', 4), if (week('2010-01-01', 4) = 0, 'ok', 'nok');  -- 0-53 3day, sunday
select week('2010-01-02', 4), if (week('2010-01-02', 4) = 0, 'ok', 'nok'); 
select week('2010-01-03', 4), if (week('2010-01-03', 4) = 1, 'ok', 'nok'); 
select week('2008-01-01', 4), if (week('2008-01-01', 4) = 1, 'ok', 'nok');
select week('2008-01-05', 4), if (week('2008-01-05', 4) = 1, 'ok', 'nok');
select week('2008-01-06', 4), if (week('2008-01-06', 4) = 2, 'ok', 'nok');

select week('2010-01-01', 6), if (week('2010-01-01', 6) = 52, 'ok', 'nok');  -- 1-53 3day, sunday
select week('2010-01-02', 6), if (week('2010-01-02', 6) = 52, 'ok', 'nok'); 
select week('2010-01-03', 6), if (week('2010-01-03', 6) = 1, 'ok', 'nok'); 
select week('2008-01-01', 6), if (week('2008-01-01', 6) = 1, 'ok', 'nok');
select week('2008-01-05', 6), if (week('2008-01-05', 6) = 1, 'ok', 'nok');
select week('2008-01-06', 6), if (week('2008-01-06', 6) = 2, 'ok', 'nok');


-- test for special case
select week('1-1-1'), if (week('1-1-1') = 0, 'ok', 'nok');
select week('1/1/1'), if (week('1/1/1') = 0, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select week('2000-01-00 01:02:03');
select week('2000-12-32 01:02:03');
select week('1999-2-29 01:02:03');

select week('01:02:03');
--select week(current_time);

