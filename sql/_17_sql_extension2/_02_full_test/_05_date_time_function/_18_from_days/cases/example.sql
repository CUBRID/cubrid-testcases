--cases from dev


SELECT FROM_DAYS(730669);

SELECT FROM_DAYS(719528);

SELECT FROM_DAYS(365);

SELECT FROM_DAYS(366);

SELECT FROM_DAYS(-1);

select from_days(100000000);

-- test for valid input
select from_days(731945), if (from_days(731945) = '2003-12-31', 'ok', 'nok');
select from_days(731945+10), if (from_days(731945+10) = '2004-01-10', 'ok', 'nok');
select from_days(731945-10), if (from_days(731945-10) = '2003-12-21', 'ok', 'nok');
select from_days(731945+365), if (from_days(731945+365) = '2004-12-31', 'ok', 'nok');
select from_days(731945+365*2+1), if (from_days(731945+365*2+1) = '2005-12-31', 'ok', 'nok');
select from_days(731945+365*3+1), if (from_days(731945+365*3+1) = '2006-12-31', 'ok', 'nok');
select from_days(731945+365*4+1), if (from_days(731945+365*4+1) = '2007-12-31', 'ok', 'nok');
select from_days(731945+365*5+1), if (from_days(731945+365*5+1) = '2008-12-31', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select from_days(-1);
select from_days(1000000000);

