--cases from dev


--[er]
SELECT YEAR('01:02:03');

SELECT YEAR('1987-01-01 01:02:03');

SELECT YEAR('1987-01-01 01:02:03.1234');

-- test for valid date time format
select year(datetimetz'2003-12-31 01:02:03.1234'), if (year(datetimetz'2003-12-31 01:02:03.1234') = 2003, 'ok', 'nok');
select year(timestamptz'2003-12-31 01:02:03'), if (year(timestamptz'2003-12-31 01:02:03') = 2003, 'ok', 'nok');


-- check if ER_DATE_CONVERSION is occured.
select year('0000-12-31 01:02:03');
select year('10000-12-31 01:02:03');
select year('2000-12-32 01:02:03');
select year('1999-2-29 01:02:03');

select year('01:02:03');
