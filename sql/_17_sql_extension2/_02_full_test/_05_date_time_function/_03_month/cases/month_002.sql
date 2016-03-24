--pass different formats of string arguments


--1. string values of date format
select month('2010-10-08');

select month('12-25');

select month('8/30');

select month('11/09/1864');



--2. string values of timestamp format
select month('13:14:55 10/08');

select month('2:22:22 8/12/2010');

select month('09:03:22 PM 1988-08-08');

select month('12/12/2008 10:20:55');



--3. string values of datetime format
select month('13:14:55.123 10/08');

select month('2:22:22.333 8/12/2010');

select month('09:03:22.012 PM 1988-08-08');

select month('12/12/1556 10:20:55.567');


