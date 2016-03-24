--cases from dev


SELECT MAKEDATE(2011,31), MAKEDATE(2011,32);

SELECT MAKEDATE(2011,365), MAKEDATE(2014,365);

SELECT MAKEDATE(2011,0);

SELECT MAKEDATE(0, 1);

SELECT MAKEDATE(1, 1);

SELECT MAKEDATE(10, 1);

SELECT MAKEDATE(69, 1);

SELECT MAKEDATE(80, 1);

SELECT MAKEDATE(99, 1);

SELECT MAKEDATE(100, 1);

SELECT MAKEDATE(1999, 365);

SELECT MAKEDATE(1999, 366);

SELECT MAKEDATE(2000, 366 + 366);

SELECT MAKEDATE(2000, 0);

SELECT MAKEDATE(2000, -1);

SELECT MAKEDATE(10000, 1);

SELECT MAKEDATE(-1, 1);

-- test for valid input
select makedate(2000, 1), if (makedate(2000, 1) = '2000-01-01', 'ok', 'nok');
select makedate(2000, 31+1), if (makedate(2000, 31+1) = '2000-02-01', 'ok', 'nok');
select makedate(2000, 31+29+1), if (makedate(2000, 31+29+1) = '2000-03-01', 'ok', 'nok');
select makedate(2000, 31+29+31+1), if (makedate(2000, 31+29+31+1) = '2000-04-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+1), if (makedate(2000, 31+29+31+30+1) = '2000-05-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+1), if (makedate(2000, 31+29+31+30+31+1) = '2000-06-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+1) = '2000-07-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+1) = '2000-08-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+1) = '2000-09-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+1) = '2000-10-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+1) = '2000-11-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+1) = '2000-12-01', 'ok', 'nok');
select makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31), if (makedate(2000, 31+29+31+30+31+30+31+31+30+31+30+31) = '2000-12-31', 'ok', 'nok');

select makedate(1980, date'05/08/1980'-date'01/01/1980'+1), if (makedate(1980, date'05/08/1980'-date'01/01/1980'+1) = '05/08/1980', 'ok', 'nok');
select makedate(1980, date'09/18/1980'-date'01/01/1980'+1), if (makedate(1980, date'09/18/1980'-date'01/01/1980'+1) = '09/18/1980', 'ok', 'nok');
select makedate(1980, date'11/23/1980'-date'01/01/1980'+1), if (makedate(1980, date'11/23/1980'-date'01/01/1980'+1) = '11/23/1980', 'ok', 'nok');
select makedate(1980, date'07/30/1980'-date'01/01/1980'+1), if (makedate(1980, date'07/30/1980'-date'01/01/1980'+1) = '07/30/1980', 'ok', 'nok');
select makedate(1980, date'08/20/1980'-date'01/01/1980'+1), if (makedate(1980, date'08/20/1980'-date'01/01/1980'+1) = '08/20/1980', 'ok', 'nok');
select makedate(1977, date'05/08/1977'-date'01/01/1977'+1), if (makedate(1977, date'05/08/1977'-date'01/01/1977'+1) = '05/08/1977', 'ok', 'nok');
select makedate(1977, date'09/18/1977'-date'01/01/1977'+1), if (makedate(1977, date'09/18/1977'-date'01/01/1977'+1) = '09/18/1977', 'ok', 'nok');
select makedate(1977, date'11/23/1977'-date'01/01/1977'+1), if (makedate(1977, date'11/23/1977'-date'01/01/1977'+1) = '11/23/1977', 'ok', 'nok');
select makedate(1977, date'07/30/1977'-date'01/01/1977'+1), if (makedate(1977, date'07/30/1977'-date'01/01/1977'+1) = '07/30/1977', 'ok', 'nok');
select makedate(1977, date'08/20/1977'-date'01/01/1977'+1), if (makedate(1977, date'08/20/1977'-date'01/01/1977'+1) = '08/20/1977', 'ok', 'nok');
select makedate(2003, date'05/08/2003'-date'01/01/2003'+1), if (makedate(2003, date'05/08/2003'-date'01/01/2003'+1) = '05/08/2003', 'ok', 'nok');
select makedate(2003, date'09/18/2003'-date'01/01/2003'+1), if (makedate(2003, date'09/18/2003'-date'01/01/2003'+1) = '09/18/2003', 'ok', 'nok');
select makedate(2003, date'11/23/2003'-date'01/01/2003'+1), if (makedate(2003, date'11/23/2003'-date'01/01/2003'+1) = '11/23/2003', 'ok', 'nok');
select makedate(2003, date'07/30/2003'-date'01/01/2003'+1), if (makedate(2003, date'07/30/2003'-date'01/01/2003'+1) = '07/30/2003', 'ok', 'nok');
select makedate(2003, date'08/20/2003'-date'01/01/2003'+1), if (makedate(2003, date'08/20/2003'-date'01/01/2003'+1) = '08/20/2003', 'ok', 'nok');



-- check if ER_DATE_CONVERSION is occured.
select makedate(2000, 0);
select makedate(2000, -1);
select makedate(10000, 1);
select makedate(-1, 1);





