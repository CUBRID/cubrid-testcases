--pass different formats of string arguments


--1. string values of date format
select day('2010-10-08');

select day('12-25');

select day('8/30');

select day('11/09/1864');



--2. string values of timestamp format
select day('13:14:55 10/08');

select day('2:22:22 8/12/2010');

select day('09:03:22 PM 1988-08-08');

select day('12/12/1999 10:20:55');



--3. string values of datetime format
select day('13:14:55.123 10/08');

select day('2:22:22.333 8/12/2010');

select day('09:03:22.012 PM 1988-08-08');

select day('12/12/1556 10:20:55.567');


